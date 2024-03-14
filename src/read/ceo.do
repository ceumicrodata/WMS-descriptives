use "input/ceo-panel/ceo-panel.dta", clear
rename birth_year birth_year_opten
* propagate birth year to all years
tempvar byear
egen `byear' = min(birth_year), by(person_id)
replace birth_year_opten = `byear' if missing(birth_year)

* use oldest reported entry date, even if not in data
* if spell_begin not filled in, use observed year in the data
egen first_year_in_market = min(min(spell_begin, year)), by(person_id)

* flag those that were owners first as "entrepreneurs"
replace first_year_as_owner = . if first_year_as_owner > year
generate byte entrepreneur = first_year_as_owner <= min(spell_begin, year)
drop outsider
generate byte outsider = !entrepreneur

* keep the most senior outsider as the unique ceo
generate priority = (first_year_in_market - 1940) + 100*(1-outsider)
egen rank = rank(priority), by(frame_id_numeric year) unique
keep if rank==1

egen last_year_before_2017 = max(cond(year <= 2017, year, .)), by(frame_id_numeric)
keep if (year == last_year_before_2017) | ((frame_id_numeric == 20702230) & (year == 2020))
* 2017 data for firm is missing from ceo-panel, but can be recovered from the cegjegyzek
replace year = 2017 if frame_id_numeric == 20702230 & year == 2020
replace first_year_in_market = 2000 if frame_id_numeric == 20702230 
replace outsider = 0 if frame_id_numeric == 20702230
replace expat = 0 if frame_id_numeric == 20702230
replace entrepreneur = 1 if frame_id_numeric == 20702230
replace birth_year_opten = 1956 if frame_id_numeric == 20702230

keep first_year_in_market outsider expat birth_year_opten frame_id_numeric year person_id entrepreneur

generate byte in_cegjegyzek = 1

save "temp/ceo.dta", replace