using Kezdi

left(text::AbstractString, n::Int) = n > 0 ? text[1:min(n, end)] : text[1:end-min(-n, end)]
right(text::AbstractString, n::Int) = n > 0 ? text[end-min(n, end)+1:end] : text[min(-n, end)+1:end]

df = @use "input/merleg-LTS-2022/balance/balance_sheet_80_21.dta", clear
# this is necessary because `export` is a reserved word in Julia
df.Export = df.export
setdf(df)

@keep @if year <= 2018 && year >= 2016
@keep frame_id originalid year county fo3 teaor_raw teaor03_2d teaor03_1d teaor08_2d teaor08_1d foundyear sales_clean emp tanass_clean Export ranyag wbill immat final_netgep
@generate frame_id_numeric = parse(Int64, right(frame_id, -2)) @if left(frame_id, 2) == "ft"
@keep @if !ismissing(originalid) & !ismissing(frame_id_numeric)
@rename originalid tax_id

@generate cond = cond(!ismissing(sales_clean) && !ismissing(emp), year, -99)
@egen last_year = maximum(cond), by(tax_id)
@tabulate last_year
@keep @if last_year == year
@drop last_year cond

@mvencode sales_clean emp tanass_clean Export ranyag wbill immat final_netgep county teaor_raw teaor03_2d teaor08_2d, mv(0)

@save "temp/balance.dta", replace
