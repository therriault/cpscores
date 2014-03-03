clear
*log close _all 

log using btt_naes_06_table.log, replace

************************************************************************
*  Filename:	btt_naes_06_table.do        				
*  Date:       	March 2, 2014						
*  Author:     	Andrew Therriault			               	
*  Purpose:    	Create summary table for Table 3			
*  Data In:     naes_withcp.dta	      	  		
*  Data Out:    naes_groups.csv							
*  Log File:    btt_naes_06_table.log                                           
*  Status:		Final		                           		
*  Machine:     AMT-Thinkpad2						
************************************************************************

use naes_withcp.dta

***Using first imputed dataset only
mi unset
keep if mi_m == 1
keep dem* cp_score beh_vote ckey

************************************************************************
*   Creating dummy variables for 10 polarized demographic groups
************************************************************************

tabulate dem_guns, gen(c_gun)
tabulate dem_evangelical, gen(c_eva)
tabulate dem_urbanity, gen(c_urb)
tabulate dem_military, gen(c_mil)
tabulate dem_south, gen(c_sth)
tabulate dem_income, gen(c_inc)
tabulate dem_union, gen(c_uni)
tabulate dem_church, gen(c_chu)
tabulate dem_educ, gen(c_edu)

keep cp_score beh_vote ckey c_gun2 c_eva2 c_urb3 c_urb1 c_mil2 c_sth2 ///
	c_inc1 c_uni2 c_chu1 c_edu5

rename c_urb1 d_rur
rename c_gun2 d_gun
rename c_eva2 d_eva
rename c_mil2 d_mil
rename c_sth2 d_sth
rename c_urb3 d_urb
rename c_inc1 d_por
rename c_uni2 d_uni
rename c_chu1 d_non
rename c_edu5 d_edu

************************************************************************
*   Looping over all combinations of these groups to create indicator
*	variables as well as expectations for whether the groups are 
*	cross-pressured or not
************************************************************************

local var1 ///
	rur rur rur rur rur rur rur rur rur ///
	gun gun gun gun gun gun gun gun ///
	eva eva eva eva eva eva eva ///
	mil mil mil mil mil mil ///
	sth sth sth sth sth ///
	por por por por ///
	uni uni uni ///
	non non ///
	edu ///

local var2 ///
	gun eva mil sth por uni non edu urb ///
	eva mil sth por uni non edu urb ///
	mil sth por uni non edu urb ///
	sth por uni non edu urb ///
	por uni non edu urb ///
	uni non edu urb ///
	non edu urb ///
	edu urb ///
	urb

local var3 ///
	1 1 1 1 1 1 1 1 1 ///
	1 1 1 1 1 1 1 1 ///
	1 1 1 1 1 1 1 ///
	1 1 1 1 1 1 ///
	1 1 1 1 1 ///
	-1 -1 -1 -1 ///
	-1 -1 -1 ///
	-1 -1 ///
	-1 

local var4 ///
	1 1 1 1 -1 -1 -1 -1 -1 ///
	1 1 1 -1 -1 -1 -1 -1 ///
	1 1 -1 -1 -1 -1 -1 ///
	1 -1 -1 -1 -1 -1 ///
	-1 -1 -1 -1 -1 ///
	-1 -1 -1 -1 ///
	-1 -1 -1 ///
	-1 -1 ///
	-1


while "`var1'" ~= "" {

	gettoken v1 var1: var1
	gettoken v2 var2: var2
	gettoken v3 var3: var3
	gettoken v4 var4: var4

	gen i_`v1'_`v2' = d_`v1' * d_`v2'
	gen e_`v1'_`v2' = `v3' * `v4'

	}

keep cp_score beh_vote ckey i* e*

************************************************************************
*   Generating table contents
************************************************************************

*** Calculating CP score percentiles
sort cp_score
gen cp_pct = ((_n-1) / (_N-1)) * 100

*** Creating long dataset of scores x groups, trimming to group members,
*** then collapsing to expectations, median cp scores & percentiles, 
*** and counts, and dropping groups with < 2% of population
reshape long i_ e_, i(ckey) j(group) string
rename i_ val
drop if val ~= 1
rename e_ exp

collapse exp (median) cp_score (median) cp_pct (count) count=cp_score, by(group)
drop if count <= 1658


*** Prepping data for tabulation
gsort -cp_pct
replace cp_score = round(cp_score, 0.001)
replace cp_pct = round(cp_pct, 0.1)

************************************************************************
*   Saving and Closing								
************************************************************************

outsheet using naes_groups.csv, comma replace

log close


