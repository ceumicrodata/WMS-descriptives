clear all
use "input/merleg-LTS-2022/balance/balance_sheet_80_21.dta"

keep if year <= 2018 & year >= 2016
keep frame_id originalid year county fo3 teaor_raw teaor03_2d teaor03_1d teaor08_2d teaor08_1d foundyear sales_clean emp tanass_clean export ranyag wbill immat final_netgep

generate frame_id_numeric = real(substr(frame_id, 3, .)) if substr(frame_id, 1, 2) == "ft"
keep if !missing(originalid) & !missing(frame_id_numeric)
rename originalid tax_id

generate cond = cond(!missing(sales_clean) & !missing(emp), year, -99)
egen last_year = max(cond), by(tax_id)
tabulate last_year
keep if last_year == year
drop last_year cond

save "temp/balance.dta", replace
