# Examples

This page provides examples of how to use the SBC InsurancePlan profile to represent Summary of Benefits and Coverage documents.

## Example: Sample HMO Health Plan

**Resource:** [SBCExampleHMO](InsurancePlan-SBCExampleHMO.html)

This example demonstrates a Health Maintenance Organization (HMO) plan with typical SBC content including:

### Plan Identification
- **Plan Name:** Sample Health HMO Gold Plan
- **Plan Type:** HMO
- **Coverage Period:** January 1, 2025 - December 31, 2025
- **HIOS ID:** 12345CA0010001-01
- **Issuer:** Sample Health Insurance Company

### General Plan Costs

| Cost Type | Individual | Family |
|-----------|------------|--------|
| Deductible | $1,500 | $3,000 |
| Out-of-Pocket Maximum | $6,000 | $12,000 |

### Benefit Categories with Cost-Sharing

The example includes six representative benefit categories demonstrating different cost-sharing patterns:

#### 1. Preventive Care
- **In-Network:** No charge
- **Out-of-Network:** Not covered
- **Requirement:** No prior authorization required for in-network preventive services

#### 2. Primary Care Visit
- **In-Network:** $25 copay
- **Out-of-Network:** Not covered
- **Requirement:** No referral required
- **Deductible:** Does not apply (DeductibleApplies extension, `false`)

#### 3. Specialist Visit
- **In-Network (Value Choice Provider):** $0 copay, for providers in the plan's Value Choice network
- **In-Network (Standard Provider):** $50 copay
- **In-Network (Virtual Visit):** $10 copay
- **Out-of-Network:** Not covered
- **Requirement:** Referral required from primary care physician
- **Limitation:** Limited to network specialists only; out-of-network not covered except in emergencies
- **Limitation (structured):** Limited to 35 visits per plan year (limitType `visits`, limitValue 35, limitPeriod `plan-year`)

This benefit demonstrates multi-tier cost sharing: several in-network cost entries for the same benefit, distinguished by the `cost.qualifiers` tier (Cost Tier value set) rather than by network applicability. The Value Choice entry uses the CostAppliesToNetwork extension to reference the network Organization whose providers qualify for the $0 tier.

#### 4. Emergency Room Care
- **In-Network:** $350 copay
- **Out-of-Network:** $350 copay (same as in-network)
- **Limitation:** Copay waived if admitted to hospital

#### 5. Generic Drugs
- **In-Network:** $10 copay
- **Out-of-Network:** Not covered

#### 6. Hospital Inpatient Care
- **In-Network:** 20% coinsurance
- **Out-of-Network:** Not covered
- **Requirement:** Prior authorization required for non-emergency admissions
- **Limitation:** Prior authorization required
- **Deductible:** Applies (DeductibleApplies extension, `true`)

### Excluded Services

The example demonstrates how to document services not covered:
- **Cosmetic surgery** - Services for cosmetic purposes are not covered
- **Weight loss programs** - Weight loss programs except when medically necessary

### Regulatory Metadata

The example includes SBC-specific regulatory disclosures:
- **SBC Version Date:** January 1, 2021 (current template version)
- **Minimum Essential Coverage:** Yes
- **Minimum Value:** Yes

### Contact Information

Multiple contact points are provided:
- **General Questions:** 1-800-123-4567, https://www.samplehealth.com
- **Uniform Glossary:** https://www.healthcare.gov/sbc-glossary/

## Example Patterns

### Pattern 1: No Charge for Preventive Care

Preventive care is typically covered at no cost for in-network services under ACA requirements:

```json
{
  "category": {
    "coding": [{
      "system": "http://hl7.org/fhir/us/insurance-card/CodeSystem/sbc-benefit-category",
      "code": "preventive-care"
    }]
  },
  "benefit": [{
    "type": {
      "coding": [{
        "system": "http://hl7.org/fhir/us/insurance-card/CodeSystem/sbc-benefit-category",
        "code": "preventive-care"
      }]
    },
    "cost": [
      {
        "type": { "text": "No charge" },
        "applicability": { "text": "in-network" },
        "value": { "value": 0, "unit": "USD" }
      },
      {
        "type": { "text": "Not covered" },
        "applicability": { "text": "out-of-network" },
        "value": { "value": 0, "unit": "USD" }
      }
    ]
  }]
}
```

### Pattern 2: Fixed Copayment

Most office visits use fixed copayment amounts:

```json
{
  "cost": [{
    "type": { "text": "Copayment" },
    "applicability": { "text": "in-network" },
    "value": { "value": 25, "unit": "USD" }
  }]
}
```

### Pattern 3: Percentage Coinsurance

Hospital services often use coinsurance (percentage):

```json
{
  "cost": [{
    "type": { "text": "Coinsurance" },
    "applicability": { "text": "in-network" },
    "value": { "value": 20, "unit": "%" }
  }]
}
```

### Pattern 4: Not Covered Services

HMO plans typically don't cover out-of-network except emergencies:

```json
{
  "cost": [{
    "type": { "text": "Not covered" },
    "applicability": { "text": "out-of-network" },
    "value": { "value": 0, "unit": "USD" }
  }]
}
```

### Pattern 5: Same Cost In and Out of Network

Emergency services must be covered equally regardless of network:

```json
{
  "cost": [
    {
      "type": { "text": "Copayment" },
      "applicability": { "text": "in-network" },
      "value": { "value": 350, "unit": "USD" }
    },
    {
      "type": { "text": "Copayment" },
      "applicability": { "text": "out-of-network" },
      "value": { "value": 350, "unit": "USD" }
    }
  ]
}
```

### Pattern 6: Adding Limitations

Use the BenefitLimitation extension for requirements and restrictions. The limitation text as displayed in the SBC goes in the `limitText` sub-extension; when the limit is quantifiable, the optional `limitType`, `limitValue`, and `limitPeriod` sub-extensions carry a structured representation:

```json
{
  "benefit": [{
    "extension": [{
      "url": "http://hl7.org/fhir/us/insurance-card/StructureDefinition/benefit-limitation",
      "extension": [
        {
          "url": "limitText",
          "valueString": "Limited to 35 visits per plan year"
        },
        {
          "url": "limitType",
          "valueCodeableConcept": {
            "coding": [{
              "system": "http://hl7.org/fhir/us/insurance-card/CodeSystem/limit-type",
              "code": "visits"
            }]
          }
        },
        {
          "url": "limitValue",
          "valueQuantity": { "value": 35, "unit": "visits" }
        },
        {
          "url": "limitPeriod",
          "valueCodeableConcept": {
            "coding": [{
              "system": "http://hl7.org/fhir/us/insurance-card/CodeSystem/limit-period",
              "code": "plan-year"
            }]
          }
        }
      ]
    }]
  }]
}
```

For limitations that are purely narrative (for example, "Prior authorization required"), populate only `limitText`.

### Pattern 7: Multi-Tier Cost Sharing (Provider Designation or Modality)

When a plan offers different cost sharing for the same benefit and network status, for example a designated "value" provider tier or a virtual visit, each tier is a separate cost entry distinguished by `qualifiers` (Cost Tier value set). The CostAppliesToNetwork extension identifies which of the plan's networks contains the providers that qualify for a designation tier:

```json
{
  "cost": [
    {
      "extension": [{
        "url": "http://hl7.org/fhir/us/insurance-card/StructureDefinition/cost-applies-to-network",
        "valueReference": { "reference": "Organization/ExampleValueChoiceNetwork" }
      }],
      "type": { "text": "Copayment" },
      "applicability": { "text": "in-network" },
      "qualifiers": [{
        "coding": [{
          "system": "http://hl7.org/fhir/us/insurance-card/CodeSystem/cost-tier",
          "code": "value-choice"
        }]
      }],
      "value": { "value": 0, "unit": "USD" }
    },
    {
      "type": { "text": "Copayment" },
      "applicability": { "text": "in-network" },
      "qualifiers": [{
        "coding": [{
          "system": "http://hl7.org/fhir/us/insurance-card/CodeSystem/cost-tier",
          "code": "standard"
        }]
      }],
      "value": { "value": 50, "unit": "USD" }
    },
    {
      "type": { "text": "Copayment" },
      "applicability": { "text": "in-network" },
      "qualifiers": [{
        "coding": [{
          "system": "http://hl7.org/fhir/us/insurance-card/CodeSystem/cost-tier",
          "code": "virtual"
        }]
      }],
      "value": { "value": 10, "unit": "USD" }
    }
  ]
}
```

### Pattern 8: Deductible Applicability

The DeductibleApplies extension states whether a cost-sharing amount accrues to the plan deductible, the SBC "deductible applies?" information:

```json
{
  "cost": [{
    "extension": [{
      "url": "http://hl7.org/fhir/us/insurance-card/StructureDefinition/deductible-applies",
      "valueBoolean": true
    }],
    "type": { "text": "Coinsurance" },
    "applicability": { "text": "in-network" },
    "value": { "value": 20, "unit": "%" }
  }]
}
```

## Additional Example Scenarios

### PPO Plan Example

A PPO plan would differ from the HMO example by:
- **Plan Type:** `#PPO` instead of `#HMO`
- **Out-of-Network Coverage:** Typically covered but at higher cost
- **No Referral Requirements:** Usually not required for specialists
- **Different Cost Structure:**

```json
{
  "type": "Specialist Visit",
  "cost": [
    {
      "applicability": "in-network",
      "value": { "value": 50, "unit": "USD" }
    },
    {
      "applicability": "out-of-network",
      "value": { "value": 100, "unit": "USD" }
    }
  ]
}
```

### High Deductible Health Plan (HDHP) Example

An HDHP would feature:
- **Plan Type:** `#HDHP`
- **Higher Deductibles:** $3,000+ individual
- **Lower Premiums:** (not shown in SBC)
- **HSA Eligibility:** Noted in metadata
- **Different Cost-Sharing Pattern:**

```json
{
  "generalCost": [
    {
      "type": { "text": "Individual Deductible" },
      "cost": { "value": 3000, "currency": "USD" }
    }
  ],
  "specificCost": [{
    "benefit": [{
      "type": "primary-care-visit",
      "cost": [{
        "type": { "text": "Subject to deductible, then coinsurance" },
        "applicability": { "text": "in-network" }
      }]
    }]
  }]
}
```

### Pharmacy Benefits Example

Drug coverage typically has tiered cost-sharing:

```json
{
  "specificCost": [
    {
      "category": "generic-drugs",
      "benefit": [{
        "cost": [{
          "type": { "text": "Copayment" },
          "applicability": { "text": "in-network" },
          "value": { "value": 10, "unit": "USD" }
        }]
      }]
    },
    {
      "category": "preferred-brand-drugs",
      "benefit": [{
        "cost": [{
          "type": { "text": "Copayment" },
          "applicability": { "text": "in-network" },
          "value": { "value": 40, "unit": "USD" }
        }]
      }]
    },
    {
      "category": "non-preferred-brand-drugs",
      "benefit": [{
        "cost": [{
          "type": { "text": "Copayment" },
          "applicability": { "text": "in-network" },
          "value": { "value": 70, "unit": "USD" }
        }]
      }]
    },
    {
      "category": "specialty-drugs",
      "benefit": [{
        "cost": [{
          "type": { "text": "Coinsurance" },
          "applicability": { "text": "in-network" },
          "value": { "value": 30, "unit": "%" }
        }]
      }]
    }
  ]
}
```

## Complete SBC Representation

A production-ready SBC representation should include:

1. **All 27 benefit categories** in `plan.specificCost`
2. **Both network applicabilities** (in-network and out-of-network) for each benefit
3. **General costs** (deductibles, OOP maximums) in `plan.generalCost`
4. **Contact information** for questions, provider lists, formulary, glossary
5. **Regulatory metadata** (minimum essential coverage, minimum value)
6. **Excluded services** list
7. **Requirements and limitations** for each benefit as applicable
8. **Plan identification** (name, type, period, HIOS ID)

The example provided demonstrates the structure with 6 benefit categories. A complete implementation would expand this to all 27 categories with appropriate cost-sharing for each.

## Testing and Validation

When creating SBC InsurancePlan instances, validate:

1. ✓ Status is "active"
2. ✓ Name, period, and ownedBy are populated
3. ✓ At least one contact with phone and URL
4. ✓ Plan type is from SBC Plan Type ValueSet
5. ✓ All 27 benefit categories present in specificCost
6. ✓ Each benefit has at least 2 cost entries (in/out of network)
7. ✓ Cost applicability is specified for each cost
8. ✓ Currency is consistent (e.g., all USD)
9. ✓ Percentage values use "%" unit
10. ✓ Dollar amounts use currency code

## Next Steps

After reviewing these examples:
- Explore the [SBC InsurancePlan Profile](StructureDefinition-sbc-insurance-plan.html) for detailed element definitions
- Review the [SBC to FHIR Mapping](sbc-mapping.html) for comprehensive mapping guidance
- Check the [Terminology](sbc-terminology.html) page for all 27 benefit category codes
