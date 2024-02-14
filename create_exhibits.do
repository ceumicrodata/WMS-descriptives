import delimited "temp/wmsdata_2004_2015.csv", clear
tostring n sic2, replace
levelsof country, local(countries)
ds, has(type numeric)
replace country = "Northern_Ireland" if country == "Northern Ireland"
replace country = "New_Zealand" if country == "New Zealand"
local vars = "management monitor operations people target"
local countries "Japan Vietnam Northern_Ireland New_Zealand" // japan vietnam northern ireland new zeland
foreach c of local countries {
	cap mkdir "output/`c'"
	foreach v of local vars{
		hist `v' if country=="`c'"
		graph export "output/`c'/`c'_`v'.pdf", replace
	}
}

use "input/wms-Hungary-2018/wms_hu_analysis", clear
local vars = "management monitor operations people target"
mkdir "output/Hungary"
foreach v of local vars{
	hist `v'
	graph export "output/Hungary/Hungary_`v'.pdf", replace
}
