CodeSystem: LimitPeriodCS
Id: limit-period
Title: "Limit Period Code System"
Description: "Code system for the period over which a benefit limit accrues"
* ^status = #draft
* ^experimental = true
* ^caseSensitive = true
* ^content = #complete

* #plan-year "Plan Year" "The limit accrues over the plan year"
* #calendar-year "Calendar Year" "The limit accrues over the calendar year"
* #benefit-period "Benefit Period" "The limit accrues over a defined benefit period, such as an episode of care or admission"
* #lifetime "Lifetime" "The limit accrues over the member's lifetime"
