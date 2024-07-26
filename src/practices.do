clear all
use "temp/data.dta"

do "src/create/variables.do"

regress management lnL [pw=weight], robust
outreg2 using "output/tables/management-lnL.tex",replace tex(frag pr)
regress management lnL entrepreneur [pw=weight], robust
outreg2 using "output/tables/management-lnL.tex",replace tex(frag pr)
regress management lnL foreign [pw=weight], robust
outreg2 using "output/tables/management-lnL.tex", tex(frag pr)
regress management lnL exporter [pw=weight], robust
outreg2 using "output/tables/management-lnL.tex", tex(frag pr)
regress management lnL expat [pw=weight], robust
outreg2 using "output/tables/management-lnL.tex", tex(frag pr)

local outcomes lnQ TFP exporter 

foreach Y in `outcomes' {
    regress `Y' management lnL foreign [pw=weight], robust
    if "`Y'" == "lnQ"{
	outreg2 using "output/tables/outcomes-management.tex",replace tex(frag pr)
    }
    else {
    	outreg2 using "output/tables/outcomes-management.tex", tex(frag pr)
    }
}
 
