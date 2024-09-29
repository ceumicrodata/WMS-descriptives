using Kezdi

@use "input/ceo-panel/ceo-panel.dta", clear
@rename birth_year birth_year_opten
# propagate birth year to all years
@mvencode birth_year_opten, mv(99999)
@egen byear = minimum(birth_year_opten), by(person_id)
@replace birth_year_opten = byear @if birth_year_opten == 99999
@drop byear

# use oldest reported entry date, even if not in data
# if spell_begin not filled in, use observed year in the data
@egen min_year = minimum(year), by(person_id)
@mvencode spell_begin, mv(99999)
@egen min_spell = minimum(spell_begin), by(person_id)
@egen first_year_in_market = minimum([min_spell, min_year]), by(person_id)
@drop min_spell min_year

# flag those that were owners first as "entrepreneurs"
@replace first_year_as_owner = missing @if first_year_as_owner > year
@mvencode first_year_as_owner, mv(99999)
@generate entrepreneur = (first_year_as_owner <= minimum([spell_begin, year]))
@replace entrepreneur = false @if ismissing(entrepreneur)
@drop outsider
@generate outsider = !entrepreneur

# keep the most senior outsider as the unique ceo
@generate priority = (first_year_in_market - 1940) + 100*(1-outsider)
@egen aux_rank = _n, by(priority, frame_id_numeric, year)
@egen rank = maximum(aux_rank)-_n+1, by(priority, frame_id_numeric, year)
@drop aux_rank
@keep @if rank==1

@generate cond = cond(year <= 2017, year, -99)
@egen last_year_before_2017 = maximum(cond), by(frame_id_numeric)
@keep @if (year == last_year_before_2017) | ((frame_id_numeric == 20702230) & (year == 2020))
# 2017 data for firm is missing from ceo-panel, but can be recovered from the cegjegyzek
# For me it has to be added completely manually
@replace frame_id_numeric = 20702230 @if ismissing(frame_id_numeric)
@replace year = 2017 @if frame_id_numeric == 20702230 
@replace first_year_in_market = 2000 @if frame_id_numeric == 20702230 
@replace outsider = 0 @if frame_id_numeric == 20702230
@replace expat = 0 @if frame_id_numeric == 20702230
@replace entrepreneur = 1 @if frame_id_numeric == 20702230
@replace birth_year_opten = 1956 @if frame_id_numeric == 20702230

@keep first_year_in_market outsider expat birth_year_opten frame_id_numeric year person_id entrepreneur
@count 
#set obs `=`r(N)'+1'

@generate in_cegjegyzek = 1

@save "temp/ceo.dta", replace

