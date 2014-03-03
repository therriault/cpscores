clear
log close _all
graph drop _all

log using btt_pnes_04_figures.log, replace

************************************************************************
*  Filename:	btt_pnes_04_figures.do        							
*  Date:       	March 2, 2014											
*  Author:     	Andrew Therriault			          			     	
*  Purpose:    	Graphing distributions of scores in PNES for replication		
*  Data In:     pnes_withcp.dta		     	  					
*  Data Out:    None													
*  Log File:    btt_pnes_04_figures.log				                                            
*  Status:	Final		                    			       		
*  Machine:     AMT-ThinkPad2											
************************************************************************

use pnes_withcp.dta, clear

************************************************************************
*	Creating summary figure overall										
************************************************************************

sum cp_top if _mi_m ~= 0

hist cp_top if _mi_m ~= 0, bin(10) start(0)  ysize(4) xsize(6.5) ///
	xtitle("CP Score")  ///
	title("A2a. Overall", size(medium)) ///
	subtitle("Mean = 0.681", size(medsmall)) /// 
	name(overall)
	
graph save poland_overall.gph, replace
graph export poland_overall.wmf, replace

************************************************************************
*	Creating summary figures by group								
*																		
*	NOTES:															
*																		
*	For sample size reasons, I use above and below median income 	
*	instead of more extreme thresholds of wealthy / poor			
*																		
*	Young = 50 and under, old = over 50, can't be more precise b/c	
*	self-employment already narrows samples considerably, and that	
*	is especially true for those at the extremes (who may be 		
*	students or retirees)											
*																		
*	High education completed secondary, low education only 			
*	elementary---middle category is some secondary or vocational	
*																		
*	Religious is weekly churchgoers									
*																		
*	Urban means town/city is 50k+
*																		
************************************************************************

*** Limiting to original dataset (so no imputed demos) for group-level
mi unset
keep if mi_m == 0

gen wealthy = (dem_income >= .117)
gen young = (dem_age <= 50)
gen old = (dem_age > 50)
gen religious = (dem_church >= 7)
gen loweduc = (dem_educ <= 3)
gen higheduc = (dem_educ >= 6)
gen urban = (dem_urbanity >= 4)

*** LOW EDUCATION NOT-WEALTHY VS LOW EDUCATION NOT WEALTHY

ttest cp_top if loweduc==1, by(wealthy)

hist cp_top  ///
	if loweduc == 1 & wealthy == 0, ///
	bin(10) start(0) ///
	percent  ///
	xtitle("CP Score (Top 3)", size(small))  ///
	title("Low Education, Less Wealthy") ///
	subtitle("Mean = 0.619, n = 313", size(medsmall))  ///
	name("c1") nodraw

hist cp_top  ///
	if loweduc == 1 & wealthy == 1,  ///
	bin(10) start(0) ///
	percent  ///
	xtitle("CP Score (Top 3)", size(small))  ///
	title("Low Education, More Wealthy") ///
	subtitle("Mean = 0.840, n = 187", size(medsmall))  ///
	name("c2") nodraw

*** OLD RELIGIOUS VS YOUNG RELIGIOUS

ttest cp_top if religious==1, by(old)

hist cp_top  ///
	if old == 1 & religious == 1,  ///
	bin(10) start(0) ///
	percent  ///
	xtitle("CP Score (Top 3)", size(small))  ///
	title("Religious, Older") ///
	subtitle("Mean = 0.785, n = 422", size(medsmall))  ///
	name("b1") nodraw

hist cp_top  ///
	if young == 1 & religious == 1,  ///
	bin(10) start(0) ///
	percent  ///
	xtitle("CP Score (Top 3)", size(small))  ///
	title("Religious, Younger") ///
	subtitle("Mean = 0.833, n = 487", size(medsmall))  ///
	name("b2") nodraw

*** URBAN NON-RELIGIOUS VS URBAN RELIGIOUS

ttest cp_top if urban==1, by(religious)

hist cp_top  ///
	if urban == 1 & religious == 0,  ///
	bin(10) start(0) ///
	percent  ///
	xtitle("CP Score (Top 3)", size(small))  ///
	title("Urban, Non-Religious") ///
	subtitle("Mean = 0.615, n = 397", size(medsmall))  ///
	name("a1") nodraw

hist cp_top  ///
	if urban == 1 & religious == 1,  ///
	bin(10) start(0) ///
	percent  ///
	xtitle("CP Score (Top 3)", size(small))  ///
	title("Urban, Religious") ///
	subtitle("Mean = 0.815, n = 336", size(medsmall))  ///
	name("a2") nodraw
	
*** Combining all

graph combine a1 a2 b1 b2 c1 c2,  ///
	xcommon ycommon colfirst rows(2) ysize(4) xsize(6.5) ///
	subtitle("Among Various Demographic Groups (Top 3 Scores)")

graph save poland_groups.gph, replace
graph export poland_groups.png, replace
graph export poland_groups.pdf, replace

log close


