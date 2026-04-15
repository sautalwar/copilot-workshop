package com.outfront.workshop.model;

import jakarta.persistence.*;
import java.time.LocalDate;

/**
 * Represents a customer order in the OutFront OMS.
 * Maps to the legacy system's ORDER_HEADER table concept.
 */
@Entity
@Table(name = "orders")
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String customerName;

    @Column(nullable = false)
    private String productName;

    @Column(nullable = false)
    private int quantity;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private OrderStatus status = OrderStatus.PENDING;

    @Column(nullable = false)
    private LocalDate orderDate;

    private String notes;

    public enum OrderStatus {
        PENDING, CONFIRMED, SHIPPED
    }

    // Default constructor required by JPA
    public Order() {}

    public Order(String customerName, String productName, int quantity, LocalDate orderDate) {
        this.customerName = customerName;
        this.productName = productName;
        this.quantity = quantity;
        this.orderDate = orderDate;
        this.status = OrderStatus.PENDING;
    }

    // --- Getters and Setters ---

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public OrderStatus getStatus() { return status; }
    public void setStatus(OrderStatus status) { this.status = status; }

    public LocalDate getOrderDate() { return orderDate; }
    public void setOrderDate(LocalDate orderDate) { this.orderDate = orderDate; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
