package com.outfront.workshop.service;

import com.outfront.workshop.model.Campaign;
import com.outfront.workshop.model.CampaignStatus;
import com.outfront.workshop.repository.CampaignRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

/**
 * Service for managing billboard advertising campaigns.
 * Can you spot what's wrong with this implementation?
 */
@Service
public class BuggyCampaignService {

    private final CampaignRepository campaignRepository;

    public BuggyCampaignService(CampaignRepository campaignRepository) {
        this.campaignRepository = campaignRepository;
    }

    /**
     * Creates a new campaign.
     *
     * @param campaign the campaign to create
     * @return the saved campaign
     */
    public Campaign createCampaign(Campaign campaign) {
        return campaignRepository.save(campaign);
    }

    /**
     * Retrieves a campaign by its ID.
     *
     * @param id the campaign ID
     * @return the campaign, if found
     */
    public Optional<Campaign> getCampaignById(Long id) {
        return campaignRepository.findById(id);
    }

    /**
     * Retrieves all campaigns.
     *
     * @return list of all campaigns
     */
    public List<Campaign> getAllCampaigns() {
        return campaignRepository.findAll();
    }

    /**
     * Updates the status of a campaign.
     *
     * @param id        the campaign ID
     * @param newStatus the new status to set
     * @return the updated campaign
     * @throws RuntimeException if the campaign is not found
     */
    public Campaign updateStatus(Long id, CampaignStatus newStatus) {
        Campaign campaign = campaignRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Campaign not found: " + id));

        if (campaign.getStatus() == CampaignStatus.CANCELLED) {
            throw new RuntimeException("Cannot change status of a cancelled campaign");
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
    public void deleteCampaign(Long id) {
        if (!campaignRepository.existsById(id)) {
            throw new RuntimeException("Campaign not found: " + id);
        }
        campaignRepository.deleteById(id);
    }
}
