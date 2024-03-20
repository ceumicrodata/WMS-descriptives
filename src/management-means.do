use "temp/wms-by-country.dta", clear

graph hbar management, nofill over(country_type, sort(mangement) descending gap(0)) ///
	asyvars over(country, sort(management) descending gap(0)) ///
	bar(1, color(maroon) fintensity(inten80)) /// Western
	bar(2, color(navy)   fintensity(inten60)) /// Mediterran
	bar(3, color(navy)   fintensity(inten80)) /// Post-Soviet
	bar(4, color(maroon) fintensity(inten60)) /// Scandinavian
	bar(5, color(grey)   fintensity(inten80)) // Other
graph export "output/management-means.png", replace