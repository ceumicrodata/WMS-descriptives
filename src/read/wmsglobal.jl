using kezdi

df = CSV.read("input/WMS-2014/wmsdata_2004_2015.csv", DataFrame);setdf(df)

@replace country="Northern_Ireland" @if country=="Northern Ireland"
@replace country="Great_Britain" @if country=="Great Britain"
@replace country="Republic_of_Ireland" @if country=="Republic of Ireland"
eu = ["France","Germany","Great_Britain","Greece","Italy","Northern_Ireland","Poland","Portugal","Republic_of_Ireland","Spain","Sweden","Turkey"]
@generate europe=0
@replace europe=1 @if country in eu
@keep @if europe
@drop europe

## Merge Orbis firm-location data to identify East German firms
orbis = CSV.read("input/german-firm-locations/firms.csv", DataFrame)
rename!(orbis, :bvd_id_number => :firmid)
german = getdf()
german = german[german.country .== "Germany", :]
german = leftjoin(german, orbis, on = :firmid)
german.east_germany = coalesce.(german.east_germany, 0)
german.country[german.east_germany .== 1] .= "East_Germany"
non_german = getdf()[getdf().country .!= "Germany", :]
setdf(vcat(non_german, german, cols=:union))

@append "temp/wms.dta"

@collapse management = mean(management)  n=count(management), by(country)
@generate country_type = "Western" 	@if country in ["Germany", "France", "Great_Britain", "Northern_Ireland", "Republic_of_Ireland"]
@replace country_type = "Mediterran" 	@if country in ["Portugal", "Spain", "Italy", "Greece", "Turkey"]
@replace country_type = "Post-Soviet" 	@if country in ["Poland", "Hungary", "East_Germany"] 
@replace country_type = "Scandinavian" 	@if country in ["Sweden"] 

@save "temp/wmsglobal.dta", replace