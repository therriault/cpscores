clear
log close _all

log using btt_pnes_01_prep.log, replace


************************************************************************
*  File-Name:	btt_pnes_01_prep.do        				
*  Date:       	March 2, 2014						
*  Author:     	Andrew Therriault			               	
*  Purpose:    	Prepares PNES 2001 data	for replication			
*  Data In:     pnes_data.dta (2001 PNES survey, trimmed to relevant
*				variables for this analysis only)
*  Data Out:    pnes_prepped.dta					
*  Log File:    btt_pnes_01_prep.log				
*  Status:		Final		                           		
*  Machine:     AMT-Thinkpad2						
************************************************************************

use pnes_data.dta, clear

************************************************************************
*   	Recoding demographics						
************************************************************************

gen dem_female = .
replace dem_female = 0 if sex__310 ~= .
replace dem_female = 1 if sex__310 == 2

gen dem_age = .
replace dem_age = (2001 - yrbir309) if yrbir309 <= 2001

gen dem_educ = .
replace dem_educ = educ_311 if educ_311 <= 11

gen dem_unemployed = .
replace dem_unemployed = 0 if empl1314 ~= .
replace dem_unemployed = 1 if empl1314 == 5

gen dem_student = .
replace dem_student = 0 if empl1314 ~= .
replace dem_student = 1 if empl1314 == 6

gen dem_retired = .
replace dem_retired = 0 if empl1314 ~= .
replace dem_retired = 1 if empl1314 == 7

gen dem_govt = 0
replace dem_govt = 1 if insow317 <= 3

gen dem_selfemployed = 0
replace dem_selfemployed = 1 if owner318 == 1

gen dem_manager = 0
replace dem_manager = 1 if supvs326 == 1

gen dem_income = .
replace dem_income = (hhinc343/12000) if hhinc343 <= 60000

gen dem_union = .
replace dem_union = 0 if tum01357 ~= .
replace dem_union = 1 if tum01357 <= 3

gen dem_church = .
replace dem_church = chrat365 if chrat365 <= 8

gen dem_urbanity = .
replace dem_urbanity = resid350 if resid350 <= 6

************************************************************************
*   Recoding behaviors				
************************************************************************

gen beh_pid_binary = 0
replace beh_pid_binary = 1 if repar037 == 1
replace beh_pid_binary = 1 if parid041 == 1
replace beh_pid_binary = 1 if pidcl049 == 1

gen beh_pid_strength = .
replace beh_pid_strength = 1 if pidst051 == 1 & beh_pid_binary == 1
replace beh_pid_strength = 1 if pidst051 == 2 & beh_pid_binary == 1
replace beh_pid_strength = 0 if pidst051 == 3 & beh_pid_binary == 1
replace beh_pid_strength = 0 if pidst051 == 7 & beh_pid_binary == 1

gen beh_vc = .
replace beh_vc = vt01_018 if vt01_018 <= 15

gen beh_turnout = .
replace beh_turnout = 0 if pt01_017 == 2
replace beh_turnout = 1 if pt01_017 == 1

gen beh_interest = .
replace beh_interest = 5 if intpo011 == 1
replace beh_interest = 4 if intpo011 == 2
replace beh_interest = 3 if intpo011 == 3
replace beh_interest = 2 if intpo011 == 4
replace beh_interest = 1 if intpo011 == 5

************************************************************************
*   Generating "control" versions of behaviors (which allow for MI,	
*	but don't want imputed values when used as DV)			
************************************************************************

gen control_pid_strength = (beh_pid_strength + 1)
replace control_pid_strength = 0 if beh_pid_strength == .

gen control_interest = beh_interest

gen control_ideology = .
replace control_ideology = 7 if lrslf073 <= 10
replace control_ideology = 6 if lrslf073 <= 9
replace control_ideology = 5 if lrslf073 <= 7
replace control_ideology = 4 if lrslf073 <= 5
replace control_ideology = 3 if lrslf073 <= 4
replace control_ideology = 2 if lrslf073 <= 2
replace control_ideology = 1 if lrslf073 == 0

************************************************************************
*  	Cropping data to relevant variables, labelling, and setting 	
*	base values							
************************************************************************

keep beh* dem* control*

label variable dem_female "DEM: Female"
label variable dem_age "DEM: Age group"
label variable dem_educ "DEM: Education"
label variable dem_unemployed "DEM: Unemployed"
label variable dem_student "DEM: Student"
label variable dem_retired "DEM: Retired"
label variable dem_govt "DEM: Government employee"
label variable dem_selfemployed "DEM: Self-employed"
label variable dem_manager "DEM: Manager"
label variable dem_income "DEM: Monthly income"
label variable dem_union "DEM: Union Member"
label variable dem_church "DEM: Church Attendance"
label variable dem_urban "DEM: Urbanity"
label variable beh_pid_binary "BEHAVIOR: PID binary"
label variable beh_pid_strength "BEHAVIOR: Strong partisan (binary)"
label variable control_pid_strength "CONTROL: PID strength (3-pt)"
label variable beh_turnout "BEHAVIOR: Turnout"
label variable beh_vc "BEHAVIOR: Vote Choice"
label variable beh_interest "BEHAVIOR: Interest in Politics"
label variable control_interest "CONTROL: Interest in Politics"
label variable control_ideology "CONTROL: Ideological Self-placement"

fvset base 1 dem_age
fvset base 2 dem_educ dem_income dem_church
fvset base 4 control_ideology
fvset base 0 control_pid_strength
fvset base 2 dem_urbanity
fvset base 2 beh_interest control_interest

************************************************************************
*   	Generating squared vars				
************************************************************************

gen dem_age2 = dem_age ^ 2
gen dem_educ2 = dem_educ ^ 2
gen dem_urbanity2 = dem_urbanity ^ 2

label variable dem_age2 "DEM: Age Squared"
label variable dem_educ2 "DEM: Education Squared"
label variable dem_urbanity2 "DEM: Urbanity Squared"

************************************************************************
*   	Generating missing data via MI					
************************************************************************

mi set flong

mi register imputed dem_income dem_church control_interest ///
	control_ideology control_pid_strength
	
mi impute regress dem_income dem_female dem_age dem_age2 dem_educ  ///
	dem_educ2 dem_unemployed dem_student dem_retired dem_govt  ///
	dem_selfemployed dem_manager dem_union dem_urbanity dem_urbanity2 ///
	, add(50) rseed(0929) dots noisily
	
mi impute ologit dem_church dem_female dem_age dem_age2 dem_educ  ///
	dem_educ2 dem_unemployed dem_student dem_retired dem_govt  ///
	dem_selfemployed dem_manager dem_union dem_urbanity dem_urbanity2 ///
	, replace rseed(0929) dots noisily
	
mi impute ologit control_interest dem_female dem_age dem_age2 dem_educ  ///
	dem_educ2 dem_unemployed dem_student dem_retired dem_govt  ///
	dem_selfemployed dem_manager dem_union dem_urbanity dem_urbanity2 ///
	, replace rseed(0929) dots noisily
	
mi impute mlogit control_ideology dem_female dem_age dem_age2 dem_educ  ///
	dem_educ2 dem_unemployed dem_student dem_retired dem_govt  ///
	dem_selfemployed dem_manager dem_union dem_urbanity dem_urbanity2 ///
	, replace rseed(0929) dots noisily
	
mi impute ologit control_pid_strength dem_female dem_age dem_age2 dem_educ  ///
	dem_educ2 dem_unemployed dem_student dem_retired dem_govt  ///
	dem_selfemployed dem_manager dem_union dem_urbanity dem_urbanity2 ///
	, replace rseed(0929) dots noisily

mi passive: gen dem_income2 = dem_income ^ 2
mi passive: gen dem_church2 = dem_church ^ 2

label variable dem_income2 "DEM: Monthly income Squared"
label variable dem_church2 "DEM: Church Attendance Squared"

************************************************************************
*   	Closing & Saving						
************************************************************************

sum

mi describe

save pnes_prepped.dta, replace

log close
