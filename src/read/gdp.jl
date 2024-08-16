using Kezdi

df = CSV.read("external/gdp-per-capita.csv", DataFrame)
setdf(df)
@save "temp/gdp.dta", replace