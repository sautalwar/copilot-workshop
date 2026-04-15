package com.outfront.workshop;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.outfront.workshop.model.Campaign;
import com.outfront.workshop.model.CampaignStatus;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.hamcrest.Matchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Integration tests for CampaignController.
 * Uses the full Spring context with an H2 database seeded by data.sql.
 */
@SpringBootTest
@AutoConfigureMockMvc
class CampaignControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    void shouldReturnAllCampaigns() throws Exception {
        mockMvc.perform(get("/api/campaigns"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(greaterThanOrEqualTo(1))));
    }

    @Test
    void shouldReturnCampaignById() throws Exception {
        mockMvc.perform(get("/api/campaigns/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.name").isNotEmpty());
    }

    @Test
    void shouldReturn404ForMissingCampaign() throws Exception {
        mockMvc.perform(get("/api/campaigns/999"))
                .andExpect(status().isNotFound());
    }

    @Test
    void shouldCreateNewCampaign() throws Exception {
        Campaign campaign = new Campaign(
                "Times Square Holiday Campaign",
                "Coca-Cola",
                LocalDate.of(2025, 11, 1),
                LocalDate.of(2025, 12, 31),
                new BigDecimal("250000.00"),
                "Times Square, NYC"
        );

        mockMvc.perform(post("/api/campaigns")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(campaign)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.name").value("Times Square Holiday Campaign"))
                .andExpect(jsonPath("$.client").value("Coca-Cola"))
                .andExpect(jsonPath("$.status").value("DRAFT"));
    }

    @Test
    void shouldUpdateCampaignStatus() throws Exception {
        // First create a campaign to update
        Campaign campaign = new Campaign(
                "Brooklyn Bridge Promo",
                "Nike",
                LocalDate.of(2025, 6, 1),
                LocalDate.of(2025, 8, 31),
                new BigDecimal("150000.00"),
                "Brooklyn Bridge Approach, NYC"
        );

        String response = mockMvc.perform(post("/api/campaigns")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(campaign)))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(response).get("id").asLong();

        // Update status from DRAFT → ACTIVE
        mockMvc.perform(put("/api/campaigns/" + id + "/status")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"status\": \"ACTIVE\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("ACTIVE"));
    }

    @Test
    void shouldFilterCampaignsByStatus() throws Exception {
        mockMvc.perform(get("/api/campaigns").param("status", "DRAFT"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray());
    }

    @Test
    void shouldDeleteCampaign() throws Exception {
        // Create a campaign to delete
        Campaign campaign = new Campaign(
                "Temp Campaign for Deletion",
                "Test Corp",
                LocalDate.of(2025, 1, 1),
                LocalDate.of(2025, 1, 31),
                new BigDecimal("10000.00"),
                "Test Location"
        );

        String response = mockMvc.perform(post("/api/campaigns")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(campaign)))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(response).get("id").asLong();

        mockMvc.perform(delete("/api/campaigns/" + id))
                .andExpect(status().isNoContent());

        mockMvc.perform(get("/api/campaigns/" + id))
                .andExpect(status().isNotFound());
    }
}
