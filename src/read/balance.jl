using Kezdi
using Missings
using CSV
using Logging2, LoggingExtras
current_logger = FileLogger("ceo.log", append=false, always_flush=true)
redirect_stdout(current_logger)

@use "input/merleg-LTS-2022/balance/balance_sheet_80_21.dta", clear

@keep @if year > 2016 && year < 2018
@keep frame_id originalid year county fo3 teaor* foundyear sales_clean emp tanass_clean export ranyag wbill immat final_netgep
@generate long frame_id_numeric = Float64(frame_id[3:end]) @if frame_id[1:2] == "ft"
@keep @if !ismissing(originalid) & !ismissing(frame_id_numeric)
@rename originalid tax_id

#xtset tax_id year
@gen aux_cond = year @if !ismissing(sales_clean) && !ismissing(emp)
@egen last_year = maximum(aux_cond), by(tax_id)
@tabulate last_year
@keep @if last_year == year
@drop last_year aux_cond

cols = [:sales_clean, :emp, :tanass_clean, :export, :ranyag, :wbill, :immat, :final_netgep]
for col in cols
    df[!,col] = collect(Missings.replace(df[!,col], 0))
end

CSV.write("temp/balance.csv", df)