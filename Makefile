STATA := stata -b do
balance := input/merleg-LTS-2022/balance/balance_sheet_80_21.dta
wms := input/wms-Hungary-2018/wms_hu_clean.dta
ceo := input/ceo-panel/ceo-panel.dta
wmsglobal := input/WMS-2014/wmsdata_2004_2015.csv

DATA := balance wms ceo wmsglobal gdp
PLOTS := $(patsubst src/plot/%.do,output/fig/%.png,$(wildcard src/plot/*.do))

all: $(PLOTS)
practices.log: src/practices.do temp/data.dta
	$(STATA) $<
validate.log: src/validate.do temp/data.dta
	$(STATA) $<
output/fig/%.png: src/plot/%.do temp/data.dta
	mkdir -p $(dir $@)
	$(STATA) $<
temp/data.dta: src/merge/data.do temp/sample.dta $(foreach d,$(DATA),temp/$(d).dta)
	$(STATA) $<
temp/sample.dta: src/merge/sample.do temp/wms.dta temp/balance.dta temp/ceo.dta 
	$(STATA) $<
temp/%.dta: src/read/%.do $(balance) $(wms) $(ceo) $(wmsglobal)
	$(STATA) $<
temp/%.dta: src/%.do
	$(STATA) $<
output/%.png: src/%.do
	$(STATA) $<

slides_md := $(wildcard report/slides.md)
slides_tex := $(patsubst report/%.md,output/%.tex,$(slides_md))
slides_pdf := $(patsubst output/%.tex,output/%.pdf,$(slides_tex)) 

$(slides_tex): output/%.tex: report/%.md output/preamble-slides.tex
	pandoc $< \
	    -t beamer \
	    --slide-level 2 \
	    -H output/preamble-slides.tex \
	    -o $@

$(slides_pdf): %.pdf: %.tex
	cd $(dir $@) && pdflatex $(notdir $<)
	rm $(basename $<).log $(basename $<).nav $(basename $<).aux $(basename $<).snm $(basename $<).toc
