use "input/merleg-LTS-2022/balance/balance_sheet_80_21.dta", clear

keep if inrange(year, 2016, 2018)
keep frame_id originalid year county fo3 teaor* foundyear sales_clean emp tanass_clean export ranyag wbill immat final_netgep
generate long frame_id_numeric = real(substr(frame_id, 3, .)) if substr(frame_id, 1, 2) == "ft"
keep if !missing(originalid) & !missing(frame_id_numeric)
rename originalid tax_id

xtset tax_id year
egen last_year = max(cond(!missing(sales_clean, emp), year, .)), by(tax_id)
tabulate last_year
keep if last_year == year
drop last_year

mvencode sales_clean emp tanass_clean export ranyag wbill immat final_netgep county teaor_raw teaor03_2d teaor_08_2d, mv(0) override
