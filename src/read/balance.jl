using Kezdi
using CSV

left(text::AbstractString, n::Int) = n > 0 ? text[1:min(n, end)] : text[1:end-min(-n, end)]
right(text::AbstractString, n::Int) = n > 0 ? text[end-min(n, end)+1:end] : text[min(-n, end)+1:end]

df = @use "input/merleg-LTS-2022/balance/balance_sheet_80_21.dta", clear
# this is necessary because `export` is a reserved word in Julia
df.Export = df.export
setdf(df)

@keep @if year <= 2018 && year >= 2016
@keep frame_id originalid year county fo3 teaor_raw teaor03_2d teaor03_1d teaor08_2d teaor08_1d foundyear sales_clean emp tanass_clean Export ranyag wbill immat final_netgep

@generate frame_id_numeric = parse(Int64, right(frame_id, -2)) @if left(frame_id, 2) == "ft"
@keep @if !ismissing(frame_id_numeric) && !ismissing(originalid)
@rename originalid tax_id

@generate aux_cond = year @if !ismissing(sales_clean) && !ismissing(emp)
@replace aux_cond = 0 @if ismissing(aux_cond)
@egen last_year = maximum(aux_cond), by(tax_id)
@tabulate last_year
@keep @if last_year == year
@drop last_year aux_cond

cols = [:sales_clean, :emp, :tanass_clean, :Export, :ranyag, :wbill, :immat, :final_netgep, :county,  :teaor_raw, :teaor03_2d, :teaor08_2d]
df = getdf()
for col in cols
    df[!,col] = collect(Missings.replace(df[!,col], 0))
end

CSV.write("temp/balance.csv", df)
