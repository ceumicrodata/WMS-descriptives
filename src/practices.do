clear all
use "input/wms-Hungary-2018/wms_hu_analysis.dta"
mvdecode _all, mv(-99)
generate year = 2018

* some respondents seem to have given start year
replace firm_age = 2018 - firm_age if firm_age > 1800
generate birth_year_firm = 2018 - firm_age

local production termel gyart gyárt uzem üzem oper techn műszaki projekt telephely
local ceo ügyvezet vezér elnük vezer cégvez tulaj ugyvez

replace position = ustrlower(position)
generate str pos = ""
foreach pos in production ceo {
    foreach word in ``pos'' {
        replace pos = "`pos'" if ustrpos(position, "`word'")
    }
}
replace pos = "other" if missing(pos)

generate birth_year_respondent = 2018 - age

* merge on CEOs from cegjegyzek - they may not be the respondent, though
merge m:1 tax_id year using "temp/wms-panel.dta", keep(master match) keepusing(expat entrepreneur birth_year first_year_in_market) nogenerate
generate in_cegjegyzek = !missing(birth_year)
rename first_year_in_market entry_year
foreach X in expat entrepreneur birth_year entry_year {
    rename `X' `X'_ceo
} 
* there may be multiple CEOs, use the younger
replace birth_year_ceo = max(birth_year_respondent, birth_year_ceo) if pos == "ceo"
replace birth_year_respondent = birth_year_ceo if pos == "ceo"

local T1 1950
local T2 1980
local k 5
local offset 25
replace birth_year_firm = birth_year_firm - `offset'
foreach i in ceo respondent firm {
    generate cohort_`i' = birth_year_`i'
    replace cohort_`i' = `T1' if cohort_`i' <= `T1'
    replace cohort_`i' = `T2' if cohort_`i' > `T2' & !missing(cohort_`i')
    replace cohort_`i' = int(cohort_`i'/`k') * `k'
    * people who were 20 in 1985 could already been exposed to business education
    generate byte modern_`i' = birth_year_`i' >= 1965 if !missing(birth_year_`i')
    generate byte goldrush_`i' = inrange(birth_year_`i', 1965, 1974)
}
replace birth_year_firm = birth_year_firm + `offset'
replace cohort_firm = cohort_firm + `offset'

tabulate cohort_firm
tabulate cohort_ceo
tabulate cohort_respondent
tabulate modern_ceo modern_respondent
tabulate modern_respondent goldrush_respondent

summarize zmanagement [aw=weight], detail
regress zmanagement i.cohort_firm [pw=weight], cluster(tax_id)
*regress zmanagement i.cohort_ceo [pw=weight], cluster(tax_id)
regress zmanagement i.cohort_respondent [pw=weight], cluster(tax_id)
*regress zmanagement i.cohort_respondent i.cohort_ceo [pw=weight], cluster(tax_id)

foreach X of varlist zmanagement zoperations zmonitoring ztargets zpeople {
    regress `X' modern_firm [pw=weight], cluster(tax_id)
    regress `X' modern_ceo [pw=weight], cluster(tax_id)
    regress `X' modern_respondent [pw=weight], cluster(tax_id)
    regress `X' modern_ceo modern_respondent [pw=weight], cluster(tax_id)
}
