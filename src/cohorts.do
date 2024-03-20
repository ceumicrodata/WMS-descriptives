use "temp/data.dta", clear

do "src/create/variables.do"

local T1 1945
local T2 1995
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

summarize management [aw=weight], detail
regress management i.cohort_firm [pw=weight], cluster(tax_id)
regress management i.cohort_respondent [pw=weight], cluster(tax_id)
regress management ib`T1'.cohort_respondent lnL foreign [pw=weight], cluster(tax_id)

* FIXME: Geri, please create a figure with the point estimates and confidence intervals for cohort respondent
* X axis: cohort of respondeny, Y axis, estimated management score, relative to baseline, 1945

foreach X in management operations monitoring targets people {
    regress `X' modern_firm [pw=weight], cluster(tax_id)
    regress `X' modern_ceo [pw=weight], cluster(tax_id)
    regress `X' modern_respondent [pw=weight], cluster(tax_id)
    regress `X' modern_ceo modern_respondent [pw=weight], cluster(tax_id)
    regress `X' modern_ceo modern_respondent lnL foreign [pw=weight], cluster(tax_id)
}
