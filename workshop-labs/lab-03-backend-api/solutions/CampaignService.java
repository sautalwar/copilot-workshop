package com.outfront.workshop.service;

import com.outfront.workshop.exception.CampaignNotFoundException;
import com.outfront.workshop.model.Campaign;
import com.outfront.workshop.model.Campaign.CampaignStatus;
import com.outfront.workshop.model.CreateCampaignRequest;
import com.outfront.workshop.repository.CampaignRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Business logic for managing advertising campaigns.
 * Enforces status transition rules and campaign lifecycle.
 */
@Service
public class CampaignService {

    private final CampaignRepository campaignRepository;

    public CampaignService(CampaignRepository campaignRepository) {
        this.campaignRepository = campaignRepository;
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
     * Retrieves a campaign by its unique identifier.
     *
     * @param id the campaign ID
     * @return an Optional containing the campaign if found
     */
    @Transactional(readOnly = true)
    public Optional<Campaign> getCampaignById(final Long id) {
        return campaignRepository.findById(id);
    }

    /**
     * Creates a new campaign. The status is always set to DRAFT regardless
     * of what the caller provides.
     *
     * @param request the campaign creation request
     * @return the saved campaign
     */
    @Transactional
    public Campaign createCampaign(final CreateCampaignRequest request) {
        final Campaign campaign = new Campaign();
        campaign.setName(request.name());
        campaign.setClient(request.client());
        campaign.setStartDate(request.startDate());
        campaign.setEndDate(request.endDate());
        campaign.setBudget(request.budget());
        campaign.setLocation(request.location());
        campaign.setStatus(CampaignStatus.DRAFT);
        campaign.setCreatedAt(LocalDateTime.now());
        return campaignRepository.save(campaign);
    }

    /**
     * Updates the status of a campaign. Enforces valid transitions:
     * DRAFT → ACTIVE, ACTIVE → COMPLETED, and any status → CANCELLED.
     *
     * @param id the campaign ID
     * @param newStatus the desired new status
     * @return the updated campaign
     * @throws CampaignNotFoundException if the campaign does not exist
     * @throws IllegalArgumentException if the status transition is not allowed
     */
    @Transactional
    public Campaign updateCampaignStatus(final Long id, final CampaignStatus newStatus) {
        final Campaign campaign = campaignRepository.findById(id)
                .orElseThrow(() -> new CampaignNotFoundException(id));

        final CampaignStatus currentStatus = campaign.getStatus();
        validateStatusTransition(currentStatus, newStatus);

        campaign.setStatus(newStatus);
        return campaignRepository.save(campaign);
    }

    /**
     * Deletes a campaign by ID.
     *
     * @param id the campaign ID
     * @throws CampaignNotFoundException if the campaign does not exist
     */
    @Transactional
    public void deleteCampaign(final Long id) {
        if (!campaignRepository.existsById(id)) {
            throw new CampaignNotFoundException(id);
        }
        campaignRepository.deleteById(id);
    }

    /**
     * Validates that a status transition is allowed.
     * Valid transitions: DRAFT → ACTIVE, ACTIVE → COMPLETED, any → CANCELLED.
     */
    private void validateStatusTransition(final CampaignStatus current, final CampaignStatus next) {
        if (next == CampaignStatus.CANCELLED) {
            return; // Cancellation is always allowed
        }

        final boolean valid = switch (current) {
            case DRAFT -> next == CampaignStatus.ACTIVE;
            case ACTIVE -> next == CampaignStatus.COMPLETED;
            default -> false;
        };

        if (!valid) {
            throw new IllegalArgumentException(
                    "Invalid status transition: " + current + " → " + next
                    + ". Allowed transitions: DRAFT → ACTIVE, ACTIVE → COMPLETED, any → CANCELLED.");
        }
    }
}
