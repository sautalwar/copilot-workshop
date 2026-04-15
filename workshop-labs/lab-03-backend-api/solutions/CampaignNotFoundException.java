package com.outfront.workshop.exception;

/**
 * Thrown when a campaign cannot be found by its ID.
 */
public class CampaignNotFoundException extends RuntimeException {

    /**
     * Creates a new CampaignNotFoundException.
     *
     * @param id the ID of the campaign that was not found
     */
    public CampaignNotFoundException(final Long id) {
        super("Campaign not found with id: " + id);
    }
}
