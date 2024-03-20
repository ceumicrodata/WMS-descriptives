use "temp/wms.dta", clear

merge 1:1 tax_id using "temp/sample.dta", keep(master match) 
assert _merge == 3
drop _merge

merge 1:1 tax_id using "temp/balance.dta", keep(master match)
assert _merge == 3
drop _merge

merge 1:1 frame_id_numeric using "temp/ceo.dta", keep(master match)
assert _merge == 3
drop _merge

* there may be multiple CEOs, use the younger
generate birth_year_ceo = birth_year_opten
replace birth_year_ceo = max(birth_year_respondent, birth_year_ceo) if pos == "ceo"
replace birth_year_respondent = birth_year_ceo if pos == "ceo"

save "temp/data.dta", replace