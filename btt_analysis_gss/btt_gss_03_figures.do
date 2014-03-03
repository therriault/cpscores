clear
log close _all
graph drop _all

log using btt_gss_03_figures.log, replace

************************************************************************
*  File-Name:	btt_gss_03_figures.do
*  Date:       	March 2, 2014	
*  Author:     	Andrew Therriault
*  Purpose:    	Create summary figures from GSS for replication
*  Data In:     2006_gss_withcp.dta
*  Data Out:    None
*  Log File:    btt_gss_03_figures.log
*  Status:		Final
*  Machine:     AMT-Thinkpad2
************************************************************************

use gss_withcp.dta, clear

************************************************************************
*   	Creating summary figures					
************************************************************************

*** Using the first MI dataset
mi unset
keep if mi_m == 1

*** Creating graphs and combining

graph box cp_score if orig_sn == 1, over(q4_hetero,lab(labs(small))) ysize(3.25) xsize(4) ///
title("2a. Network Heterogeneity (n=1131)", size(medsmall)) ///
ytitle("Cross-Pressure Score", size(small)) ///
subtitle("Distribution of CP Scores by Partisan Heterogeneity of Respondent's Acquaintances", size(small)) ///
ylabel(, labsize(vsmall)) ///
name(us_a) nodraw

graph box cp_score if orig_sn == 1, over(q4_disagree,lab(labs(small))) ysize(3.25) xsize(4) ///
title("2b. Network Disagreement (n=717)", size(medsmall)) ///
ytitle("Cross-Pressure Score", size(small)) ///
subtitle("Distribution of CP Scores by Proportion of Acquaintances with Conflicting Party ID", size(small)) ///
ylabel(, labsize(vsmall)) ///
name(us_b) nodraw

graph combine us_a us_b, cols(1) xsize(4) ysize(6.5) ycommon ///
	name(us_social) graphregion(margin(zero))

graph save us_social.gph, replace
graph export us_social.wmf, replace

************************************************************************
*   	Closing								
************************************************************************

log close


