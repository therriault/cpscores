clear
*log close _all
graph drop _all

log using btt_naes_04_figures.log, replace

************************************************************************
*  Filename:	btt_naes_04_figures.do        				
*  Date:       	March 2, 2014						
*  Author:     	Andrew Therriault			               	
*  Purpose:    	Create summary figs for replication			
*  Data In:     naes_withcp.dta	      	  		
*  Data Out:    None							
*  Log File:    btt_naes_04_figures.log	                                    
*  Status:	Final		                           		
*  Machine:     AMT-Thinkpad2					
************************************************************************

use naes_withcp.dta

************************************************************************
*   	Creating summary figures					
************************************************************************

*** Figure 1a
hist cp_score if _mi_m ~= 0, bin(10) start(0) ysize(4) xsize(6.5) ///
	xtitle("CP Score")  ///
	title("(a) Overall", size(medium))  ///
	subtitle("Mean = 0.622", size(medsmall))  ///
	name("overall") ///
	percent

graph save us_overall.gph, replace
graph export us_overall.wmf, replace

*** Figure 1b
hist cp_score  ///
	if dem_evangelical == 1 & dem_union == 0 & _mi_m ~= 0,  ///
	bin(10) start(0)  ///
	xtitle("CP Score", size(small))  ///
	title("Evangelical, Non-Union") ///
	subtitle("Mean = 0.509", size(medsmall)) ///
	name("fig1a") nodraw ///
	percent

hist cp_score  ///
	if dem_evangelical == 1 & dem_union == 1 & _mi_m ~= 0,  ///
	bin(10) start(0)  ///
	xtitle("CP Score", size(small))  ///
	title("Evangelical, Union") ///
	subtitle("Mean = 0.602", size(medsmall)) ///
	name("fig1b") nodraw ///
	percent

hist cp_score  ///
	if dem_urbanity == 3 & dem_income == 1 & _mi_m ~= 0,  ///
	bin(10) start(0)  ///
	xtitle("CP Score", size(small))  ///
	title("Poor, Urban") ///
	subtitle("Mean = 0.522", size(medsmall)) ///
	name("fig1c") nodraw ///
	percent

hist cp_score  ///
	if dem_urbanity == 1 & dem_income == 1 & _mi_m ~= 0, ///
	bin(10) start(0) ///
	xtitle("CP Score", size(small)) ///
	title("Poor, Rural") ///
	subtitle("Mean = 0.639", size(medsmall)) ///
	name("fig1d") nodraw ///
	percent

hist cp_score  ///
	if dem_south == 1 & dem_white == 1 & _mi_m ~= 0, ///
	bin(10) start(0)  ///
	xtitle("CP Score", size(small))  ///
	title("White, Southern") ///
	subtitle("Mean = 0.620", size(medsmall)) ///
	name("fig1e") nodraw ///
	percent

hist cp_score  ///
	if dem_northeast == 1 & dem_white == 1 & _mi_m ~= 0, ///
	bin(10) start(0)  ///
	xtitle("CP Score", size(small))  ///
	title("White, Northeastern") ///
	subtitle("Mean = 0.701", size(medsmall)) ///
	name("fig1f") nodraw ///
	percent

graph combine fig1a fig1b fig1c fig1d fig1e fig1f,  ///
	xcommon ycommon colfirst rows(2) ysize(4) xsize(6.5)  ///
	title("(b) Among Various Demographic Groups", size(medium))

graph save us_groups.gph, replace
graph export us_groups.wmf, replace

************************************************************************
*   	Graphing Attitudinal Conflict (Figs 3a and 3b)								
************************************************************************

*** Turning consistency to inconsistency, then making quintiles
gen att_incon_all = -1 * att_con_all
gen att_incon_vote = -1 * att_con_vote

xtile q5att_incon_all = att_incon_all, nq(5)
xtile q5att_incon_vote = att_incon_vote, nq(5)

label define het5 1 "Very Low" 2 "Low" 3 "Moderate" 4 "High" 5 "Very High"
label values q5* het5

*** Graphing
graph box cp_score, over(q5att_incon_all,lab(labs(small))) ysize(3.25) xsize(4) ///
	title("3a. Attitudinal Conflict Across Issues (n=81,422)", size(medsmall)) ///
	ytitle("Cross-Pressure Score", size(small)) ///
	subtitle("Distribution of CP Scores by Inconsistency of Policy Preferences Across Issues", size(small)) ///
	ylabel(, labsize(vsmall)) ///
	name(fig3a) nodraw

graph box cp_score, over(q5att_incon_vote,lab(labs(small))) ysize(3.25) xsize(4) ///
	title("3b. Attitudinal Conflict with Party ID (n=51,392)", size(medsmall)) ///
	ytitle("Cross-Pressure Score", size(small)) ///
	subtitle("Distribution of CP Scores by Inconsistency of Policy Preferences With Party ID", size(small)) ///
	ylabel(, labsize(vsmall)) ///
	name(fig3b) nodraw

graph combine fig3a fig3b, cols(1) xsize(4) ysize(6.5) ycommon ///
	name(us_attitude) graphregion(margin(zero))

graph save us_attitude.gph, replace
graph export us_attitude.wmf, replace

************************************************************************
*   	Closing								
************************************************************************

log close


