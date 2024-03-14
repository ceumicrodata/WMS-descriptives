use "input/merleg-LTS-2022/balance/balance_sheet_80_21.dta", clear

keep if inrange(year, 2016, 2019)
keep frame_id year county fo3 teaor* foundyear sales_clean emp tanass_clean export ranyag wbill immat final_netgep

mvencode sales_clean emp tanass_clean export ranyag wbill immat final_netgep, mv(0) override
save "temp/balance.dta", replace