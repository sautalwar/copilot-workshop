package com.outfront.workshop.service;

import com.outfront.workshop.model.InventoryItem;
import com.outfront.workshop.model.Order;
import com.outfront.workshop.model.Order.OrderStatus;
import com.outfront.workshop.repository.InventoryRepository;
import com.outfront.workshop.repository.OrderRepository;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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

    @Transactional(readOnly = true)
    public Page<Order> getAllOrders(Pageable pageable) {
        return orderRepository.findAll(pageable);
    }

    @Transactional(readOnly = true)
    @Cacheable("orders")
    public Optional<Order> getOrderById(Long id) {
        return orderRepository.findById(id);
    }

    @Transactional(readOnly = true)
    public Page<Order> getOrdersByStatus(OrderStatus status, Pageable pageable) {
        return orderRepository.findByStatus(status, pageable);
    }

    @Transactional(readOnly = true)
    public Page<Order> getOrdersByCustomer(String customerName, Pageable pageable) {
        return orderRepository.findByCustomerNameContainingIgnoreCase(customerName, pageable);
    }

    @Transactional
    @CacheEvict(value = "orders", allEntries = true)
    public Order createOrder(Order order) {
        order.setStatus(OrderStatus.PENDING);
        return orderRepository.save(order);
    }

    /**
     * Updates the status of an order. When confirming, checks that enough
     * inventory exists for the ordered product.
     */
    @Transactional
    @CacheEvict(value = "orders", key = "#id")
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

    @Transactional
    @CacheEvict(value = "orders", key = "#id")
    public void deleteOrder(Long id) {
        if (!orderRepository.existsById(id)) {
            throw new RuntimeException("Order not found: " + id);
        }
        orderRepository.deleteById(id);
    }
}
