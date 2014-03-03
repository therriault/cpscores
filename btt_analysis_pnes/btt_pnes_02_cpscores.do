clear
log close _all

log using btt_pnes_02_cpscores.log, replace

************************************************************************
*  File-Name:	btt_pnes_02_cpscores.do        				
*  Date:       	March 2, 2014						
*  Author:     	Andrew Therriault			               	
*  Purpose:    	Creates CP scores for PNES respondents for replication		
*  Data In:     pnes_prepped.dta		     	  		
*  Data Out:    pnes_withcp.dta					
*  Log File:    btt_pnes_02_cpscores.log				
*  Status:		Final
*  Machine:     AMT-Thinkpad2
************************************************************************

use pnes_prepped.dta

************************************************************************
*   Running MNL of vote choice on demographics			
*	then using it to predict party probabilities (7 parties)		
************************************************************************

***Running mlogit analysis

mi estimate, dots: ///
	mlogit beh_vc dem_female dem_age dem_age2 dem_educ dem_educ2 dem_unemployed dem_student ///
	dem_retired dem_govt dem_selfemployed dem_manager dem_income dem_income2 ///
	dem_union dem_church dem_church2 dem_urbanity dem_urbanity2 ///
	if beh_vc == 1 | beh_vc == 2 | beh_vc == 4 | beh_vc == 5 | ///
	beh_vc == 6 | beh_vc == 7 | beh_vc == 10 ///
	, vce(robust)

mlogit beh_vc dem_female dem_age dem_age2 dem_educ dem_educ2 dem_unemployed dem_student ///
	dem_retired dem_govt dem_selfemployed dem_manager dem_income dem_income2 ///
	dem_union dem_church dem_church2 dem_urbanity dem_urbanity2 ///
	if (beh_vc == 1 | beh_vc == 2 | beh_vc == 4 | beh_vc == 5 | ///
	beh_vc == 6 | beh_vc == 7 | beh_vc == 10) & (_mi_m ~= 0) ///
	, vce(robust)

***Calculating predicted probabilities

predict p_1-p_7, pr

************************************************************************
*   Calculating full variance CP scores for each individual 					
************************************************************************

egen cp_full = rsd(p_*)

***Rescaling to [0,1] and reversing the sign

sum cp_full if (_mi_m ~= 0)
replace cp_full = cp_full - r(min)

sum cp_full if (_mi_m ~= 0)
replace cp_full = cp_full / r(max)

sum cp_full if (_mi_m ~= 0)

replace cp_full = 1 - cp_full

sum cp_full if (_mi_m ~= 0)

************************************************************************
*   Calculating first differences and top-3 variance versions 					
************************************************************************

*** Calculating Ordered Probabilities	

*P = # Parties
*C = Count for creating the "px" variables
*V = Count for position variable 
*I = Count for variable being replaced with 0 if position variable "i"

local p 7
local c 1
while `c' <= `p' {

	gen px_`c' = p_`c'
	local ++c

	} 
		
local v 1
while `v' <= `p' { 	      	

	gen po_`v' = max(px_1, px_2, px_3, px_4, px_5, px_6, px_7)
	local i 1

	while `i' <= `p' {		

		replace px_`i' = 0 if px_`i' == po_`v'
		local ++i
		
		} 
		
	local ++v
	
	}
	
*** Calculating first differences	

gen cp_fd = po_1 - po_2

*** Rescaling to 1 and reversing the sign

sum cp_fd if (_mi_m ~= 0)
replace cp_fd = cp_fd - r(min)

sum cp_fd if (_mi_m ~= 0)
replace cp_fd = cp_fd / r(max)

sum cp_fd if (_mi_m ~= 0)

replace cp_fd = 1 - cp_fd

sum cp_fd if (_mi_m ~= 0)

*** Calculating top-3 variance

egen cp_top = rsd(po_1 po_2 po_3)

***Rescaling to 1 and reversing the sign

sum cp_top if (_mi_m ~= 0)
replace cp_top = cp_top - r(min)

sum cp_top if (_mi_m ~= 0)
replace cp_top = cp_top / r(max)

sum cp_top if (_mi_m ~= 0)

replace cp_top = 1 - cp_top

sum cp_top if (_mi_m ~= 0)


************************************************************************
*   	Labeling Variables						
************************************************************************

label variable cp_top "CP Scores, Top-3"
label variable cp_full "CP Scores, Full"
label variable cp_fd "CP Scores, First Diffs"

************************************************************************
*   	Closing & Saving						
************************************************************************

save pnes_withcp.dta, replace

log close
