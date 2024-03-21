use "temp/data.dta", clear

do "src/create/variables.do"

local T1 1945
local T2 1995
local k 5
local offset 25
rename first_year_in_market birth_year_entry

replace birth_year_firm = birth_year_firm - `offset'
replace birth_year_entry = birth_year_entry - `offset'

foreach i in ceo respondent firm entry {
    generate cohort_`i' = birth_year_`i'
    replace cohort_`i' = `T1' if cohort_`i' <= `T1'
    replace cohort_`i' = `T2' if cohort_`i' > `T2' & !missing(cohort_`i')
    replace cohort_`i' = int(cohort_`i'/`k') * `k'
    * people who were 20 in 1985 could already been exposed to business education
    generate byte modern_`i' = birth_year_`i' >= 1965 if !missing(birth_year_`i')
    generate byte goldrush_`i' = inrange(birth_year_`i', 1965, 1974)
}
replace birth_year_firm = birth_year_firm + `offset'
replace birth_year_entry = birth_year_entry + `offset'
replace cohort_firm = cohort_firm + `offset'
replace cohort_entry = cohort_entry + `offset'

foreach X in comp_tenure post_tenure {
    replace `X' = int(`X'/`k') * `k'
}

tabulate cohort_firm
tabulate cohort_ceo
tabulate cohort_respondent
tabulate modern_ceo modern_respondent
tabulate modern_respondent goldrush_respondent

summarize management [aw=weight], detail
regress management i.cohort_respondent [pw=weight], cluster(tax_id)
outreg2 using "output/tables/management-cohort-resp.tex", replace tex(frag pr)

foreach X in cohort_firm cohort_ceo cohort_respondent cohort_entry comp_tenure post_tenure {
    regress management i.`X' [pw=weight], cluster(tax_id)
    outreg2 using "output/tables/management-`X'.tex", replace tex(frag pr)
}

local ceo_X ceo
local ceo_controls foreign
local respondent_X respondent
local respondent_controls foreign
local respcontrol_X respondent
local respcontrol_controls i.cohort_ceo foreign

foreach spec in ceo respondent respcontrol {
    local X ``spec'_X'
    local controls ``spec'_controls'
    regress management ib`T1'.cohort_`X' `controls' [pw=weight], cluster(tax_id)
    outreg2 using "output/tables/management-cohort-`X'.tex", tex(frag pr)

    * X axis: cohort of respondency, Y axis, estimated management score, relative to baseline, 1945
    margins, dydx(ib1945.cohort_`X')
    marginsplot, recast(scatter) yline(0) nolabels xlabel(1 "1950" 2 "1955" 3 "1960" 4 "1965" 5 "1970" 6 "1975" 7 "1980" 8 "1985" 9 "1990") xtitle("Birth year of `X'") ytitle("Management score, relative to 1945")
    graph export "output/fig/cohort-`spec'-marginsplot.png", replace

    histogram cohort_`X', discrete freq width(5) xtitle("Birth year of `X'") ytitle("Number of firms")
    graph export "output/fig/cohort-`spec'-histogram.png", replace
}
predict management_p

foreach X in management operations monitoring targets people {
    regress `X' modern_firm [pw=weight], cluster(tax_id)
    outreg2 using "output/tables/`X'-modernity.tex", replace tex(frag pr)
    regress `X' modern_ceo [pw=weight], cluster(tax_id)
    outreg2 using "output/tables/`X'-modernity.tex", tex(frag pr)
    regress `X' modern_respondent [pw=weight], cluster(tax_id)
    outreg2 using "output/tables/`X'-modernity.tex", tex(frag pr)
    regress `X' modern_ceo modern_respondent [pw=weight], cluster(tax_id)
    outreg2 using "output/tables/`X'-modernity.tex", tex(frag pr)
    regress `X' modern_ceo modern_respondent lnL foreign [pw=weight], cluster(tax_id)
    outreg2 using "output/tables/`X'-modernity.tex", tex(frag pr)
}


