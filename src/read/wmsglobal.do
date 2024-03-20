import delimited "input/WMS-2014/wmsdata_2004_2015.csv", clear

replace country="Northern_Ireland" if country=="Northern Ireland"
replace country="Great_Britain" if country=="Great Britain"
replace country="Republic_of_Ireland" if country=="Republic of Ireland"

local europe "France Germany Great_Britain Greece Italy Northern_Ireland Poland Portugal Republic_of_Ireland Spain Sweden Turkey"

gen europe=0
foreach country of local europe{
	replace europe=1 if country == "`country'"
}
keep if europe
drop europe
describe, varlist
local vars `r(varlist)'
di "`vars'"

append using "temp/wms.dta"

collapse (mean) management (count) n=management, by(country)
gen 	country_type = 1 	if inlist(country, "Germany", "France", "Great_Britain", "Northern_Ireland", "Republic_of_Ireland") // Western
replace country_type = 2 	if inlist(country, "Portugal", "Spain", "Italy", "Greece", "Turkey") //Mediterran
replace country_type = 3 	if inlist(country, "Poland", "Hungary") //Post-Soviet
replace country_type = 4 	if inlist(country, "Sweden") // Scandinavian
label define ctypes 1 "Western" 2 "Mediterran" 3 "Post-Soviet" 4 "Scandinavian" 
label values country_type ctypes

save "temp/wmsglobal.dta", replace