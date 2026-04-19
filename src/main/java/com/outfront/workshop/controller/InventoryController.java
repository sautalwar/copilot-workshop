package com.outfront.workshop.controller;

import com.outfront.workshop.model.InventoryItem;
import com.outfront.workshop.service.InventoryService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * REST controller for inventory management.
 * Provides CRUD and search operations for billboard/signage inventory.
 */
@RestController
@RequestMapping("/api/inventory")
public class InventoryController {

    private final InventoryService inventoryService;

    public InventoryController(InventoryService inventoryService) {
        this.inventoryService = inventoryService;
    }

    @GetMapping
    public Page<InventoryItem> getAllItems(Pageable pageable) {
        return inventoryService.getAllItems(pageable);
    }

    @GetMapping("/{id}")
    public ResponseEntity<InventoryItem> getItemById(@PathVariable Long id) {
        return inventoryService.getItemById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * Search inventory by name or location.
     * Example: GET /api/inventory/search?query=Newark
     */
    @GetMapping("/search")
    public List<InventoryItem> searchItems(@RequestParam String query) {
        return inventoryService.search(query);
    }

    /**
     * Returns items with low stock levels.
     */
    @GetMapping("/low-stock")
    public List<InventoryItem> getLowStockItems() {
        return inventoryService.getLowStockItems();
    }

    @PostMapping
    public ResponseEntity<InventoryItem> createItem(@RequestBody InventoryItem item) {
        InventoryItem created = inventoryService.createItem(item);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PutMapping("/{id}")
    public ResponseEntity<InventoryItem> updateItem(@PathVariable Long id,
                                                    @RequestBody InventoryItem item) {
        try {
            InventoryItem updated = inventoryService.updateItem(id, item);
            return ResponseEntity.ok(updated);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
}
