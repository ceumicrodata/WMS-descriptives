clear all
use "temp/data.dta"

do "src/create/variables.do"

* FIXME: Geri, can you save these regression tables with outreg2 or estout?
regress management lnL, robust
regress management lnL foreign, robust
regress management lnL foreign exporter, robust

local outcomes lnQ TFP exporter 

foreach Y in `outcomes' {
    regress `Y' management lnL foreign, robust
}
 
