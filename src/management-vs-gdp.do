tempfile gdp
import delimited "external/gdp-per-capita.csv", clear
save `gdp', replace

use "temp/wms-by-country.dta", clear

merge 1:1 country using `gdp', nogen

twoway scatter management gdp_per_capita, colorvar(country_type) colorlist(maroon%80 navy%60 navy%80 maroon%60 grey%80) colordiscrete coloruseplegend zlabel(, valuelabel)
graph export "output/management-vs-gdp.png", replace