clear all
use "temp/firm-panel.dta", clear

* merge World Management Survey
* only years arround the survey date are valid. keeping multiple because there may be holes in the balance
keep if inrange(year, 2017, 2018)

* only 8-digit IDs are actual tax IDs
generate tax_id = frame_id_numeric if frame_id_numeric <= 99999999
merge m:1 tax_id using "temp/wms.dta", keep(master match) nogenerate
duplicates drop tax_id year, force

generate byte in_wms = !missing(_management)

save "temp/wms-panel.dta", replace