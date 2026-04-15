package com.outfront.workshop.model;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Data Transfer Object for creating a new campaign.
 * Contains only the fields the client should provide — the server
 * sets the id, status, and createdAt automatically.
 *
 * @param name the campaign name (required)
 * @param client the client company name (required)
 * @param startDate the campaign start date (required)
 * @param endDate the campaign end date (required)
 * @param budget the campaign budget in dollars (required, must be positive)
 * @param location the billboard/signage location (optional)
 */
public record CreateCampaignRequest(

    @NotBlank(message = "Campaign name is required")
    String name,

    @NotBlank(message = "Client name is required")
    String client,

    @NotNull(message = "Start date is required")
    LocalDate startDate,

    @NotNull(message = "End date is required")
    LocalDate endDate,

    @NotNull(message = "Budget is required")
    @Positive(message = "Budget must be positive")
    BigDecimal budget,

    String location
) {}
