use "temp/wmsglobal.dta", clear

merge 1:1 country using "temp/gdp.dta", nogen

twoway scatter management gdp_per_capita, colorvar(country_type) colorlist(maroon%80 navy%60 navy%80 maroon%60 grey%80) colordiscrete coloruseplegend zlabel(, valuelabel)
graph export "output/fig/management-vs-gdp.png", replace