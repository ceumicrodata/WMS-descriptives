clear all
use "temp/data.dta"

do "src/create/variables.do"

* FIXME: Geri, can you save these regression tables with outreg2 or estout?
regress management lnL [pw=weight], robust
regress management lnL foreign [pw=weight], robust
regress management lnL foreign exporter [pw=weight], robust

local outcomes lnQ TFP exporter 

foreach Y in `outcomes' {
    regress `Y' management lnL foreign [pw=weight], robust
}
 
