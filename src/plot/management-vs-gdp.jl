using Kezdi

@use "temp/wmsglobal.dta", clear
wms = getdf()
@use "temp/gdp.dta", clear
gdp = getdf()

wms = wms.join(gdp, on = :country)

#TODO: fix this plotting to result the same as in the original code.
twoway scatter management gdp_per_capita, colorvar(country_type) colorlist(maroon%80 navy%60 navy%80 maroon%60 grey%80) colordiscrete coloruseplegend zlabel(, valuelabel)
graph export "output/fig/management-vs-gdp.png", replace
