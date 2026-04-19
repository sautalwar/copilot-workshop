package com.outfront.workshop.model;

import jakarta.persistence.*;
import java.time.LocalDate;

/**
 * Represents a physical inventory item in the OutFront warehouse system.
 * Tracks billboard components, displays, and accessories.
 * Indexed on name, location, and quantity for optimized search and filtering.
 */
@Entity
@Table(name = "inventory_item", indexes = {
    @Index(name = "idx_inventory_name", columnList = "name"),
    @Index(name = "idx_inventory_location", columnList = "location"),
    @Index(name = "idx_inventory_quantity", columnList = "quantity")
})
public class InventoryItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String sku;

    @Column(nullable = false)
    private String name;

    private String description;

    @Column(nullable = false)
    private int quantity;

    private String location;

    private LocalDate lastUpdated;

    // Default constructor required by JPA
    public InventoryItem() {}

    public InventoryItem(String sku, String name, String description, int quantity, String location) {
        this.sku = sku;
        this.name = name;
        this.description = description;
        this.quantity = quantity;
        this.location = location;
        this.lastUpdated = LocalDate.now();
    }

    // --- Getters and Setters ---

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getSku() { return sku; }
    public void setSku(String sku) { this.sku = sku; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public LocalDate getLastUpdated() { return lastUpdated; }
    public void setLastUpdated(LocalDate lastUpdated) { this.lastUpdated = lastUpdated; }
}
