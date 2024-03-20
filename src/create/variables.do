generate lnL = ln(employment_from_balance)
generate exporter = export > 0
generate lnQ = ln(sales)
generate lnK = ln(tanass_clean)
generate lnM = ln(ranyag)
generate foreign = fo3

regress lnQ lnK lnL lnM
predict TFP, resid
