clear
*log close _all

log using btt_naes_05_regressions.log, replace

************************************************************************
*  Filename:	btt_naes_05_regressions.do        			
*  Date:       	March 2, 2014
*  Author:     	Andrew Therriault			               	
*  Purpose:    	Runs regressions of behavior variables on models with	
*				CP scores for replication					
*  Data In:     naes_withcp.dta	            		
*  Data Out:    None							
*  Log File:    btt_naes_05_regressions.log			                                                 
*  Status:		Final		                           		
*  Machine:     AMT-Thinkpad2
************************************************************************

use naes_withcp.dta, clear

************************************************************************
*   Regressing turnout 
************************************************************************

mi estimate, dots: logit beh_turnout cp_score ///
	dem_female i.dem_income dem_catholic dem_jewish dem_mormon  ///
	dem_muslim dem_orthodox dem_otherreligion dem_atheist  ///
	i.dem_urbanity dem_guns dem_gays i.dem_age  ///
	i.dem_educ dem_unemployed dem_student dem_retired  ///
	dem_selfemployed dem_govt dem_professional dem_bluecollar  ///
	dem_union dem_hispanic dem_asian  ///
	dem_native dem_immigrant i.dem_church dem_military ///
	dem_northeast dem_west dem_central ///
	dem_south#dem_white dem_evangelical#dem_black  ///
	control_margin control_senate control_governor ///
	, vce(robust)

logit beh_turnout cp_score ///
	dem_female i.dem_income dem_catholic dem_jewish dem_mormon  ///
	dem_muslim dem_orthodox dem_otherreligion dem_atheist  ///
	i.dem_urbanity dem_guns dem_gays i.dem_age  ///
	i.dem_educ dem_unemployed dem_student dem_retired  ///
	dem_selfemployed dem_govt dem_professional dem_bluecollar  ///
	dem_union dem_hispanic dem_asian  ///
	dem_native dem_immigrant i.dem_church dem_military ///
	dem_northeast dem_west dem_central ///
	dem_south#dem_white dem_evangelical#dem_black  ///
	control_margin control_senate control_governor ///
	if _mi_m != 0

margins, at(cp_score=(0.26 0.65 0.93))

************************************************************************
*   	Regressing advocacy 						
************************************************************************

mi estimate, dots: logit beh_influence cp_score ///
	dem_female i.dem_income dem_catholic dem_jewish dem_mormon  ///
	dem_muslim dem_orthodox dem_otherreligion dem_atheist  ///
	i.dem_urbanity dem_guns dem_gays i.dem_age  ///
	i.dem_educ dem_unemployed dem_student dem_retired  ///
	dem_selfemployed dem_govt dem_professional dem_bluecollar  ///
	dem_union dem_hispanic dem_asian  ///
	dem_native dem_immigrant i.dem_church dem_military ///
	dem_northeast dem_west dem_central ///
	dem_south#dem_white dem_evangelical#dem_black  ///
	control_margin control_senate control_governor ///
	, vce(robust)

logit beh_influence cp_score ///
	dem_female i.dem_income dem_catholic dem_jewish dem_mormon  ///
	dem_muslim dem_orthodox dem_otherreligion dem_atheist  ///
	i.dem_urbanity dem_guns dem_gays i.dem_age  ///
	i.dem_educ dem_unemployed dem_student dem_retired  ///
	dem_selfemployed dem_govt dem_professional dem_bluecollar  ///
	dem_union dem_hispanic dem_asian  ///
	dem_native dem_immigrant i.dem_church dem_military ///
	dem_northeast dem_west dem_central ///
	dem_south#dem_white dem_evangelical#dem_black  ///
	control_margin control_senate control_governor ///
	if _mi_m != 0

margins, at(cp_score=(0.26 0.65 0.93))

************************************************************************
*   	Regressing contribution						
************************************************************************

mi estimate, dots: logit beh_donate cp_score ///
	dem_female i.dem_income dem_catholic dem_jewish dem_mormon  ///
	dem_muslim dem_orthodox dem_otherreligion dem_atheist  ///
	i.dem_urbanity dem_guns dem_gays i.dem_age  ///
	i.dem_educ dem_unemployed dem_student dem_retired  ///
	dem_selfemployed dem_govt dem_professional dem_bluecollar  ///
	dem_union dem_hispanic dem_asian  ///
	dem_native dem_immigrant i.dem_church dem_military ///
	dem_northeast dem_west dem_central ///
	dem_south#dem_white dem_evangelical#dem_black  ///
	control_margin control_senate control_governor ///
	, vce(robust)

logit beh_donate cp_score ///
	dem_female i.dem_income dem_catholic dem_jewish dem_mormon  ///
	dem_muslim dem_orthodox dem_otherreligion dem_atheist  ///
	i.dem_urbanity dem_guns dem_gays i.dem_age  ///
	i.dem_educ dem_unemployed dem_student dem_retired  ///
	dem_selfemployed dem_govt dem_professional dem_bluecollar  ///
	dem_union dem_hispanic dem_asian  ///
	dem_native dem_immigrant i.dem_church dem_military ///
	dem_northeast dem_west dem_central ///
	dem_south#dem_white dem_evangelical#dem_black  ///
	control_margin control_senate control_governor ///
	if _mi_m != 0

margins, at(cp_score=(0.26 0.65 0.93))

************************************************************************
*   	Regressing general interest in politics				
************************************************************************

mi estimate, dots: regress beh_interest cp_score ///
	dem_female i.dem_income dem_catholic dem_jewish dem_mormon  ///
	dem_muslim dem_orthodox dem_otherreligion dem_atheist  ///
	i.dem_urbanity dem_guns dem_gays i.dem_age  ///
	i.dem_educ dem_unemployed dem_student dem_retired  ///
	dem_selfemployed dem_govt dem_professional dem_bluecollar  ///
	dem_union dem_hispanic dem_asian  ///
	dem_native dem_immigrant i.dem_church dem_military ///
	dem_northeast dem_west dem_central ///
	dem_south#dem_white dem_evangelical#dem_black sdays* ///
	control_margin control_senate control_governor ///
	, vce(robust)

regress beh_interest cp_score ///
	dem_female i.dem_income dem_catholic dem_jewish dem_mormon  ///
	dem_muslim dem_orthodox dem_otherreligion dem_atheist  ///
	i.dem_urbanity dem_guns dem_gays i.dem_age  ///
	i.dem_educ dem_unemployed dem_student dem_retired  ///
	dem_selfemployed dem_govt dem_professional dem_bluecollar  ///
	dem_union dem_hispanic dem_asian  ///
	dem_native dem_immigrant i.dem_church dem_military ///
	dem_northeast dem_west dem_central ///
	dem_south#dem_white dem_evangelical#dem_black sdays* ///
	control_margin control_senate control_governor ///
	if _mi_m != 0

margins, at(cp_score=(0.26 0.65 0.93))

************************************************************************
*   	Regressing discussion 						
************************************************************************

mi estimate, dots: regress beh_discuss cp_score ///
	dem_female i.dem_income dem_catholic dem_jewish dem_mormon  ///
	dem_muslim dem_orthodox dem_otherreligion dem_atheist  ///
	i.dem_urbanity dem_guns dem_gays i.dem_age  ///
	i.dem_educ dem_unemployed dem_student dem_retired  ///
	dem_selfemployed dem_govt dem_professional dem_bluecollar  ///
	dem_union dem_hispanic dem_asian  ///
	dem_native dem_immigrant i.dem_church dem_military ///
	dem_northeast dem_west dem_central ///
	dem_south#dem_white dem_evangelical#dem_black sdays* ///
	control_margin control_senate control_governor ///
	, vce(robust)

regress beh_discuss cp_score ///
	dem_female i.dem_income dem_catholic dem_jewish dem_mormon  ///
	dem_muslim dem_orthodox dem_otherreligion dem_atheist  ///
	i.dem_urbanity dem_guns dem_gays i.dem_age  ///
	i.dem_educ dem_unemployed dem_student dem_retired  ///
	dem_selfemployed dem_govt dem_professional dem_bluecollar  ///
	dem_union dem_hispanic dem_asian  ///
	dem_native dem_immigrant i.dem_church dem_military ///
	dem_northeast dem_west dem_central ///
	dem_south#dem_white dem_evangelical#dem_black sdays* ///
	control_margin control_senate control_governor ///
	if _mi_m != 0

margins, at(cp_score=(0.26 0.65 0.93))

************************************************************************
*   	Regressing knowledge						
************************************************************************

mi estimate, dots: regress know_scale cp_score ///
	dem_female i.dem_income dem_catholic dem_jewish dem_mormon  ///
	dem_muslim dem_orthodox dem_otherreligion dem_atheist  ///
	i.dem_urbanity dem_guns dem_gays i.dem_age  ///
	i.dem_educ dem_unemployed dem_student dem_retired  ///
	dem_selfemployed dem_govt dem_professional dem_bluecollar  ///
	dem_union dem_hispanic dem_asian  ///
	dem_native dem_immigrant i.dem_church dem_military ///
	dem_northeast dem_west dem_central ///
	dem_south#dem_white dem_evangelical#dem_black sdays* ///
	control_margin control_senate control_governor ///
	, vce(robust)

regress know_scale cp_score ///
	dem_female i.dem_income dem_catholic dem_jewish dem_mormon  ///
	dem_muslim dem_orthodox dem_otherreligion dem_atheist  ///
	i.dem_urbanity dem_guns dem_gays i.dem_age  ///
	i.dem_educ dem_unemployed dem_student dem_retired  ///
	dem_selfemployed dem_govt dem_professional dem_bluecollar  ///
	dem_union dem_hispanic dem_asian  ///
	dem_native dem_immigrant i.dem_church dem_military ///
	dem_northeast dem_west dem_central ///
	dem_south#dem_white dem_evangelical#dem_black sdays* ///
	control_margin control_senate control_governor ///
	if _mi_m != 0

margins, at(cp_score=(0.26 0.65 0.93))

************************************************************************
*   	Creating alienation and indifference measures 						
************************************************************************

gen therm_indiff = (10 - therm_diff)*10
gen therm_alien = (10 - therm_max)*10 if therm_bush ~= . & therm_kerry ~= .

************************************************************************
*   	Regressing indifference						
************************************************************************

mi estimate, dots: regress therm_indiff cp_score ///
	dem_female i.dem_income dem_catholic dem_jewish dem_mormon  ///
	dem_muslim dem_orthodox dem_otherreligion dem_atheist  ///
	i.dem_urbanity dem_guns dem_gays i.dem_age  ///
	i.dem_educ dem_unemployed dem_student dem_retired  ///
	dem_selfemployed dem_govt dem_professional dem_bluecollar  ///
	dem_union dem_hispanic dem_asian  ///
	dem_native dem_immigrant i.dem_church dem_military ///
	dem_northeast dem_west dem_central ///
	dem_south#dem_white dem_evangelical#dem_black sdays* ///
	control_margin control_senate control_governor ///
	, vce(robust)

regress therm_indiff cp_score ///
	dem_female i.dem_income dem_catholic dem_jewish dem_mormon  ///
	dem_muslim dem_orthodox dem_otherreligion dem_atheist  ///
	i.dem_urbanity dem_guns dem_gays i.dem_age  ///
	i.dem_educ dem_unemployed dem_student dem_retired  ///
	dem_selfemployed dem_govt dem_professional dem_bluecollar  ///
	dem_union dem_hispanic dem_asian  ///
	dem_native dem_immigrant i.dem_church dem_military ///
	dem_northeast dem_west dem_central ///
	dem_south#dem_white dem_evangelical#dem_black sdays* ///
	control_margin control_senate control_governor ///
	if _mi_m != 0

margins, at(cp_score=(0.26 0.65 0.93))

************************************************************************
*   	Regressing alienation						
************************************************************************

mi estimate, dots: regress therm_alien cp_score ///
	dem_female i.dem_income dem_catholic dem_jewish dem_mormon  ///
	dem_muslim dem_orthodox dem_otherreligion dem_atheist  ///
	i.dem_urbanity dem_guns dem_gays i.dem_age  ///
	i.dem_educ dem_unemployed dem_student dem_retired  ///
	dem_selfemployed dem_govt dem_professional dem_bluecollar  ///
	dem_union dem_hispanic dem_asian  ///
	dem_native dem_immigrant i.dem_church dem_military ///
	dem_northeast dem_west dem_central ///
	dem_south#dem_white dem_evangelical#dem_black sdays* ///
	control_margin control_senate control_governor ///
	, vce(robust)

regress therm_alien cp_score ///
	dem_female i.dem_income dem_catholic dem_jewish dem_mormon  ///
	dem_muslim dem_orthodox dem_otherreligion dem_atheist  ///
	i.dem_urbanity dem_guns dem_gays i.dem_age  ///
	i.dem_educ dem_unemployed dem_student dem_retired  ///
	dem_selfemployed dem_govt dem_professional dem_bluecollar  ///
	dem_union dem_hispanic dem_asian  ///
	dem_native dem_immigrant i.dem_church dem_military ///
	dem_northeast dem_west dem_central ///
	dem_south#dem_white dem_evangelical#dem_black sdays* ///
	control_margin control_senate control_governor ///
	if _mi_m != 0

margins, at(cp_score=(0.26 0.65 0.93))

************************************************************************
*   	Closing								
************************************************************************

log close


