package com.outfront.workshop.repository;

import com.outfront.workshop.model.Campaign;
import com.outfront.workshop.model.CampaignStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

/**
 * Spring Data JPA repository for {@link Campaign} entities.
 * Provides CRUD operations and custom query methods for campaigns.
 */
@Repository
public interface CampaignRepository extends JpaRepository<Campaign, Long> {

    /**
     * Finds all campaigns with the given status.
     *
     * @param status the campaign status to filter by
     * @return list of campaigns matching the status
     */
    List<Campaign> findByStatus(CampaignStatus status);

    /**
     * Finds all campaigns for a given client (case-insensitive partial match).
     *
     * @param client the client name to search for
     * @return list of campaigns matching the client name
     */
    List<Campaign> findByClientContainingIgnoreCase(String client);

    /**
     * Finds all campaigns whose start date falls within the given range.
     *
     * @param start the range start date (inclusive)
     * @param end   the range end date (inclusive)
     * @return list of campaigns starting within the date range
     */
    List<Campaign> findByStartDateBetween(LocalDate start, LocalDate end);
}
