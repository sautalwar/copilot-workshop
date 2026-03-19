package com.outfront.workshop;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.outfront.workshop.model.InventoryItem;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.hamcrest.Matchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Integration tests for InventoryController.
 * Validates CRUD, search, and low-stock endpoints.
 */
@SpringBootTest
@AutoConfigureMockMvc
class InventoryControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    void shouldReturnAllInventoryItems() throws Exception {
        mockMvc.perform(get("/api/inventory"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(greaterThanOrEqualTo(10))));
    }

    @Test
    void shouldReturnItemById() throws Exception {
        mockMvc.perform(get("/api/inventory/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.sku").value("DSU-9648"));
    }

    @Test
    void shouldReturn404ForMissingItem() throws Exception {
        mockMvc.perform(get("/api/inventory/999"))
                .andExpect(status().isNotFound());
    }

    @Test
    void shouldSearchByName() throws Exception {
        mockMvc.perform(get("/api/inventory/search").param("query", "LED"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(greaterThanOrEqualTo(1))))
                .andExpect(jsonPath("$[0].name", containsStringIgnoringCase("LED")));
    }

    @Test
    void shouldSearchByLocation() throws Exception {
        mockMvc.perform(get("/api/inventory/search").param("query", "Newark"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(greaterThanOrEqualTo(1))));
    }

    @Test
    void shouldReturnLowStockItems() throws Exception {
        mockMvc.perform(get("/api/inventory/low-stock"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray());
    }

    @Test
    void shouldCreateInventoryItem() throws Exception {
        InventoryItem newItem = new InventoryItem(
                "TEST-001", "Test Display Unit", "A test item", 5, "Warehouse A — Newark, NJ");

        mockMvc.perform(post("/api/inventory")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(newItem)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.sku").value("TEST-001"))
                .andExpect(jsonPath("$.name").value("Test Display Unit"));
    }

    @Test
    void shouldUpdateInventoryItem() throws Exception {
        InventoryItem updated = new InventoryItem(
                "DSU-9648", "Digital Screen Unit 96x48 (Updated)", "Updated description", 20,
                "Warehouse A — Newark, NJ");

        mockMvc.perform(put("/api/inventory/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(updated)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("Digital Screen Unit 96x48 (Updated)"));
    }
}
