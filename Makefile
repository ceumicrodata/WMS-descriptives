STATA := stata -b do

all: temp/balance.dta temp/wms.dta temp/ceo.dta
temp/balance.dta: input/merleg-LTS-2022/balance/balance_sheet_80_21.dta
	$(STATA) src/read/$(notdir $(basename $@)).do
temp/wms.dta: input/wms-Hungary-2018/wms_hu_clean.dta
	$(STATA) src/read/$(notdir $(basename $@)).do
temp/ceo.dta: input/ceo-panel/ceo-panel.dta
	$(STATA) src/read/$(notdir $(basename $@)).do
temp/%.dta: src/read/%.do
	$(STATA) $<
