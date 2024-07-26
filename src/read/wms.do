clear all
use "input/wms-Hungary-2018/wms_hu_analysis.dta"
keep tax_id weight _management selfscore lean1 lean2 perf1 perf2 perf3 perf4 perf5 perf6 perf7 perf8 perf9 perf10 talent1 talent2 talent3 talent4 talent5 talent6 comp_tenure post_tenure competition firm_age plant_age emp_firm emp_plant onsite xsite1 xsite2 exported mne_cty ownership other_ownership delta_own_yn ownership_pre generation ceo n_family_manag children_current boys_current children_former boys_former central4 central5 central6 central7 levels2ceo levels2pm direct_report percent_m degree_m degree_nm female_m female_nm union mng_left12mnths data? hols sickleave patleave ctrts_mgrs_right_skills ctrts_non_mgrs_right_skills ctrts_empl_regulations ctrts_trade_union ctrts_obtain_consultancy ctrts_intro_right_mgmt ctrts_other employment age position

rename _management management

generate 	country = "Hungary"
generate 	sic2 = .
generate 	emp = "A) 50 to 100" 	if employment < 101
replace emp = "B) 101 to 250" 	if employment < 251
replace emp = "C) 251 to 500"	if employment < 501
replace emp = "D) 501 to 1000"	if employment < 1001
replace emp = "E) 1000+"	if employment > 1000
rename employment employment_from_balance
rename emp employment

mvdecode _all, mv(-99)
duplicates drop tax_id, force

foreach age in firm_age plant_age comp_tenure post_tenure {
    * some respondents reported year of founding
    replace `age' = 2018 - `age' if `age' > 1900
    replace `age' = . if `age' >= 100
    generate byte round_age = int(`age' / 10) * 10 == `age'
    * if old age is not rounded, it is likely a foundation year
    replace `age' = 2018 - (1900+`age') if (`age' > 60) & !missing(`age') & !round_age
    drop round_age
}

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
generate birth_year_firm = 2018 - firm_age

* this firm has reorganized during the survey period, id is different in sampling frame and in balance
replace tax_id = 25546286 if tax_id == 14444032

save "temp/wms.dta", replace
