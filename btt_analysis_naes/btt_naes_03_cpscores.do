clear
*log close _all

log using btt_naes_03_cpscores.log, replace

************************************************************************
*  Filename:	btt_naes_03_cpscores.do        				
*  Date:       	March 2, 2014						
*  Author:     	Andrew Therriault			               	
*  Purpose:    	Creates CP scores in NAES for replication			
*  Data In:     naes_prepped.dta	       	  		
*  Data Out:    naes_withcp.dta				
*  Log File:    btt_naes_03_cpscores.log	                                        
*  Status:	Final		                           		
*  Machine:     AMT-Thinkpad2						
************************************************************************

use naes_prepped.dta

************************************************************************
*   	Running logit of vote choice / intention on demographics	
*   	then calculating party probabilities based on vote choice	
************************************************************************

mi estimate, dots: ///
	logit beh_vote ///
	dem_female i.dem_income dem_catholic dem_jewish dem_mormon ///
	dem_muslim dem_orthodox dem_otherreligion dem_atheist ///
	i.dem_urbanity dem_guns dem_gays i.dem_age ///
	i.dem_educ dem_unemployed dem_student dem_retired ///
	dem_selfemployed dem_govt dem_professional dem_bluecollar ///
	dem_union dem_hispanic dem_asian ///
	dem_native dem_immigrant i.dem_church dem_military ///
	dem_northeast dem_west dem_central ///
	dem_south#dem_white dem_evangelical#dem_black ///
	, vce(robust)

logit beh_vote ///
	dem_female i.dem_income dem_catholic dem_jewish dem_mormon ///
	dem_muslim dem_orthodox dem_otherreligion dem_atheist ///
	i.dem_urbanity dem_guns dem_gays i.dem_age ///
	i.dem_educ dem_unemployed dem_student dem_retired ///
	dem_selfemployed dem_govt dem_professional dem_bluecollar ///
	dem_union dem_hispanic dem_asian ///
	dem_native dem_immigrant i.dem_church dem_military ///
	dem_northeast dem_west dem_central ///
	dem_south#dem_white dem_evangelical#dem_black ///
	if _mi_m ~= 0

predict p_dem, pr

************************************************************************
*   	Calculating and rescaling CP scores based on vote choice	
************************************************************************

gen cp_score = (1 - abs(2 * p_dem - 1))

drop p_dem

************************************************************************
*   	Closing & Saving						
************************************************************************

save naes_withcp.dta, replace

log close
