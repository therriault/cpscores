clear
log close _all

log using btt_gss_02_cpscores.log, replace

*************************************************************************
*  Filename:	btt_gss_02_cpscores.do 
*  Date:       	March 2, 2014
*  Author:     	Andrew Therriault
*  Purpose:    	Creates CP scores for GSS respondents (replication files)
*  Data In:     gss_prepped.dta
*  Data Out:    gss_withcp.dta
*  Log File:    btt_gss_02_cpscores.log	
*  Status:		Final
*  Machine:     AMT-Thinkpad2	
*************************************************************************

use gss_prepped.dta, clear

*************************************************************************
*   Running logit of vote choice on demographics
*   then calculating party probabilities based on vote choice
*
*	(note: using standard logit over all MI-imputed datasets, in order 
*	to facilitate straightforward prediction.)
*************************************************************************

logit beh_votepref ///
	dem_female i.dem_urbanity i.dem_region i.dem_race ///
	i.dem_age i.dem_educ dem_ws_unemployed dem_ws_student dem_ws_retired ///
	i.dem_church dem_rel_catholic dem_rel_other dem_rel_atheist dem_fund ///
	i.dem_income dem_union dem_immigrant dem_guns ///
	dem_region#dem_urbanity ///
	if _mi_m ~= 0

predict p_dem, pr 

*************************************************************************
*   	Calculating and rescaling CP scores based on vote choice
*************************************************************************

gen cp_score = (1 - abs(2 * p_dem - 1))

drop p_dem

*************************************************************************
*   	Closing & Saving
*************************************************************************

save gss_withcp.dta, replace

log close
