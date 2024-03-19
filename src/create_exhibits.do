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
preserve

use "input/wms-Hungary-2018/wms_hu_analysis.dta", clear
gen 	country = "Hungary"
gen 	sic2 = .
gen 	emp = "A) 50 to 100" 	if employment < 101
replace emp = "B) 101 to 250" 	if employment < 251
replace emp = "C) 251 to 500"	if employment < 501
replace emp = "D) 501 to 1000"	if employment < 1001
replace emp = "E) 1000+"	if employment > 1000
drop employment 
rename emp employment
keep `vars'
save "temp/hungarian_wave", replace

restore

append using "temp/hungarian_wave.dta"

collapse (mean) management (count) n=management, by(country)
gen 	country_type = 1 	if inlist(country, "Germany", "France", "Great_Britain", "Northern_Ireland", "Republic_of_Ireland") // Western
replace country_type = 2 	if inlist(country, "Portugal", "Spain", "Italy", "Greece") //Mediterran
replace country_type = 3 	if inlist(country, "Poland", "Hungary") //Post-Soviet
replace country_type = 4 	if inlist(country, "Sweden") // Scandinavian
label define ctypes 1 "Western" 2 "Mediterran" 3 "Post-Soviet" 4 "Scandinavian" 
label values country_type ctypes

graph hbar management, nofill over(country_type, sort(mangement) descending gap(0)) ///
	asyvars over(country, sort(management) descending gap(0)) ///
	bar(1, color(maroon) fintensity(inten80)) /// Western
	bar(2, color(navy)   fintensity(inten60)) /// Mediterran
	bar(3, color(navy)   fintensity(inten80)) /// Post-Soviet
	bar(4, color(maroon) fintensity(inten60)) /// Scandinavian
	bar(5, color(grey)   fintensity(inten80)) // Other
graph export "output/management-means.jpg", replace
	
preserve
tempfile gdp
import delimited "temp/gdp-per-capita.csv", clear
save `gdp', replace
restore
merge 1:1 country using `gdp', nogen

twoway scatter management gdp_per_capita, colorvar(country_type) colorlist(maroon%80 navy%60 navy%80 maroon%60 grey%80) colordiscrete coloruseplegend zlabel(, valuelabel)
graph export "output/management-vs-gdp.png"

