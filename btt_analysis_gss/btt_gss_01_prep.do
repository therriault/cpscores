clear
log close _all
set seed 092981

log using btt_gss_01_prep.log, replace

*************************************************************************
*  Filename:	btt_gss_01_prep.do 
*  Date:       	March 2, 2014	
*  Author:     	Andrew Therriault		
*  Purpose:    	Prepares GSS 2006 data for replication	
*  Data In:     gss_data.dta (from combined GSS file, but includes only 
*				2006 respondents and relevant variables)
*				gss_recodes.dta (original, contains old and new
*				variable codings for each variable)
*  Data Out:    gss_prepped.dta
*  Log File:    btt_gss_01_prep.log
*  Status:		Final	
*  Machine:     AMT-Thinkpad2	
*************************************************************************

*************************************************************************
*   Loading 2006 GSS data (dataset cropped to only relevant variables)
*	then saving "prepped" file which will be updated in this script
*************************************************************************

use gss_data.dta

save gss_prepped.dta, replace
clear

*************************************************************************
*   	Recoding original variables
*************************************************************************

*** Looping over variables to be recoded and partitioning recode dta file
*** (from a spreadsheet that maps old vales to new values) into separate
*** temporary dta files used below

local oldvars region sex age degree wrkstat ///
	wrkslf wrkgovt rincom06 union race ///
	born attend relig fund xnorcsiz owngun ///
	acqreps acqdems pres04 if04who partyid

local newvars dem_region dem_female dem_age dem_educ dem_ws* ///
	dem_selfemployed dem_govt dem_income dem_union dem_race ///
	dem_immigrant dem_church dem_rel* dem_fund dem_urbanity dem_guns ///
	num_reps_acq num_dems_acq beh_vote* beh_vint* *pid*
	
while "`oldvars'" ~="" {
		
	gettoken o oldvars : oldvars
	gettoken n newvars : newvars

	use gss_recodes.dta

	keep `o' `n'
	dropmiss, obs force

	save temp\__`o'.dta, replace
	clear

	}

use gss_prepped.dta

*** Looping over original variables and merging in new variables from
*** recode files. (Algorithm merges on variables to be recoded and 
*** brings in new variables accordingly.)

local oldvars region sex age degree wrkstat ///
	wrkslf wrkgovt rincom06 union race ///
	born attend relig fund xnorcsiz owngun ///
	acqreps acqdems pres04 if04who partyid

local newvars dem_region dem_female dem_age dem_educ dem_ws* ///
	dem_selfemployed dem_govt dem_income dem_union dem_race ///
	dem_immigrant dem_church dem_rel* dem_fund dem_urbanity dem_guns ///
	num_reps_acq num_dems_acq beh_vote* beh_vint* *pid*

while "`oldvars'" ~="" {
		
	gettoken o oldvars : oldvars
	gettoken n newvars : newvars

	di "Matching `o' and `n'"

	merge m:1 `o' using temp\__`o'.dta, ///
		keep(master match) keepusing(`n') nogen

	}

save gss_prepped.dta, replace

*************************************************************************
*	Recoding / generating variables that don't merge easily	(basically,
*	those which combine multiple original variables into one new one)
*************************************************************************

gen beh_votepref = beh_vote2pbush_2004
replace beh_votepref = beh_vint2pbush_2004 if beh_votepref == .

*************************************************************************
*   Cropping dataset to only recoded variables
*************************************************************************

keep dem_* beh_* num_*

*************************************************************************
*  	Hotdecking missing values for lightly-missing variables
*	
*	(Imputing non-continuous variables requires complete data on 
*	RHS, so I'm hotdecking demographics with <2% missing, then
*	using this "full" data to predict more seriously-missing 
*	variables via MI. Hotdecking done by gender, race, and urbanity) 
*************************************************************************

bysort dem_female dem_urbanity dem_race: ///
	hotdeckvar dem_age dem_educ dem_ws_unemployed dem_ws_student /// 
	dem_ws_retired dem_church dem_rel_catholic dem_rel_other ///
	dem_rel_atheist dem_fund beh_pid_party beh_pid_7pt

local vars dem_age dem_educ dem_ws_unemployed dem_ws_student dem_ws_retired ///
	dem_church dem_rel_catholic dem_rel_other dem_rel_atheist dem_fund ///
	beh_pid_party beh_pid_7pt

while "`vars'" ~="" {
		
	gettoken v vars : vars

	drop `v'
	rename `v'_i `v'

	}

*************************************************************************
*   	Generating missing data via MI for other variables
*************************************************************************

gen orig_sn = 1
replace orig_sn = 0 if num_dems_acq == .
replace orig_sn = 0 if num_reps_acq == .

mi set flong

mi register imputed dem_income dem_union dem_immigrant dem_guns 

mi register regular dem_female dem_urbanity dem_region dem_race ///
	dem_age dem_educ dem_ws_unemployed dem_ws_student dem_ws_retired /// 
	dem_church dem_rel_catholic dem_rel_other dem_rel_atheist dem_fund ///
	beh_pid_party beh_pid_7pt

mi impute mlogit dem_income dem_female i.dem_urbanity i.dem_region i.dem_race ///
	i.dem_age i.dem_educ dem_ws_unemployed dem_ws_student dem_ws_retired ///
	i.dem_church dem_rel_catholic dem_rel_other dem_rel_atheist dem_fund ///
	i.beh_pid_7pt, ///
	add(10) rseed(0929) dots noisily

mi impute logit dem_union dem_female i.dem_urbanity i.dem_region i.dem_race ///
	i.dem_age i.dem_educ dem_ws_unemployed dem_ws_student dem_ws_retired ///
	i.dem_church dem_rel_catholic dem_rel_other dem_rel_atheist dem_fund ///
	i.beh_pid_7pt, ///
	replace rseed(0929) dots noisily

mi impute logit dem_immigrant dem_female i.dem_urbanity i.dem_region i.dem_race ///
	i.dem_age i.dem_educ dem_ws_unemployed dem_ws_student dem_ws_retired ///
	i.dem_church dem_rel_catholic dem_rel_other dem_rel_atheist dem_fund ///
	i.beh_pid_7pt, ///
	replace rseed(0929) dots noisily

mi impute logit dem_guns dem_female i.dem_urbanity i.dem_region i.dem_race ///
	i.dem_age i.dem_educ dem_ws_unemployed dem_ws_student dem_ws_retired ///
	i.dem_church dem_rel_catholic dem_rel_other dem_rel_atheist dem_fund ///
	i.beh_pid_7pt, ///
	replace rseed(0929) dots noisily


*************************************************************************
*   	Generating heterogeneity and disagreement measures
*************************************************************************

*** Calculating heterogeneity measure
mi passive: gen hetero = num_reps_acq - num_dems_acq ///
	if num_reps_acq ~= . & num_dems_acq ~= .
mi passive: replace hetero = 1-abs(hetero)

*** Calculating disagreement measure
mi passive: gen disagree = .
mi passive: replace disagree = num_dems_acq if beh_pid_twoparty == 1
mi passive: replace disagree = num_reps_acq if beh_pid_twoparty == 0


*** Creating quartiles
recode hetero (0 0.25 = 1) (0.5 = 2) (0.75 = 3) (1 = 4), ///
	gen(q4_hetero)
recode disagree (0 = 1) (0.25 = 2) (0.5 = 3) (0.75 1 = 4), ///
	gen(q4_disagree)

label define q4 1 "Low" 2 "Moderate" 3 "High" 4 "Very High"
label values q4* q4

*************************************************************************
*   	Closing & Saving
*************************************************************************

order *, alpha

mi describe
summ if _mi_m == 0
summ if _mi_m ~= 0

save gss_prepped.dta, replace

log close
