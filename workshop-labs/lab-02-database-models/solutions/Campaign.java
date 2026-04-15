package com.outfront.workshop.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Represents a billboard advertising campaign in the OutFront OMS.
 * Tracks campaign details including client, budget, schedule, and status.
 */
@Entity
@Table(name = "campaign")
public class Campaign {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String client;

    private LocalDate startDate;

    private LocalDate endDate;

    @Column(precision = 12, scale = 2)
    private BigDecimal budget;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private CampaignStatus status = CampaignStatus.DRAFT;

    private String location;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    // Default constructor required by JPA
    public Campaign() {}

    /**
     * Creates a new Campaign with the given details.
     *
     * @param name      the campaign name
     * @param client    the client company name
     * @param startDate the campaign start date
     * @param endDate   the campaign end date
     * @param budget    the campaign budget
     * @param location  the billboard location
     */
    public Campaign(final String name, final String client, final LocalDate startDate,
                    final LocalDate endDate, final BigDecimal budget, final String location) {
        this.name = name;
        this.client = client;
        this.startDate = startDate;
        this.endDate = endDate;
        this.budget = budget;
        this.location = location;
        this.status = CampaignStatus.DRAFT;
        this.createdAt = LocalDateTime.now();
    }

    @PrePersist
    protected void onCreate() {
        if (this.createdAt == null) {
            this.createdAt = LocalDateTime.now();
        }
    }

    // --- Getters and Setters ---

    public Long getId() { return id; }
    public void setId(final Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(final String name) { this.name = name; }

    public String getClient() { return client; }
    public void setClient(final String client) { this.client = client; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(final LocalDate startDate) { this.startDate = startDate; }

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(final LocalDate endDate) { this.endDate = endDate; }

    public BigDecimal getBudget() { return budget; }
    public void setBudget(final BigDecimal budget) { this.budget = budget; }

    public CampaignStatus getStatus() { return status; }
    public void setStatus(final CampaignStatus status) { this.status = status; }

    public String getLocation() { return location; }
    public void setLocation(final String location) { this.location = location; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(final LocalDateTime createdAt) { this.createdAt = createdAt; }
}
