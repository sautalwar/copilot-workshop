package com.outfront.workshop.service;

import com.outfront.workshop.model.InventoryItem;
import com.outfront.workshop.model.Order;
import com.outfront.workshop.model.Order.OrderStatus;
import com.outfront.workshop.repository.InventoryRepository;
import com.outfront.workshop.repository.OrderRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Unit tests for OrderService using Mockito mocks.
 * Tests business logic without Spring context or database.
 */
@ExtendWith(MockitoExtension.class)
class OrderServiceTest {

    @Mock
    private OrderRepository orderRepository;

    @Mock
    private InventoryRepository inventoryRepository;

    @InjectMocks
    private OrderService orderService;

    private Order testOrder;
    private InventoryItem testInventoryItem;

    @BeforeEach
    void setUp() {
        testOrder = new Order("Test Customer", "LED Panel 72x36", 5, LocalDate.now());
        testOrder.setId(1L);
        testOrder.setStatus(OrderStatus.PENDING);

        testInventoryItem = new InventoryItem("LED Panel 72x36", "SKU-LED-72x36", 50, "Warehouse A");
        testInventoryItem.setId(1L);
    }

    @Test
    void shouldReturnAllOrders_whenGetAllOrdersCalled() {
        // Given
        Pageable pageable = PageRequest.of(0, 10);
        Page<Order> expectedPage = new PageImpl<>(List.of(testOrder));
        when(orderRepository.findAll(pageable)).thenReturn(expectedPage);

        // When
        Page<Order> result = orderService.getAllOrders(pageable);

        // Then
        assertThat(result).isNotNull();
        assertThat(result.getContent()).hasSize(1);
        assertThat(result.getContent().get(0).getCustomerName()).isEqualTo("Test Customer");
        verify(orderRepository).findAll(pageable);
    }

    @Test
    void shouldReturnOrder_whenGetOrderByIdCalledWithValidId() {
        // Given
        when(orderRepository.findById(1L)).thenReturn(Optional.of(testOrder));

        // When
        Optional<Order> result = orderService.getOrderById(1L);

        // Then
        assertThat(result).isPresent();
        assertThat(result.get().getCustomerName()).isEqualTo("Test Customer");
        verify(orderRepository).findById(1L);
    }

    @Test
    void shouldReturnEmpty_whenGetOrderByIdCalledWithInvalidId() {
        // Given
        when(orderRepository.findById(999L)).thenReturn(Optional.empty());

        // When
        Optional<Order> result = orderService.getOrderById(999L);

        // Then
        assertThat(result).isEmpty();
        verify(orderRepository).findById(999L);
    }

    @Test
    void shouldReturnOrdersByStatus_whenGetOrdersByStatusCalled() {
        // Given
        Pageable pageable = PageRequest.of(0, 10);
        Page<Order> expectedPage = new PageImpl<>(List.of(testOrder));
        when(orderRepository.findByStatus(OrderStatus.PENDING, pageable)).thenReturn(expectedPage);

        // When
        Page<Order> result = orderService.getOrdersByStatus(OrderStatus.PENDING, pageable);

        // Then
        assertThat(result).isNotNull();
        assertThat(result.getContent()).hasSize(1);
        assertThat(result.getContent().get(0).getStatus()).isEqualTo(OrderStatus.PENDING);
        verify(orderRepository).findByStatus(OrderStatus.PENDING, pageable);
    }

    @Test
    void shouldReturnOrdersByCustomer_whenGetOrdersByCustomerCalled() {
        // Given
        Pageable pageable = PageRequest.of(0, 10);
        Page<Order> expectedPage = new PageImpl<>(List.of(testOrder));
        when(orderRepository.findByCustomerNameContainingIgnoreCase("Test", pageable))
                .thenReturn(expectedPage);

        // When
        Page<Order> result = orderService.getOrdersByCustomer("Test", pageable);

        // Then
        assertThat(result).isNotNull();
        assertThat(result.getContent()).hasSize(1);
        assertThat(result.getContent().get(0).getCustomerName()).contains("Test");
        verify(orderRepository).findByCustomerNameContainingIgnoreCase("Test", pageable);
    }

    @Test
    void shouldCreateOrder_whenCreateOrderCalledWithValidOrder() {
        // Given
        Order newOrder = new Order("New Customer", "Digital Signage", 3, LocalDate.now());
        Order savedOrder = new Order("New Customer", "Digital Signage", 3, LocalDate.now());
        savedOrder.setId(2L);
        savedOrder.setStatus(OrderStatus.PENDING);

        when(orderRepository.save(any(Order.class))).thenReturn(savedOrder);

        // When
        Order result = orderService.createOrder(newOrder);

        // Then
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(2L);
        assertThat(result.getStatus()).isEqualTo(OrderStatus.PENDING);
        verify(orderRepository).save(any(Order.class));
    }

    @Test
    void shouldUpdateOrderStatus_whenUpdateOrderStatusCalledWithValidData() {
        // Given
        when(orderRepository.findById(1L)).thenReturn(Optional.of(testOrder));
        when(orderRepository.save(any(Order.class))).thenReturn(testOrder);

        // When
        Order result = orderService.updateOrderStatus(1L, OrderStatus.SHIPPED);

        // Then
        assertThat(result).isNotNull();
        assertThat(result.getStatus()).isEqualTo(OrderStatus.SHIPPED);
        verify(orderRepository).findById(1L);
        verify(orderRepository).save(testOrder);
    }

    @Test
    void shouldThrowException_whenUpdateOrderStatusCalledWithInvalidId() {
        // Given
        when(orderRepository.findById(999L)).thenReturn(Optional.empty());

        // When / Then
        assertThatThrownBy(() -> orderService.updateOrderStatus(999L, OrderStatus.CONFIRMED))
                .isInstanceOf(RuntimeException.class)
                .hasMessageContaining("Order not found: 999");
        verify(orderRepository).findById(999L);
        verify(orderRepository, never()).save(any(Order.class));
    }

    @Test
    void shouldConfirmOrder_whenSufficientInventoryExists() {
        // Given
        when(orderRepository.findById(1L)).thenReturn(Optional.of(testOrder));
        when(inventoryRepository.findByNameContainingIgnoreCase(testOrder.getProductName()))
                .thenReturn(List.of(testInventoryItem));
        when(orderRepository.save(any(Order.class))).thenReturn(testOrder);

        // When
        Order result = orderService.updateOrderStatus(1L, OrderStatus.CONFIRMED);

        // Then
        assertThat(result).isNotNull();
        assertThat(result.getStatus()).isEqualTo(OrderStatus.CONFIRMED);
        verify(inventoryRepository).findByNameContainingIgnoreCase(testOrder.getProductName());
        verify(orderRepository).save(testOrder);
    }

    @Test
    void shouldThrowException_whenConfirmingOrderWithInsufficientInventory() {
        // Given
        testOrder.setQuantity(100); // Request more than available
        when(orderRepository.findById(1L)).thenReturn(Optional.of(testOrder));
        when(inventoryRepository.findByNameContainingIgnoreCase(testOrder.getProductName()))
                .thenReturn(List.of(testInventoryItem)); // Only 50 available

        // When / Then
        assertThatThrownBy(() -> orderService.updateOrderStatus(1L, OrderStatus.CONFIRMED))
                .isInstanceOf(RuntimeException.class)
                .hasMessageContaining("Insufficient inventory");
        verify(inventoryRepository).findByNameContainingIgnoreCase(testOrder.getProductName());
        verify(orderRepository, never()).save(any(Order.class));
    }

    @Test
    void shouldDeleteOrder_whenDeleteOrderCalledWithValidId() {
        // Given
        when(orderRepository.existsById(1L)).thenReturn(true);
        doNothing().when(orderRepository).deleteById(1L);

        // When
        orderService.deleteOrder(1L);

        // Then
        verify(orderRepository).existsById(1L);
        verify(orderRepository).deleteById(1L);
    }

    @Test
    void shouldThrowException_whenDeleteOrderCalledWithInvalidId() {
        // Given
        when(orderRepository.existsById(999L)).thenReturn(false);

        // When / Then
        assertThatThrownBy(() -> orderService.deleteOrder(999L))
                .isInstanceOf(RuntimeException.class)
                .hasMessageContaining("Order not found: 999");
        verify(orderRepository).existsById(999L);
        verify(orderRepository, never()).deleteById(anyLong());
    }
}
