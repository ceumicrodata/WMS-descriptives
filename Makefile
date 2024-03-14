STATA := stata -b do
balance := input/merleg-LTS-2022/balance/balance_sheet_80_21.dta
wms := input/wms-Hungary-2018/wms_hu_clean.dta
ceo := input/ceo-panel/ceo-panel.dta

temp/data.dta: src/merge/data.do temp/sample.dta temp/wms.dta temp/balance.dta temp/ceo.dta
	$(STATA) $<
temp/sample.dta: src/merge/sample.do temp/wms.dta temp/balance.dta temp/ceo.dta 
	$(STATA) $<
temp/%.dta: src/read/%.do $(%) 
	$(STATA) $<
