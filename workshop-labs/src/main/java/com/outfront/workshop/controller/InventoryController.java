package com.outfront.workshop.controller;

import com.outfront.workshop.model.InventoryItem;
import com.outfront.workshop.service.InventoryService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/**
 * REST controller for inventory management.
 * Provides CRUD and search operations for billboard/signage inventory.
 * All list endpoints support pagination via page and size query parameters.
 */
@RestController
@RequestMapping("/api/inventory")
public class InventoryController {

    private final InventoryService inventoryService;

    public InventoryController(final InventoryService inventoryService) {
        this.inventoryService = inventoryService;
    }

    /**
     * Retrieves all inventory items with pagination.
     *
     * @param page zero-based page index (default: 0)
     * @param size page size (default: 20)
     * @return paginated list of inventory items
     */
    @GetMapping
    public ResponseEntity<Page<InventoryItem>> getAllItems(
            @RequestParam(defaultValue = "0") final int page,
            @RequestParam(defaultValue = "20") final int size) {
        final Pageable pageable = PageRequest.of(page, size);
        return ResponseEntity.ok(inventoryService.getAllItems(pageable));
    }

    /**
     * Retrieves a single inventory item by ID.
     *
     * @param id item ID
     * @return item if found, 404 otherwise
     */
    @GetMapping("/{id}")
    public ResponseEntity<InventoryItem> getItemById(@PathVariable final Long id) {
        return inventoryService.getItemById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * Search inventory by name or location with pagination.
     * Example: GET /api/inventory/search?query=Newark&page=0&size=10
     *
     * @param query search term
     * @param page zero-based page index (default: 0)
     * @param size page size (default: 20)
     * @return paginated search results
     */
    @GetMapping("/search")
    public ResponseEntity<Page<InventoryItem>> searchItems(
            @RequestParam final String query,
            @RequestParam(defaultValue = "0") final int page,
            @RequestParam(defaultValue = "20") final int size) {
        final Pageable pageable = PageRequest.of(page, size);
        return ResponseEntity.ok(inventoryService.search(query, pageable));
    }

    /**
     * Returns items with low stock levels (quantity <= 10) with pagination.
     * Example: GET /api/inventory/low-stock?page=0&size=5
     *
     * @param page zero-based page index (default: 0)
     * @param size page size (default: 20)
     * @return paginated list of low-stock items
     */
    @GetMapping("/low-stock")
    public ResponseEntity<Page<InventoryItem>> getLowStockItems(
            @RequestParam(defaultValue = "0") final int page,
            @RequestParam(defaultValue = "20") final int size) {
        final Pageable pageable = PageRequest.of(page, size);
        return ResponseEntity.ok(inventoryService.getLowStockItems(pageable));
    }

    /**
     * Creates a new inventory item.
     *
     * @param item the item to create
     * @return the created item with HTTP 201
     */
    @PostMapping
    public ResponseEntity<InventoryItem> createItem(@RequestBody final InventoryItem item) {
        final InventoryItem created = inventoryService.createItem(item);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    /**
     * Updates an existing inventory item.
     *
     * @param id item ID
     * @param item updated item data
     * @return the updated item, or 404 if not found
     */
    @PutMapping("/{id}")
    public ResponseEntity<InventoryItem> updateItem(
            @PathVariable final Long id,
            @RequestBody final InventoryItem item) {
        try {
            final InventoryItem updated = inventoryService.updateItem(id, item);
            return ResponseEntity.ok(updated);
        } catch (final RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
}
