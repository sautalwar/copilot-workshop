package com.outfront.workshop.repository;

import com.outfront.workshop.model.InventoryItem;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository for inventory item data access.
 * Includes optimized queries for search and low-stock filtering.
 */
@Repository
public interface InventoryRepository extends JpaRepository<InventoryItem, Long> {

    Optional<InventoryItem> findBySku(String sku);

    /**
     * Finds items with quantity at or below the specified threshold.
     * Optimized database query replaces in-memory filtering.
     *
     * @param threshold maximum quantity threshold
     * @return list of low-stock items
     */
    List<InventoryItem> findByQuantityLessThanEqual(int threshold);

    /**
     * Finds items with quantity at or below the specified threshold (paginated).
     *
     * @param threshold maximum quantity threshold
     * @param pageable pagination parameters
     * @return page of low-stock items
     */
    Page<InventoryItem> findByQuantityLessThanEqual(int threshold, Pageable pageable);

    /**
     * Searches inventory by name OR location in a single query.
     * Replaces two separate queries with in-memory merge.
     *
     * @param query search term
     * @return distinct items matching name or location
     */
    @Query("SELECT DISTINCT i FROM InventoryItem i WHERE LOWER(i.name) LIKE LOWER(CONCAT('%', :query, '%')) OR LOWER(i.location) LIKE LOWER(CONCAT('%', :query, '%'))")
    List<InventoryItem> findByNameOrLocation(@Param("query") String query);

    /**
     * Searches inventory by name OR location in a single query (paginated).
     *
     * @param query search term
     * @param pageable pagination parameters
     * @return page of items matching name or location
     */
    @Query("SELECT DISTINCT i FROM InventoryItem i WHERE LOWER(i.name) LIKE LOWER(CONCAT('%', :query, '%')) OR LOWER(i.location) LIKE LOWER(CONCAT('%', :query, '%'))")
    Page<InventoryItem> findByNameOrLocation(@Param("query") String query, Pageable pageable);

    /**
     * Retrieves all items with pagination support.
     *
     * @param pageable pagination parameters
     * @return page of inventory items
     */
    Page<InventoryItem> findAll(Pageable pageable);
}
