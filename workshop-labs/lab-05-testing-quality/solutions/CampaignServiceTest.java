package com.outfront.workshop;

import com.outfront.workshop.model.Campaign;
import com.outfront.workshop.model.CampaignStatus;
import com.outfront.workshop.repository.CampaignRepository;
import com.outfront.workshop.service.CampaignService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * Unit tests for CampaignService.
 * Uses Mockito to isolate service logic from the database layer.
 */
@ExtendWith(MockitoExtension.class)
class CampaignServiceTest {

    @Mock
    private CampaignRepository campaignRepository;

    @InjectMocks
    private CampaignService campaignService;

    @Test
    void shouldSetStatusToDraft_whenCreatingCampaign() {
        final Campaign campaign = buildCampaign();
        campaign.setStatus(null);

        when(campaignRepository.save(any(Campaign.class))).thenAnswer(invocation -> invocation.getArgument(0));

        final Campaign result = campaignService.createCampaign(campaign);

        assertEquals(CampaignStatus.DRAFT, result.getStatus());
        verify(campaignRepository).save(campaign);
    }

    @Test
    void shouldReturnCampaign_whenValidIdProvided() {
        final Campaign campaign = buildCampaign();
        campaign.setId(1L);

        when(campaignRepository.findById(1L)).thenReturn(Optional.of(campaign));

        final Optional<Campaign> result = campaignService.getCampaignById(1L);

        assertTrue(result.isPresent());
        assertEquals("Summer Billboard Blitz", result.get().getName());
        verify(campaignRepository).findById(1L);
    }

    @Test
    void shouldReturnAllCampaigns() {
        final List<Campaign> campaigns = List.of(buildCampaign(), buildCampaign());

        when(campaignRepository.findAll()).thenReturn(campaigns);

        final List<Campaign> result = campaignService.getAllCampaigns();

        assertEquals(2, result.size());
        verify(campaignRepository).findAll();
    }

    @Test
    void shouldUpdateStatus_whenValidTransition() {
        final Campaign campaign = buildCampaign();
        campaign.setId(1L);
        campaign.setStatus(CampaignStatus.DRAFT);

        when(campaignRepository.findById(1L)).thenReturn(Optional.of(campaign));
        when(campaignRepository.save(any(Campaign.class))).thenAnswer(invocation -> invocation.getArgument(0));

        final Campaign result = campaignService.updateStatus(1L, CampaignStatus.ACTIVE);

        assertEquals(CampaignStatus.ACTIVE, result.getStatus());
        verify(campaignRepository).save(campaign);
    }

    @Test
    void shouldThrowException_whenInvalidStatusTransition() {
        final Campaign campaign = buildCampaign();
        campaign.setId(1L);
        campaign.setStatus(CampaignStatus.COMPLETED);

        when(campaignRepository.findById(1L)).thenReturn(Optional.of(campaign));

        assertThrows(RuntimeException.class, () ->
                campaignService.updateStatus(1L, CampaignStatus.ACTIVE));
    }

    @Test
    void shouldDeleteCampaign_whenCampaignExists() {
        when(campaignRepository.existsById(1L)).thenReturn(true);

        campaignService.deleteCampaign(1L);

        verify(campaignRepository).deleteById(1L);
    }

    @Test
    void shouldThrowException_whenDeletingNonExistentCampaign() {
        when(campaignRepository.existsById(999L)).thenReturn(false);

        assertThrows(RuntimeException.class, () ->
                campaignService.deleteCampaign(999L));
    }

    @Test
    void shouldThrowException_whenCampaignNotFoundById() {
        when(campaignRepository.findById(999L)).thenReturn(Optional.empty());

        final Optional<Campaign> result = campaignService.getCampaignById(999L);

        assertTrue(result.isEmpty());
    }

    /**
     * Helper method to build a test Campaign instance.
     */
    private Campaign buildCampaign() {
        return new Campaign(
                "Summer Billboard Blitz",
                "Pepsi",
                LocalDate.of(2025, 6, 1),
                LocalDate.of(2025, 8, 31),
                new BigDecimal("200000.00"),
                "I-95 Corridor, NJ"
        );
    }
}
