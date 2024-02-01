clear all
use "temp/firm-panel.dta"

keep if in_wiw
keep if year == 2013
keep if !missing(birth_year, year_degree, degree, first_year_in_market)

generate age_at_graduation = year_degree - birth_year
generate age_at_entry = first_year_in_market - birth_year

keep if inrange(age_at_graduation, 14, 60)
keep if inrange(age_at_entry, 14, 80)
generate years_after_graduation = age_at_entry - age_at_graduation

collapse (mean) age_at_entry age_at_graduation years_after_graduation first_year_in_market, by(birth_year)
keep if inrange(birth_year, 1940, 1990)
tsset birth_year
label variable birth_year "Birth year"
label variable age_at_entry "Age at first CEO job"
label variable first_year_in_market "First year as CEO"

tsline first_year_in_market, scheme(white_tableau)
graph export "output/fig/life-cycle.png", replace width(1040)
