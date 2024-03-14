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


local T1 1950
local T2 1980
local k 5
local offset 25
replace birth_year_firm = birth_year_firm - `offset'
foreach i in respondent firm {
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
tabulate cohort_respondent
tabulate modern_respondent goldrush_respondent
tabulate goldrush_respondent foreign
tabulate modern_respondent foreign

scatter zmanagement cohort_respondent, by(cohort_firm)
scatter zmanagement cohort_firm, by(goldrush_respondent)
scatter zmanagement cohort_respondent, by(goldrush_firm)

twoway	(hist zmanagement if goldrush_firm == 0, by(cohort_respondent) start(-3) width(0.5) color(red%30)) ///
	(hist zmanagement if goldrush_firm == 1, by(cohort_respondent) start(-3) width(0.5) color(green%30)), ///
	legend(order(1 "not goldrush firm" 2 "goldrush firm" ))
	
tab cohort_respondent goldrush_firm, summarize(zmanagement) mean standard freq //cohort 1965 is wierd a bit
tab cohort_respondent foreign, summarize(zmanagement) mean standard freq /// effect of foreign seems to be lower in 1965 cohort
