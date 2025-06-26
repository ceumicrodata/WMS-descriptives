@generate lnL = ln(employment_from_balance)
@generate exporter = export > 0
@generate lnQ = ln(sales)
@generate lnK = ln(tanass_clean)
@generate lnM = ln(ranyag)
@generate foreign = fo3

@regress lnQ lnK lnL lnM
predict TFP, resid #TODO fix this line to work properly. Might need to implement in Kezdi.jl

@replace birth_year_firm = foundyear
