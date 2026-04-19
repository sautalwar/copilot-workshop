package com.outfront.workshop.service;

import com.outfront.workshop.model.InventoryItem;
import com.outfront.workshop.repository.InventoryRepository;
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
 * Unit tests for InventoryService using Mockito mocks.
 * Tests business logic for inventory management without Spring context.
 */
@ExtendWith(MockitoExtension.class)
class InventoryServiceTest {

    @Mock
    private InventoryRepository inventoryRepository;

    @InjectMocks
    private InventoryService inventoryService;

    private InventoryItem testItem;
    private InventoryItem lowStockItem;

    @BeforeEach
    void setUp() {
        testItem = new InventoryItem("LED Panel 72x36", "SKU-LED-72x36", 50, "Warehouse A");
        testItem.setId(1L);
        testItem.setLastUpdated(LocalDate.now());

        lowStockItem = new InventoryItem("Transit Display Module", "SKU-TDM-001", 5, "Warehouse B");
        lowStockItem.setId(2L);
        lowStockItem.setLastUpdated(LocalDate.now());
    }

    @Test
    void shouldReturnAllItems_whenGetAllItemsCalled() {
        // Given
        Pageable pageable = PageRequest.of(0, 10);
        Page<InventoryItem> expectedPage = new PageImpl<>(List.of(testItem, lowStockItem));
        when(inventoryRepository.findAll(pageable)).thenReturn(expectedPage);

        // When
        Page<InventoryItem> result = inventoryService.getAllItems(pageable);

        // Then
        assertThat(result).isNotNull();
        assertThat(result.getContent()).hasSize(2);
        verify(inventoryRepository).findAll(pageable);
    }

    @Test
    void shouldReturnItem_whenGetItemByIdCalledWithValidId() {
        // Given
        when(inventoryRepository.findById(1L)).thenReturn(Optional.of(testItem));

        // When
        Optional<InventoryItem> result = inventoryService.getItemById(1L);

        // Then
        assertThat(result).isPresent();
        assertThat(result.get().getName()).isEqualTo("LED Panel 72x36");
        verify(inventoryRepository).findById(1L);
    }

    @Test
    void shouldReturnEmpty_whenGetItemByIdCalledWithInvalidId() {
        // Given
        when(inventoryRepository.findById(999L)).thenReturn(Optional.empty());

        // When
        Optional<InventoryItem> result = inventoryService.getItemById(999L);

        // Then
        assertThat(result).isEmpty();
        verify(inventoryRepository).findById(999L);
    }

    @Test
    void shouldReturnItem_whenGetItemBySkuCalledWithValidSku() {
        // Given
        when(inventoryRepository.findBySku("SKU-LED-72x36")).thenReturn(Optional.of(testItem));

        // When
        Optional<InventoryItem> result = inventoryService.getItemBySku("SKU-LED-72x36");

        // Then
        assertThat(result).isPresent();
        assertThat(result.get().getSku()).isEqualTo("SKU-LED-72x36");
        verify(inventoryRepository).findBySku("SKU-LED-72x36");
    }

    @Test
    void shouldReturnEmpty_whenGetItemBySkuCalledWithInvalidSku() {
        // Given
        when(inventoryRepository.findBySku("INVALID-SKU")).thenReturn(Optional.empty());

        // When
        Optional<InventoryItem> result = inventoryService.getItemBySku("INVALID-SKU");

        // Then
        assertThat(result).isEmpty();
        verify(inventoryRepository).findBySku("INVALID-SKU");
    }

    @Test
    void shouldReturnItemsByName_whenSearchCalledWithNameQuery() {
        // Given
        when(inventoryRepository.findByNameContainingIgnoreCase("LED"))
                .thenReturn(List.of(testItem));
        when(inventoryRepository.findByLocationContainingIgnoreCase("LED"))
                .thenReturn(List.of());

        // When
        List<InventoryItem> result = inventoryService.search("LED");

        // Then
        assertThat(result).hasSize(1);
        assertThat(result.get(0).getName()).contains("LED");
        verify(inventoryRepository).findByNameContainingIgnoreCase("LED");
        verify(inventoryRepository).findByLocationContainingIgnoreCase("LED");
    }

    @Test
    void shouldReturnItemsByLocation_whenSearchCalledWithLocationQuery() {
        // Given
        when(inventoryRepository.findByNameContainingIgnoreCase("Warehouse"))
                .thenReturn(List.of());
        when(inventoryRepository.findByLocationContainingIgnoreCase("Warehouse"))
                .thenReturn(List.of(testItem, lowStockItem));

        // When
        List<InventoryItem> result = inventoryService.search("Warehouse");

        // Then
        assertThat(result).hasSize(2);
        verify(inventoryRepository).findByNameContainingIgnoreCase("Warehouse");
        verify(inventoryRepository).findByLocationContainingIgnoreCase("Warehouse");
    }

    @Test
    void shouldMergeResults_whenSearchFindsItemsInBothNameAndLocation() {
        // Given
        InventoryItem item1 = new InventoryItem("LED Panel", "SKU-001", 20, "Warehouse A");
        item1.setId(1L);
        InventoryItem item2 = new InventoryItem("Display Module", "SKU-002", 15, "LED Storage");
        item2.setId(2L);

        when(inventoryRepository.findByNameContainingIgnoreCase("LED"))
                .thenReturn(List.of(item1));
        when(inventoryRepository.findByLocationContainingIgnoreCase("LED"))
                .thenReturn(List.of(item2));

        // When
        List<InventoryItem> result = inventoryService.search("LED");

        // Then
        assertThat(result).hasSize(2);
        assertThat(result).extracting(InventoryItem::getId).containsExactlyInAnyOrder(1L, 2L);
    }

    @Test
    void shouldRemoveDuplicates_whenSameItemFoundInNameAndLocation() {
        // Given
        when(inventoryRepository.findByNameContainingIgnoreCase("Panel"))
                .thenReturn(List.of(testItem));
        when(inventoryRepository.findByLocationContainingIgnoreCase("Panel"))
                .thenReturn(List.of(testItem)); // Same item

        // When
        List<InventoryItem> result = inventoryService.search("Panel");

        // Then
        assertThat(result).hasSize(1);
        assertThat(result.get(0).getId()).isEqualTo(1L);
    }

    @Test
    void shouldReturnLowStockItems_whenGetLowStockItemsCalled() {
        // Given
        when(inventoryRepository.findAll()).thenReturn(List.of(testItem, lowStockItem));

        // When
        List<InventoryItem> result = inventoryService.getLowStockItems();

        // Then
        assertThat(result).hasSize(1);
        assertThat(result.get(0).getQuantity()).isLessThanOrEqualTo(10);
        assertThat(result.get(0).getId()).isEqualTo(2L);
        verify(inventoryRepository).findAll();
    }

    @Test
    void shouldReturnEmpty_whenNoLowStockItems() {
        // Given
        when(inventoryRepository.findAll()).thenReturn(List.of(testItem)); // Quantity 50, above threshold

        // When
        List<InventoryItem> result = inventoryService.getLowStockItems();

        // Then
        assertThat(result).isEmpty();
        verify(inventoryRepository).findAll();
    }

    @Test
    void shouldCreateItem_whenCreateItemCalledWithValidItem() {
        // Given
        InventoryItem newItem = new InventoryItem("New Display", "SKU-NEW-001", 25, "Warehouse C");
        InventoryItem savedItem = new InventoryItem("New Display", "SKU-NEW-001", 25, "Warehouse C");
        savedItem.setId(3L);
        savedItem.setLastUpdated(LocalDate.now());

        when(inventoryRepository.save(any(InventoryItem.class))).thenReturn(savedItem);

        // When
        InventoryItem result = inventoryService.createItem(newItem);

        // Then
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(3L);
        assertThat(result.getLastUpdated()).isEqualTo(LocalDate.now());
        verify(inventoryRepository).save(any(InventoryItem.class));
    }

    @Test
    void shouldUpdateItem_whenUpdateItemCalledWithValidData() {
        // Given
        InventoryItem updatedData = new InventoryItem("Updated LED Panel", "SKU-LED-72x36-V2", 75, "Warehouse D");
        
        when(inventoryRepository.findById(1L)).thenReturn(Optional.of(testItem));
        when(inventoryRepository.save(any(InventoryItem.class))).thenReturn(testItem);

        // When
        InventoryItem result = inventoryService.updateItem(1L, updatedData);

        // Then
        assertThat(result).isNotNull();
        assertThat(result.getName()).isEqualTo("Updated LED Panel");
        assertThat(result.getSku()).isEqualTo("SKU-LED-72x36-V2");
        assertThat(result.getQuantity()).isEqualTo(75);
        assertThat(result.getLocation()).isEqualTo("Warehouse D");
        assertThat(result.getLastUpdated()).isEqualTo(LocalDate.now());
        verify(inventoryRepository).findById(1L);
        verify(inventoryRepository).save(testItem);
    }

    @Test
    void shouldThrowException_whenUpdateItemCalledWithInvalidId() {
        // Given
        InventoryItem updatedData = new InventoryItem("Updated Item", "SKU-999", 10, "Location");
        when(inventoryRepository.findById(999L)).thenReturn(Optional.empty());

        // When / Then
        assertThatThrownBy(() -> inventoryService.updateItem(999L, updatedData))
                .isInstanceOf(RuntimeException.class)
                .hasMessageContaining("Inventory item not found: 999");
        verify(inventoryRepository).findById(999L);
        verify(inventoryRepository, never()).save(any(InventoryItem.class));
    }
}
