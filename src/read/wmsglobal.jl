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

@append "temp/wms.dta"

@collapse management = mean(management)  n=count(management), by(country)
@generate country_type = "Western" 	@if country in ["Germany", "France", "Great_Britain", "Northern_Ireland", "Republic_of_Ireland"]
@replace country_type = "Mediterran" 	@if country in ["Portugal", "Spain", "Italy", "Greece", "Turkey"] 
@replace country_type = "Post-Soviet" 	@if country in ["Poland", "Hungary"] 
@replace country_type = "Scandinavian" 	@if country in ["Sweden"] 

@save "temp/wmsglobal.dta", replace