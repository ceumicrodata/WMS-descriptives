use "temp/data.dta", clear

local vars firm_age employment export_share foreign_owner birth_year 

local firm_age_survey firm_age
local firm_age_data 2018 - foundyear

local employment_survey emp_firm
local employment_data employment_from_balance

local export_share_survey exported
local export_share_data export/sales*100

local foreign_owner_survey !inlist(mne_cty, "Magyar", "0", "")
local foreign_owner_data fo3

local birth_year_survey birth_year_respondent
local birth_year_data birth_year_opten

foreach var in `vars' {
    generate `var'_survey = ``var'_survey'
    generate `var'_data = ``var'_data'
    corr `var'_survey `var'_data
    scatter `var'_survey `var'_data
    graph export "output/fig/`var'_validation.png", replace width(1040)
}

* do some manual cleaning
* these respondents likely reported MNE employment
replace employment_survey = . if employment_survey > 3000
replace birth_year_survey = . if pos != "ceo"

foreach var in employment birth_year {
    corr `var'_survey `var'_data
    scatter `var'_survey `var'_data
    graph export "output/fig/`var'_validation_cleaned.png", replace width(1040)
}
