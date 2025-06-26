using Kezdi

@use "temp/wms.dta", clear
@keep tax_id
@duplicates drop
@generate in_wms = 1
wms = getdf()

@use "temp/balnce.dta", clear
@keep tax_id frame_id_numeric
@duplicates drop tax_id, force
@generate in_balance = 1
balance = getdf()

@use "temp/ceo.dta", clear
@keep frame_id_numeric
@duplicates drop
@generate in_ceo = 1
ceo = getdf()

setdf(wms)
wms = join(wms, balance, on = :tax_id)
wms = join(wms, ceo, on = :frame_id_numeric)
@mvencode in_wms in_balance in_ceo, mv = 0

@save "temp/sample.dta", replace
