// SBC Metadata Extension
Extension: SBCMetadata
Id: sbc-metadata
Title: "SBC Metadata Extension"
Description: "Extension containing regulatory metadata required for Summary of Benefits and Coverage documents"
* ^status = #draft
* ^experimental = true
* ^context.type = #element
* ^context.expression = "InsurancePlan"

* extension contains
    sbcVersionDate 0..1 and
    minimumEssentialCoverage 0..1 and
    minimumValue 0..1 and
    abortionCoverage 0..1

* extension[sbcVersionDate] ^short = "SBC Template Version Date"
* extension[sbcVersionDate] ^definition = "The effective date of the SBC template version used"
* extension[sbcVersionDate].value[x] only date

* extension[minimumEssentialCoverage] ^short = "Minimum Essential Coverage Indicator"
* extension[minimumEssentialCoverage] ^definition = "Indicates whether the plan provides minimum essential coverage under section 5000A(f) of the Internal Revenue Code"
* extension[minimumEssentialCoverage].value[x] only boolean

* extension[minimumValue] ^short = "Minimum Value Indicator"
* extension[minimumValue] ^definition = "Indicates whether the plan's share of the total allowed costs of benefits meets the minimum value requirement"
* extension[minimumValue].value[x] only boolean

* extension[abortionCoverage] ^short = "Abortion Coverage Disclosure"
* extension[abortionCoverage] ^definition = "For qualified health plans, indicates coverage, exclusion, or limitation to excepted abortion services per 45 CFR 156.280"
* extension[abortionCoverage].value[x] only CodeableConcept


// Excluded Services Extension
Extension: ExcludedServices
Id: excluded-services
Title: "Excluded Services Extension"
Description: "Extension for documenting services that are not covered by the health insurance plan, as required in SBC 'Excluded Services & Other Covered Services' section"
* ^status = #draft
* ^experimental = true
* ^context.type = #element
* ^context.expression = "InsurancePlan"

* extension contains
    service 0..*

* extension[service] ^short = "Excluded Service"
* extension[service] ^definition = "A service or category of services that is not covered under this plan"
* extension[service].extension contains
    serviceType 1..1 and
    description 0..1

* extension[service].extension[serviceType] ^short = "Service Type"
* extension[service].extension[serviceType] ^definition = "The type of service that is excluded"
* extension[service].extension[serviceType].value[x] only CodeableConcept

* extension[service].extension[description] ^short = "Description"
* extension[service].extension[description] ^definition = "Additional description or context about the exclusion"
* extension[service].extension[description].value[x] only string


// Benefit Limitation Extension
Extension: BenefitLimitation
Id: benefit-limitation
Title: "Benefit Limitation Extension"
Description: "Extension for documenting limitations and exceptions that apply to specific benefits in the SBC, carrying the limitation text as displayed along with an optional structured representation of the limit (type, value, and period)"
* ^status = #draft
* ^experimental = true
* ^context[0].type = #element
* ^context[0].expression = "InsurancePlan.coverage.benefit"
* ^context[1].type = #element
* ^context[1].expression = "InsurancePlan.plan.specificCost.benefit"

* extension contains
    limitText 0..1 and
    limitType 0..1 and
    limitValue 0..1 and
    limitPeriod 0..1

* extension[limitText] ^short = "Limitation or Exception"
* extension[limitText] ^definition = "Text describing limitations, exceptions, or additional requirements that apply to this benefit, as displayed in the SBC"
* extension[limitText].value[x] only string

* extension[limitType] ^short = "What the limit counts"
* extension[limitType] ^definition = "The unit of measure for the limit, such as visits, days, or dollars"
* extension[limitType].value[x] only CodeableConcept
* extension[limitType].value[x] from LimitTypeVS (extensible)

* extension[limitValue] ^short = "Limit amount"
* extension[limitValue] ^definition = "The numeric value of the limit"
* extension[limitValue].value[x] only Quantity

* extension[limitPeriod] ^short = "Period over which the limit applies"
* extension[limitPeriod] ^definition = "The period over which the limit accrues, such as plan year, calendar year, benefit period, or lifetime"
* extension[limitPeriod].value[x] only CodeableConcept
* extension[limitPeriod].value[x] from LimitPeriodVS (extensible)


// Cost Applies To Network Extension
Extension: CostAppliesToNetwork
Id: cost-applies-to-network
Title: "Cost Applies To Network Extension"
Description: "Extension identifying the provider network whose providers qualify for a designation-tier cost-sharing amount, referencing one of the plan's network Organizations"
* ^status = #draft
* ^experimental = true
* ^context.type = #element
* ^context.expression = "InsurancePlan.plan.specificCost.benefit.cost"

* value[x] only Reference(Organization)
* value[x] ^short = "Network whose providers qualify for this cost tier"
* value[x] ^definition = "Reference to the network Organization whose participating providers qualify for the cost-sharing amount carried by this cost entry"


// Deductible Applies Extension
Extension: DeductibleApplies
Id: deductible-applies
Title: "Deductible Applies Extension"
Description: "Extension indicating whether a cost-sharing amount accrues to the plan deductible, corresponding to the deductible applicability information displayed in the SBC"
* ^status = #draft
* ^experimental = true
* ^context.type = #element
* ^context.expression = "InsurancePlan.plan.specificCost.benefit.cost"

* value[x] only boolean
* value[x] ^short = "Whether this cost accrues to the deductible"
* value[x] ^definition = "True if amounts paid under this cost-sharing entry count toward the plan deductible; false if the cost applies without regard to the deductible"
