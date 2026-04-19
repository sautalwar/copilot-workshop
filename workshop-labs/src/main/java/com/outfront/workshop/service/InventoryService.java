package com.outfront.workshop.service;

import com.outfront.workshop.model.InventoryItem;
import com.outfront.workshop.repository.InventoryRepository;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * Business logic for managing billboard/signage inventory.
 * All read operations are transactional with readOnly=true for performance.
 * Caching is enabled on SKU lookups.
 */
@Service
@Transactional(readOnly = true)
public class InventoryService {

    private static final int LOW_STOCK_THRESHOLD = 10;

    private final InventoryRepository inventoryRepository;

    public InventoryService(final InventoryRepository inventoryRepository) {
        this.inventoryRepository = inventoryRepository;
    }

    /**
     * Retrieves all inventory items (non-paginated).
     *
     * @return list of all items
     */
    public List<InventoryItem> getAllItems() {
        return inventoryRepository.findAll();
    }

    /**
     * Retrieves all inventory items with pagination.
     *
     * @param pageable pagination parameters
     * @return page of inventory items
     */
    public Page<InventoryItem> getAllItems(final Pageable pageable) {
        return inventoryRepository.findAll(pageable);
    }

    /**
     * Retrieves an item by ID.
     *
     * @param id item ID
     * @return optional containing the item if found
     */
    public Optional<InventoryItem> getItemById(final Long id) {
        return inventoryRepository.findById(id);
    }

    /**
     * Retrieves an item by SKU with caching.
     * Cache key is the SKU, cache expires after 10 minutes.
     *
     * @param sku item SKU
     * @return optional containing the item if found
     */
    @Cacheable(value = "inventory", key = "#sku")
    public Optional<InventoryItem> getItemBySku(final String sku) {
        return inventoryRepository.findBySku(sku);
    }

    /**
     * Searches inventory by name or location using a single optimized query.
     * Replaces previous implementation that ran 2 queries + in-memory merge.
     *
     * @param query search term
     * @return list of matching items
     */
    public List<InventoryItem> search(final String query) {
        return inventoryRepository.findByNameOrLocation(query);
    }

    /**
     * Searches inventory by name or location with pagination.
     *
     * @param query search term
     * @param pageable pagination parameters
     * @return page of matching items
     */
    public Page<InventoryItem> search(final String query, final Pageable pageable) {
        return inventoryRepository.findByNameOrLocation(query, pageable);
    }

    /**
     * Returns items with quantity at or below the low-stock threshold.
     * Uses database-level filtering instead of fetching all items into memory.
     *
     * @return list of low-stock items
     */
    public List<InventoryItem> getLowStockItems() {
        return inventoryRepository.findByQuantityLessThanEqual(LOW_STOCK_THRESHOLD);
    }

    /**
     * Returns items with quantity at or below the low-stock threshold (paginated).
     *
     * @param pageable pagination parameters
     * @return page of low-stock items
     */
    public Page<InventoryItem> getLowStockItems(final Pageable pageable) {
        return inventoryRepository.findByQuantityLessThanEqual(LOW_STOCK_THRESHOLD, pageable);
    }

    /**
     * Creates a new inventory item.
     * Evicts all cached items to ensure consistency.
     *
     * @param item the item to create
     * @return the created item with ID
     */
    @Transactional
    @CacheEvict(value = "inventory", allEntries = true)
    public InventoryItem createItem(final InventoryItem item) {
        item.setLastUpdated(LocalDate.now());
        return inventoryRepository.save(item);
    }

    /**
     * Updates an existing inventory item.
     * Evicts the specific item from cache by ID.
     *
     * @param id the item ID
     * @param updated the updated item data
     * @return the updated item
     * @throws RuntimeException if item not found
     */
    @Transactional
    @CacheEvict(value = "inventory", key = "#result.sku")
    public InventoryItem updateItem(final Long id, final InventoryItem updated) {
        final InventoryItem existing = inventoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Inventory item not found: " + id));

        existing.setName(updated.getName());
        existing.setSku(updated.getSku());
        existing.setDescription(updated.getDescription());
        existing.setQuantity(updated.getQuantity());
        existing.setLocation(updated.getLocation());
        existing.setLastUpdated(LocalDate.now());

        return inventoryRepository.save(existing);
    }
}
