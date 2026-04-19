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
 */
@Service
public class InventoryService {

    private static final int LOW_STOCK_THRESHOLD = 10;

    private final InventoryRepository inventoryRepository;

    public InventoryService(InventoryRepository inventoryRepository) {
        this.inventoryRepository = inventoryRepository;
    }

    @Transactional(readOnly = true)
    public Page<InventoryItem> getAllItems(Pageable pageable) {
        return inventoryRepository.findAll(pageable);
    }

    @Transactional(readOnly = true)
    @Cacheable("inventory")
    public Optional<InventoryItem> getItemById(Long id) {
        return inventoryRepository.findById(id);
    }

    @Transactional(readOnly = true)
    public Optional<InventoryItem> getItemBySku(String sku) {
        return inventoryRepository.findBySku(sku);
    }

    /**
     * Searches inventory by name or location.
     */
    @Transactional(readOnly = true)
    public List<InventoryItem> search(String query) {
        List<InventoryItem> byName = inventoryRepository.findByNameContainingIgnoreCase(query);
        List<InventoryItem> byLocation = inventoryRepository.findByLocationContainingIgnoreCase(query);

        // Merge results, avoiding duplicates
        byLocation.stream()
                .filter(item -> byName.stream().noneMatch(n -> n.getId().equals(item.getId())))
                .forEach(byName::add);

        return byName;
    }

    /**
     * Returns items with quantity at or below the low-stock threshold.
     */
    @Transactional(readOnly = true)
    public List<InventoryItem> getLowStockItems() {
        return inventoryRepository.findAll().stream()
                .filter(item -> item.getQuantity() <= LOW_STOCK_THRESHOLD)
                .toList();
    }

    @Transactional
    @CacheEvict(value = "inventory", allEntries = true)
    public InventoryItem createItem(InventoryItem item) {
        item.setLastUpdated(LocalDate.now());
        return inventoryRepository.save(item);
    }

    @Transactional
    @CacheEvict(value = "inventory", key = "#id")
    public InventoryItem updateItem(Long id, InventoryItem updated) {
        InventoryItem existing = inventoryRepository.findById(id)
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
