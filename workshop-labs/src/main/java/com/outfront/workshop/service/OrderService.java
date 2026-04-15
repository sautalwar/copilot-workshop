package com.outfront.workshop.service;

import com.outfront.workshop.model.InventoryItem;
import com.outfront.workshop.model.Order;
import com.outfront.workshop.model.Order.OrderStatus;
import com.outfront.workshop.repository.InventoryRepository;
import com.outfront.workshop.repository.OrderRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * Business logic for managing orders.
 * Demonstrates a service-layer pattern common in enterprise Spring apps.
 */
@Service
public class OrderService {

    private final OrderRepository orderRepository;
    private final InventoryRepository inventoryRepository;

    public OrderService(OrderRepository orderRepository, InventoryRepository inventoryRepository) {
        this.orderRepository = orderRepository;
        this.inventoryRepository = inventoryRepository;
    }

    public List<Order> getAllOrders() {
        return orderRepository.findAll();
    }

    public Optional<Order> getOrderById(Long id) {
        return orderRepository.findById(id);
    }

    public List<Order> getOrdersByStatus(OrderStatus status) {
        return orderRepository.findByStatus(status);
    }

    public List<Order> getOrdersByCustomer(String customerName) {
        return orderRepository.findByCustomerNameContainingIgnoreCase(customerName);
    }

    public Order createOrder(Order order) {
        order.setStatus(OrderStatus.PENDING);
        return orderRepository.save(order);
    }

    /**
     * Updates the status of an order. When confirming, checks that enough
     * inventory exists for the ordered product.
     */
    public Order updateOrderStatus(Long id, OrderStatus newStatus) {
        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Order not found: " + id));

        // Business rule: verify inventory before confirming
        if (newStatus == OrderStatus.CONFIRMED) {
            Optional<InventoryItem> item = inventoryRepository
                    .findByNameContainingIgnoreCase(order.getProductName())
                    .stream().findFirst();

            if (item.isPresent() && item.get().getQuantity() < order.getQuantity()) {
                throw new RuntimeException(
                        "Insufficient inventory for '" + order.getProductName()
                        + "': requested " + order.getQuantity()
                        + ", available " + item.get().getQuantity());
            }
        }

        order.setStatus(newStatus);
        return orderRepository.save(order);
    }

    public void deleteOrder(Long id) {
        if (!orderRepository.existsById(id)) {
            throw new RuntimeException("Order not found: " + id);
        }
        orderRepository.deleteById(id);
    }
}
