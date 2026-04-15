package com.outfront.workshop.controller;

import com.outfront.workshop.model.Campaign;
import com.outfront.workshop.model.Campaign.CampaignStatus;
import com.outfront.workshop.model.CreateCampaignRequest;
import com.outfront.workshop.service.CampaignService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * REST controller for campaign management.
 * Provides CRUD operations and status transitions for advertising campaigns.
 */
@RestController
@RequestMapping("/api/campaigns")
public class CampaignController {

    private final CampaignService campaignService;

    public CampaignController(CampaignService campaignService) {
        this.campaignService = campaignService;
    }

    /**
     * Retrieves all campaigns.
     *
     * @return list of all campaigns
     */
    @GetMapping
    public List<Campaign> getAllCampaigns() {
        return campaignService.getAllCampaigns();
    }

    /**
     * Retrieves a campaign by its unique identifier.
     *
     * @param id the campaign ID
     * @return the campaign if found, or 404 Not Found
     */
    @GetMapping("/{id}")
    public ResponseEntity<Campaign> getCampaignById(@PathVariable final Long id) {
        return campaignService.getCampaignById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * Creates a new campaign. The campaign will always start in DRAFT status.
     *
     * @param request the campaign creation request with validated fields
     * @return the created campaign with status 201
     */
    @PostMapping
    public ResponseEntity<Campaign> createCampaign(@Valid @RequestBody final CreateCampaignRequest request) {
        final Campaign created = campaignService.createCampaign(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    /**
     * Updates the status of a campaign. Enforces valid transitions:
     * DRAFT → ACTIVE, ACTIVE → COMPLETED, any → CANCELLED.
     *
     * @param id the campaign ID
     * @param body JSON body containing the new "status" value
     * @return the updated campaign, or an error message
     */
    @PutMapping("/{id}/status")
    public ResponseEntity<?> updateCampaignStatus(@PathVariable final Long id,
                                                  @RequestBody final Map<String, String> body) {
        final CampaignStatus newStatus = CampaignStatus.valueOf(body.get("status").toUpperCase());
        final Campaign updated = campaignService.updateCampaignStatus(id, newStatus);
        return ResponseEntity.ok(updated);
    }

    /**
     * Deletes a campaign by ID.
     *
     * @param id the campaign ID
     * @return 204 No Content on success
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteCampaign(@PathVariable final Long id) {
        campaignService.deleteCampaign(id);
        return ResponseEntity.noContent().build();
    }
}
