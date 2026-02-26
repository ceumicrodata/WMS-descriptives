import delimited "input/wms-special-access/wms_gKiss.csv", clear

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

* Merge Orbis firm-location data to identify East German firms
preserve
import delimited "input/german-firm-locations/firms.csv", clear
rename bvd_id_number firmid
duplicates drop firmid, force 
tempfile orbis
save `orbis'
restore

rename firmid firmid_str
gen firmid = firmid_str
merge m:1 firmid using `orbis', keep(master match)
drop _merge
replace east_germany = 0 if missing(east_germany)
replace country = "East_Germany" if east_germany == 1 & country == "Germany"
drop east_germany firmid
rename firmid_str firmid

append using "temp/wms.dta"

collapse (mean) management (count) n=management, by(country)
gen 	country_type = 1 	if inlist(country, "Germany", "France", "Great_Britain", "Northern_Ireland", "Republic_of_Ireland") // Western
replace country_type = 2 	if inlist(country, "Portugal", "Spain", "Italy", "Greece", "Turkey") //Mediterran
replace country_type = 3 	if inlist(country, "Poland", "Hungary", "East_Germany") //Post-Soviet
replace country_type = 4 	if inlist(country, "Sweden") // Scandinavian
label define ctypes 1 "Western" 2 "Mediterran" 3 "Post-Soviet" 4 "Scandinavian" 
label values country_type ctypes

save "temp/wmsglobal.dta", replace
