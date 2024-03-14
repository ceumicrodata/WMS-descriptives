clear all
use "input/wms-Hungary-2018/wms_hu_clean.dta"
keep tax_id weight _management selfscore lean1 lean2 perf1 perf2 perf3 perf4 perf5 perf6 perf7 perf8 perf9 perf10 talent1 talent2 talent3 talent4 talent5 talent6 comp_tenure post_tenure competition firm_age plant_age emp_firm emp_plant onsite xsite1 xsite2 exported mne_cty ownership other_ownership delta_own_yn ownership_pre generation ceo n_family_manag children_current boys_current children_former boys_former central4 central5 central6 central7 levels2ceo levels2pm direct_report percent_m degree_m degree_nm female_m female_nm union mng_left12mnths use_data freq_data type_data data_decision data_analytics holidayleave sickleave patleave ctrts_mgrs_right_skills ctrts_non_mgrs_right_skills ctrts_empl_regulations ctrts_trade_union ctrts_obtain_consultancy ctrts_intro_right_mgmt ctrts_other

mvdecode _all, mv(-99)

duplicates drop tax_id, force
save "temp/wms.dta", replace
