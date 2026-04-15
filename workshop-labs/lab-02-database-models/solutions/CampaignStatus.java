package com.outfront.workshop.model;

/**
 * Represents the lifecycle status of a billboard advertising campaign.
 */
public enum CampaignStatus {
    /** Campaign is being planned but not yet live. */
    DRAFT,
    /** Campaign is currently running on billboards. */
    ACTIVE,
    /** Campaign has finished its scheduled run. */
    COMPLETED,
    /** Campaign was cancelled before or during its run. */
    CANCELLED
}
