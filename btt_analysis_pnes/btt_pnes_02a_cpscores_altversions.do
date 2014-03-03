clear
log close _all

log using btt_pnes_02a_cpscores_altversions.log, replace

************************************************************************
*  File-Name:	btt_pnes_02a_cpscores_altversions.do    				
*  Date:       	March 2, 2014					
*  Author:     	Andrew Therriault			               	
*  Purpose:    	Creates Alternate CP scores for PNES respondents	
*  Data In:     pnes_prepped.dta		     	  		
*  Data Out:    None				
*  Log File:    btt_pnes_02a_cpscores_altversions.log		                                                
*  Status:		Final		                           		
*  Machine:     AMT-Thinkpad2						
************************************************************************

use pnes_prepped.dta

************************************************************************
*   Running MNL of vote choice and creating probabilities--4 PARTIES		
************************************************************************

***Running mlogit analysis

mlogit beh_vc dem_female dem_age dem_age2 dem_educ dem_educ2 dem_unemployed dem_student ///
	dem_retired dem_govt dem_selfemployed dem_manager dem_income dem_income2  ///
	dem_union dem_church dem_church2 dem_urbanity dem_urbanity2 ///
	if (beh_vc == 1 | beh_vc == 7 | beh_vc == 4 | beh_vc == 5)  ///
	& (_mi_m ~= 0), iter(500)

***Calculating predicted probabilities

predict p4_1-p4_4, pr


************************************************************************
*   Running MNL of vote choice and creating probabilities--5 PARTIES		
************************************************************************

***Running mlogit analysis

mlogit beh_vc dem_female dem_age dem_age2 dem_educ dem_educ2 dem_unemployed dem_student  ///
	dem_retired dem_govt dem_selfemployed dem_manager dem_income dem_income2  ///
	dem_union dem_church dem_church2 dem_urbanity dem_urbanity2 ///
	if (beh_vc == 1 | beh_vc == 7 | beh_vc == 4 | beh_vc == 5 |  ///
	beh_vc == 6)  ///
	& (_mi_m ~= 0), iter(500)

***Calculating predicted probabilities

predict p5_1-p5_5, pr

************************************************************************
*   Running MNL of vote choice and creating probabilities--6 PARTIES		
************************************************************************

***Running mlogit analysis

mlogit beh_vc dem_female dem_age dem_age2 dem_educ dem_educ2 dem_unemployed dem_student  ///
	dem_retired dem_govt dem_selfemployed dem_manager dem_income dem_income2  ///
	dem_union dem_church dem_church2 dem_urbanity dem_urbanity2 ///
	if (beh_vc == 1 | beh_vc == 7 | beh_vc == 4 | beh_vc == 5 |  ///
	beh_vc == 6 | beh_vc == 10)  ///
	& (_mi_m ~= 0), iter(500)

***Calculating predicted probabilities

predict p6_1-p6_6, pr

************************************************************************
*   Running MNL of vote choice and creating probabilities--7 PARTIES		
************************************************************************

***Running mlogit analysis

mlogit beh_vc dem_female dem_age dem_age2 dem_educ dem_educ2 dem_unemployed dem_student  ///
	dem_retired dem_govt dem_selfemployed dem_manager dem_income dem_income2  ///
	dem_union dem_church dem_church2 dem_urbanity dem_urbanity2 ///
	if (beh_vc == 1 | beh_vc == 7 | beh_vc == 4 | beh_vc == 5 |  ///
	beh_vc == 6 | beh_vc == 10 | beh_vc == 2)  ///
	& (_mi_m ~= 0), iter(500)

***Calculating predicted probabilities

predict p7_1-p7_7, pr

************************************************************************
*   Running MNL of vote choice and creating probabilities--8 PARTIES		
************************************************************************

***Running mlogit analysis

mlogit beh_vc dem_female dem_age dem_age2 dem_educ dem_educ2 dem_unemployed dem_student  ///
	dem_retired dem_govt dem_selfemployed dem_manager dem_income dem_income2  ///
	dem_union dem_church dem_church2 dem_urbanity dem_urbanity2 ///
	if (beh_vc == 1 | beh_vc == 7 | beh_vc == 4 | beh_vc == 5 |  ///
	beh_vc == 6 | beh_vc == 10 | beh_vc == 2 | beh_vc == 3) ///
	& (_mi_m ~= 0), iter(500)

***Calculating predicted probabilities

predict p8_1-p8_8, pr


************************************************************************
*   Calculating full variance, first differences, and top-3 variance
*	CPs for each individual 					
************************************************************************

*** Calculating full variance CP scores

local n 4

	while `n' <= 8 {

		egen cp_full_`n' = rsd(p`n'_*)

		sum cp_full_`n' if (_mi_m ~= 0)
		replace cp_full_`n' = cp_full_`n' - r(min)

		sum cp_full_`n' if (_mi_m ~= 0)
		replace cp_full_`n' = cp_full_`n' / r(max)

		replace cp_full_`n' = 1 - cp_full_`n'

		local ++n

		}

*** Calculating Ordered Probabilities	

local n 4
while `n' <= 8 {

	gen p`n'x_1 = .
	gen p`n'x_2 = .
	gen p`n'x_3 = .
	gen p`n'x_4 = .
	gen p`n'x_5 = .
	gen p`n'x_6 = .
	gen p`n'x_7 = .
	gen p`n'x_8 = .

	local c 1

	while `c' <= `n' {

		replace p`n'x_`c' = p`n'_`c'

		local ++c

		} 

local v 1
	while `v' <= `n' { 	      	

		gen p`n'o_`v' = max(p`n'x_1, p`n'x_2, p`n'x_3, p`n'x_4, ///
			p`n'x_5, p`n'x_6, p`n'x_7, p`n'x_8)

		local i 1

			while `i' <= 8 {		

				replace p`n'x_`i' = 0 if p`n'x_`i' == p`n'o_`v'

				local ++i

				} 

		local ++v

			}

local ++n

}

*** Calculating FDs and Top-3 variance cp scores

local n 4

	while `n' <= 8 {

		gen cp_fd_`n' = p`n'o_1 - p`n'o_2

		sum cp_fd_`n' if (_mi_m ~= 0)
		replace cp_fd_`n' = cp_fd_`n' - r(min)

		sum cp_fd_`n' if (_mi_m ~= 0)
		replace cp_fd_`n' = cp_fd_`n' / r(max)

		replace cp_fd_`n' = 1 - cp_fd_`n'

		egen cp_top_`n' = rsd(p`n'o_1  p`n'o_2 p`n'o_3)

		sum cp_top_`n' if (_mi_m ~= 0)
		replace cp_top_`n' = cp_top_`n' - r(min)

		sum cp_top_`n' if (_mi_m ~= 0)
		replace cp_top_`n' = cp_top_`n' / r(max)

		replace cp_top_`n' = 1 - cp_top_`n'

		local ++n

		}


************************************************************************
*   	Checking Correlations						
************************************************************************

corr cp_full* if (_mi_m ~= 0)
corr cp_top* if (_mi_m ~= 0)
corr cp_fd* if (_mi_m ~= 0)

corr cp_*4 if (_mi_m ~= 0)
corr cp_*5 if (_mi_m ~= 0)
corr cp_*6 if (_mi_m ~= 0)
corr cp_*7 if (_mi_m ~= 0)
corr cp_*8 if (_mi_m ~= 0)

************************************************************************
*   	Closing						
************************************************************************

log close
