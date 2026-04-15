package com.outfront.workshop.service;

import com.outfront.workshop.model.Campaign;
import com.outfront.workshop.model.CampaignStatus;
import com.outfront.workshop.repository.CampaignRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.Set;

/**
 * Service for managing billboard advertising campaigns.
 * (Fixed version — all 3 bugs resolved.)
 */
@Service
public class BuggyCampaignService {

    private final CampaignRepository campaignRepository;

    /**
     * Valid status transitions for campaigns.
     * DRAFT → ACTIVE, ACTIVE → COMPLETED, ACTIVE → CANCELLED, DRAFT → CANCELLED.
     */
    private static final Set<String> VALID_TRANSITIONS = Set.of(
            "DRAFT->ACTIVE",
            "ACTIVE->COMPLETED",
            "ACTIVE->CANCELLED",
            "DRAFT->CANCELLED"
    );

    public BuggyCampaignService(CampaignRepository campaignRepository) {
        this.campaignRepository = campaignRepository;
    }

    /**
     * Creates a new campaign.
     *
     * @param campaign the campaign to create
     * @return the saved campaign
     */
    // FIX #3: Added @Transactional to wrap the write operation in a database transaction
    @Transactional
    public Campaign createCampaign(Campaign campaign) {
        // FIX #1: Default the status to DRAFT if not set, preventing NullPointerException
        if (campaign.getStatus() == null) {
            campaign.setStatus(CampaignStatus.DRAFT);
        }
        return campaignRepository.save(campaign);
    }

    /**
     * Retrieves a campaign by its ID.
     *
     * @param id the campaign ID
     * @return the campaign, if found
     */
    @Transactional(readOnly = true)
    public Optional<Campaign> getCampaignById(Long id) {
        return campaignRepository.findById(id);
    }

    /**
     * Retrieves all campaigns.
     *
     * @return list of all campaigns
     */
    @Transactional(readOnly = true)
    public List<Campaign> getAllCampaigns() {
        return campaignRepository.findAll();
    }

    /**
     * Updates the status of a campaign.
     *
     * @param id        the campaign ID
     * @param newStatus the new status to set
     * @return the updated campaign
     * @throws RuntimeException if the campaign is not found or the transition is invalid
     */
    // FIX #3 (continued): Added @Transactional to wrap the write operation
    @Transactional
    public Campaign updateStatus(Long id, CampaignStatus newStatus) {
        Campaign campaign = campaignRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Campaign not found: " + id));

        // FIX #2: Validate the full transition, not just the source status.
        // Previously only blocked CANCELLED → anything, but allowed invalid
        // transitions like COMPLETED → ACTIVE.
        String transition = campaign.getStatus() + "->" + newStatus;
        if (!VALID_TRANSITIONS.contains(transition)) {
            throw new RuntimeException(
                    "Invalid status transition: " + campaign.getStatus() + " → " + newStatus);
        }

        campaign.setStatus(newStatus);
        return campaignRepository.save(campaign);
    }

    /**
     * Deletes a campaign by its ID.
     *
     * @param id the campaign ID
     * @throws RuntimeException if the campaign is not found
     */
    @Transactional
    public void deleteCampaign(Long id) {
        if (!campaignRepository.existsById(id)) {
            throw new RuntimeException("Campaign not found: " + id);
        }
        campaignRepository.deleteById(id);
    }
}
