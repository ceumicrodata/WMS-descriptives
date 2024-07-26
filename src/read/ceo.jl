using Kezdi
using Logging
io = open

@use "input/ceo-panel/ceo-panel.dta", clear
@rename birth_year birth_year_opten
# propagate birth year to all years
@egen byear = minimum(birth_year_opten), by(person_id)
@replace birth_year_opten = byear @if missing(birth_year_opten)
@drop byear

# use oldest reported entry date, even if not in data
# if spell_begin not filled in, use observed year in the data
@egen first_year_in_market = minimum(minimum(spell_begin, year)), by(person_id)

# flag those that were owners first as "entrepreneurs"
@replace first_year_as_owner = missing @if first_year_as_owner > year
@generate entrepreneur = (first_year_as_owner <= minimum(spell_begin, year))
@drop outsider
@generate byte outsider = !entrepreneur

# keep the most senior outsider as the unique ceo
@generate priority = (first_year_in_market - 1940) + 100*(1-outsider)
@egen rank = rank(priority), by(frame_id_numeric,year) unique
@keep @if rank==1

@gen aux_cond = year @if year <= 2017
@egen last_year_before_2017 = maximum(aux_cond), by(frame_id_numeric)
@keep @if (year == last_year_before_2017) | ((frame_id_numeric == 20702230) & (year == 2020))
# 2017 data for firm is missing from ceo-panel, but can be recovered from the cegjegyzek
# For me it has to be added completely manually
@keep first_year_in_market outsider expat birth_year_opten frame_id_numeric year person_id entrepreneur
@count 
#set obs `=`r(N)'+1'
@replace frame_id_numeric = 20702230 @if missing(frame_id_numeric)
@replace year = 2017 @if frame_id_numeric == 20702230 
@replace first_year_in_market = 2000 @if frame_id_numeric == 20702230 
@replace outsider = 0 @if frame_id_numeric == 20702230
@replace expat = 0 @if frame_id_numeric == 20702230
@replace entrepreneur = 1 @if frame_id_numeric == 20702230
@replace birth_year_opten = 1956 @if frame_id_numeric == 20702230

@generate in_cegjegyzek = 1

CSV.write("temp/ceo.dta", getdf())

