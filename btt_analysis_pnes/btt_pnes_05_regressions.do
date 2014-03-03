clear
log close _all

log using btt_pnes_05_regressions.log, replace

************************************************************************
*  File-Name:	btt_pnes_05_regressions.do        			
*  Date:       	March 2, 2014						
*  Author:     	Andrew Therriault			               	
*  Purpose:    	Runs regressions of turnout, & interest for replication
*  Data In:     pnes_withcp.dta		     	  		
*  Data Out:    None							
*  Log File:    btt_pnes_05_regressions.log	                                            
*  Status:		Final		                           		
*  Machine:     AMT-Thinkpad2						
************************************************************************

use pnes_withcp.dta, clear

sum cp_top if _mi_m == 1, detail

************************************************************************
*   	Regressing turnout 						
************************************************************************

mi estimate, dots:  ///
	logit beh_turnout cp_top ///
	dem_female dem_age dem_age2 dem_educ dem_educ2 dem_unemployed dem_student  ///
	dem_retired dem_govt dem_selfemployed dem_manager dem_income dem_income2  ///
	dem_union dem_church dem_church2 dem_urbanity dem_urbanity2 ///
	, vce(robust)

logit beh_turnout cp_top  ///
	dem_female dem_age dem_age2 dem_educ dem_educ2 dem_unemployed dem_student  ///
	dem_retired dem_govt dem_selfemployed dem_manager dem_income dem_income2  ///
	dem_union dem_church dem_church2 dem_urbanity dem_urbanity2 ///
	if _mi_m ~= 0, vce(robust)

margins, at(cp_top=(0.26 0.66 0.90))

************************************************************************
*   	Regressing interest						
************************************************************************

mi estimate, dots:  ///
	regress beh_interest cp_top  ///
	dem_female dem_age dem_age2 dem_educ dem_educ2 dem_unemployed dem_student  ///
	dem_retired dem_govt dem_selfemployed dem_manager dem_income dem_income2  ///
	dem_union dem_church dem_church2 dem_urbanity dem_urbanity2 ///
	, vce(robust)

regress beh_interest cp_top  ///
	dem_female dem_age dem_age2 dem_educ dem_educ2 dem_unemployed dem_student  ///
	dem_retired dem_govt dem_selfemployed dem_manager dem_income dem_income2  ///
	dem_union dem_church dem_church2 dem_urbanity dem_urbanity2 ///
	if _mi_m ~= 0, vce(robust)

margins, at(cp_top=(0.26 0.66 0.90))


************************************************************************
*   	Closing								
************************************************************************

log close


