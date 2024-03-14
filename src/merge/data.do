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

save "temp/data.dta", replace