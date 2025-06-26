using Kezdi

@use "temp/wms.dta", clear 
wms = getdf()
@use "temp/sample.dta", clear
sample = getdf()
@use "temp/balance.dta", clear
balance = getdf()
@use "temp/ceo.dta", clear
ceo = getdf()

# The following part is just pseudo-code yet as the join does not generate merge variable.
wms = join(wms, sample, on = :tax_id)
@assert wms.merge == 3
setdf(wms)
@drop merge

wms = join(wms, balance, on = :tax_id)
@assert wms.merge == 3
setdf(wms)
@drop merge

wms = join(wms, ceo, on = :frame_id_numeric)
@assert wms.merge == 3
setdf(wms)
@drop merge

# This is well implemented.
@generate birth_year_ceo = birth_year_opten
@replace birth_year_ceo = maximum(birth_year_respondent, birth_year_ceo) if pos == "ceo"
@replace birth_year_respondent = birth_year_ceo if pos == "ceo"

@save "temp/data.dta", replace
