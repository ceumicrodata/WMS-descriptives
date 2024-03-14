tempfile wms balance ceo

use "temp/wms.dta", clear
keep tax_id
duplicates drop
generate byte in_wms = 1
save `wms', replace

use "temp/balance.dta", clear
keep tax_id frame_id_numeric
duplicates drop tax_id, force
generate byte in_balance = 1
save `balance', replace

use "temp/ceo.dta", clear
keep frame_id_numeric
duplicates drop
generate byte in_ceo = 1
save `ceo', replace

use `wms', clear
merge 1:1 tax_id using `balance', nogenerate keep(master match)
merge 1:1 frame_id_numeric using `ceo', nogenerate keep(master match)
mvencode in_wms in_balance in_ceo, mv(0)

save "temp/sample.dta", replace