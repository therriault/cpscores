clear
*log close _all

log using btt_naes_02_prep.log, replace

************************************************************************
*  Filename:	btt_naes_02_prep.do        				
*  Date:       	March 2, 2014						
*  Author:     	Andrew Therriault			               	
*  Purpose:    	Prepares NAES 2004 data	for replication			
*  Data In:     naes_merged.dta	       	  		
*  Data Out:    naes_prepped.dta				
*  Log File:    btt_naes_02_prep.log                                
*  Status:	Final		                           		
*  Machine:     AMT-Thinkpad2						
************************************************************************

use naes_merged.dta

************************************************************************
*   	Recoding idates and making splines
************************************************************************

tostring cdate, replace
gen idate = date(cdate,"YMD")
gen days = date("20041102","YMD") - idate
mkspline sdays1 15 sdays2 30 sdays3 60 sdays4 120 sdays5 = days

************************************************************************
*   	Recoding demographics - Preelection				
************************************************************************

gen dem_female = .
replace dem_female = 1 if cwa01 == 2
replace dem_female = 0 if cwa01 == 1

gen dem_age = .
replace dem_age = 5 if cwa02 <= 97
replace dem_age = 4 if cwa02 <= 64
replace dem_age = 3 if cwa02 <= 49
replace dem_age = 2 if cwa02 <= 39
replace dem_age = 1 if cwa02 <= 29

gen dem_educ = .
replace dem_educ = 5 if cwa03 <= 9
replace dem_educ = 4 if cwa03 <= 7
replace dem_educ = 3 if cwa03 <= 6
replace dem_educ = 2 if cwa03 <= 4
replace dem_educ = 1 if cwa03 <= 2

gen dem_unemployed = .
replace dem_unemployed = 0 if cwb01 <= 8
replace dem_unemployed = 1 if cwb01 == 3

gen dem_student = .
replace dem_student = 0 if cwb01 <= 8
replace dem_student = 1 if cwb01 == 7

gen dem_retired = .
replace dem_retired = 0 if cwb01 <= 8
replace dem_retired = 1 if cwb01 == 4

gen dem_selfemployed = .
replace dem_selfemployed = 0 if (cwb01 > 2 & cwb01 <= 8)
replace dem_selfemployed = 0 if cwb04 == 1
replace dem_selfemployed = 1 if cwb04 == 2

gen dem_govt = .
replace dem_govt = 0 if (cwb01 > 2 & cwb01 <= 8)
replace dem_govt = 0 if cwb04 == 2
replace dem_govt = 0 if cwb05 == 2
replace dem_govt = 1 if cwb05 == 1

gen dem_professional = .
replace dem_professional = 0 if (cwb01 > 2 & cwb01 <= 8)
replace dem_professional = 0 if cwb02 <= 10
replace dem_professional = 1 if cwb02 == 1
replace dem_professional = 1 if cwb02 == 9

gen dem_bluecollar = .
replace dem_bluecollar = 0 if (cwb01 > 2 & cwb01 <= 8)
replace dem_bluecollar = 0 if cwb02 <= 10
replace dem_bluecollar = 1 if cwb02 == 2
replace dem_bluecollar = 1 if cwb02 == 4
replace dem_bluecollar = 1 if cwb02 == 5
replace dem_bluecollar = 1 if cwb02 == 7

*** Adjusting income for household size (single households move up one category)
gen temp_income = cwa04 if cwa04 <= 9
replace temp_income = temp_income + 1 if cwf01 == 1

gen dem_income = .
replace dem_income = 5 if temp_income <= 10
replace dem_income = 4 if temp_income <= 7
replace dem_income = 3 if temp_income <= 6
replace dem_income = 2 if temp_income <= 5
replace dem_income = 1 if temp_income <= 3

gen dem_union = .
replace dem_union = 0 if cwb06 <= 4
replace dem_union = 1 if cwb06 <= 3

gen dem_hispanic = .
replace dem_hispanic = 0 if cwc01 == 2
replace dem_hispanic = 1 if cwc01 == 1

gen dem_white = .
replace dem_white = 0 if cwc03 <= 5
replace dem_white = 1 if cwc03 == 1

gen dem_black = .
replace dem_black = 0 if cwc03 <= 5
replace dem_black = 1 if cwc03 == 2

gen dem_asian = .
replace dem_asian = 0 if cwc03 <= 5
replace dem_asian = 1 if cwc03 == 3

gen dem_native = .
replace dem_native = 0 if cwc03 <= 5
replace dem_native = 1 if cwc03 == 4

gen dem_immigrant = .
replace dem_immigrant = 0 if cwc04 == 1
replace dem_immigrant = 1 if cwc04 == 2

gen dem_church = .
replace dem_church = (6 - cwd01) if cwd01 <= 5

gen dem_catholic = .
replace dem_catholic = 0 if ( cwd02 <= 7 | cwd03 <= 9 )
replace dem_catholic = 1 if ( cwd02 == 2 | cwd03 == 2 )

gen dem_jewish = .
replace dem_jewish = 0 if ( cwd02 <= 7 | cwd03 <= 9 )
replace dem_jewish = 1 if ( cwd02 == 3 | cwd03 == 3 )

gen dem_mormon = .
replace dem_mormon = 0 if ( cwd02 <= 7 | cwd03 <= 9 )
replace dem_mormon = 1 if ( cwd02 == 4 | cwd03 == 4 )

gen dem_muslim = .
replace dem_muslim = 0 if ( cwd02 <= 7 | cwd03 <= 9 )
replace dem_muslim = 1 if ( cwd02 == 6 | cwd03 == 6 )

gen dem_orthodox = .
replace dem_orthodox = 0 if ( cwd02 <= 7 | cwd03 <= 9 )
replace dem_orthodox = 1 if ( cwd02 == 5 | cwd03 == 5 )

gen dem_otherreligion = .
replace dem_otherreligion = 0 if ( cwd02 <= 7 | cwd03 <= 9 )
replace dem_otherreligion = 1 if ( cwd02 == 7 | cwd03 == 7 )
replace dem_otherreligion = 1 if cwd03 == 8

gen dem_atheist = .
replace dem_atheist = 0 if ( cwd02 <= 7 | cwd03 <= 9 )
replace dem_atheist = 1 if cwd03 == 9

gen dem_evangelical = .
replace dem_evangelical = 0 if cwd04 == .
replace dem_evangelical = 0 if cwd04 == 2
replace dem_evangelical = 1 if cwd04 == 1

gen dem_military = .
replace dem_military = 0 if cwe01 <= 4
replace dem_military = 1 if cwe01 <= 3

gen dem_urbanity = .
replace dem_urbanity = 1 if cwf13 <= 3
replace dem_urbanity = 2 if cwf13 <= 2
replace dem_urbanity = 3 if cwf13 == 1

gen dem_guns = .
replace dem_guns = 0 if ( cwg01 <= 2 | cwg02 <= 4 )
replace dem_guns = 1 if ( cwg01 == 1 | cwg02 <= 3 )

gen dem_gays = .
replace dem_gays = 0 if cwg05 <= 3
replace dem_gays = 1 if cwg05 == 1
replace dem_gays = 1 if cwg05 == 3

************************************************************************
*   	Recoding behavior variables	(using post-election values when 
*	available, pre-election otherwise)			
************************************************************************

gen beh_pid_party = .
replace beh_pid_party = 1 if cma01 == 1
replace beh_pid_party = 2 if cma01 == 2
replace beh_pid_party = 3 if ( cma01 == 3 | cma01 == 4 | cma01 == 998 )
replace beh_pid_party = . if rma01 ~= .
replace beh_pid_party = 1 if rma01 == 1
replace beh_pid_party = 2 if rma01 == 2
replace beh_pid_party = 3 if ( rma01 == 3 | rma01 == 4 | rma01 == 998 )

gen beh_pid_binary = .
replace beh_pid_binary = 0 if beh_pid_party == 3
replace beh_pid_binary = 1 if beh_pid_party == 2
replace beh_pid_binary = 1 if beh_pid_party == 1

gen beh_pid_twoparty = .
replace beh_pid_twoparty = 1 if beh_pid_party == 2
replace beh_pid_twoparty = 0 if beh_pid_party == 1

gen beh_pid_strength = .
replace beh_pid_strength = 0 if cma02 == 998 & beh_pid_binary == 1
replace beh_pid_strength = 0 if cma02 == 2 & beh_pid_binary == 1
replace beh_pid_strength = 1 if cma02 == 1 & beh_pid_binary == 1
replace beh_pid_strength = . if rma02 == 999 & beh_pid_binary == 1
replace beh_pid_strength = 0 if rma02 == 998 & beh_pid_binary == 1
replace beh_pid_strength = 0 if rma02 == 2 & beh_pid_binary == 1
replace beh_pid_strength = 1 if rma02 == 1 & beh_pid_binary == 1

*** Coding self-reported vote (post-election) / early vote
gen beh_vc_gep = .
replace beh_vc_gep = 1 if ( rrc29 == 2 | rrc30 == 2 )
replace beh_vc_gep = 0 if ( rrc29 == 1 | rrc30 == 1 )

gen beh_vc_ncs = .
replace beh_vc_ncs = 1 if ( crc29 == 2 | crc30 == 2 )
replace beh_vc_ncs = 0 if ( crc29 == 1 | crc30 == 1 )

*** Coding vote intention
gen beh_vi = .
replace beh_vi = 1 if (crc03 == 2 | crc07 == 2 | crc10 == 2 | crc11 == 2 | ///
crc12 == 2 | crc13 == 2 | crc14 == 2)
replace beh_vi = 0 if (crc03 == 1 | crc07 == 1 | crc10 == 1 | crc11 == 1 | ///
crc12 == 1 | crc13 == 1 | crc14 == 1)

*** Using actual vote if available, intention otherwise
gen beh_vote = beh_vi
replace beh_vote = beh_vc_ncs if beh_vc_ncs ~= .
replace beh_vote = beh_vc_gep if beh_vc_gep ~= .

*** Coding turnout in postelection survey only
gen beh_turnout = .
replace beh_turnout = 0 if rrc28 == 2
replace beh_turnout = 1 if rrc28 == 1

gen beh_interest = .
replace beh_interest = (5 - cka01) if cka01 <= 4
replace beh_interest = . if rka01 ~= .
replace beh_interest = (5 - rka01) if rka01 <= 4

gen beh_follow = .
replace beh_follow = (5 - cka04) if cka04 <= 4
replace beh_follow = . if rka04 ~= .
replace beh_follow = (5 - rka04) if rka04 <= 4

gen beh_discuss = .
replace beh_discuss = 4 if ckb01 <= 7
replace beh_discuss = 3 if ckb01 <= 6
replace beh_discuss = 2 if ckb01 <= 2
replace beh_discuss = 1 if ckb01 == 0
replace beh_discuss = . if rkb01 ~= .
replace beh_discuss = 4 if rkb01 <= 7
replace beh_discuss = 3 if rkb01 <= 6
replace beh_discuss = 2 if rkb01 <= 2
replace beh_discuss = 1 if rkb01 == 0

gen beh_influence = .
replace beh_influence = 0 if ckc02 == 2
replace beh_influence = 1 if ckc02 == 1
replace beh_influence = 1 if rkc02 == 1	

gen beh_donate = .
replace beh_donate = 0 if ckc05 == 2
replace beh_donate = 1 if ckc05 == 1
replace beh_donate = 1 if rkc05 == 1


************************************************************************
*   	Recoding attitudinal variables	- pre-election				
************************************************************************

gen att_econ = .
replace att_econ = -1 if ccb10 == 1
replace att_econ = 0 if ccb10 == 3 | ccb10 == 998
replace att_econ = 1 if ccb10 == 2

gen att_tax1 = .
replace att_tax1 = -1 if ccb16 == 1
replace att_tax1 = -1 if ccb17 == 1 | ccb17 == 2
replace att_tax1 = 0 if ccb16 == 998
replace att_tax1 = 0 if ccb17 == 5 | ccb17 == 998
replace att_tax1 = 1 if ccb16 == 2
replace att_tax1 = 1 if ccb17 == 3 | ccb17 == 4

gen att_tax2 = .
replace att_tax2 = -1 if ccb33 == 1
replace att_tax2 = -1 if ccb34 == 1 | ccb34 == 2
replace att_tax2 = -1 if ccb35 == 1 | ccb35 == 2
replace att_tax2 = 0 if ccb33 == 998
replace att_tax2 = 0 if ccb34 == 5 | ccb34 == 998
replace att_tax2 = 0 if ccb35 == 5 | ccb35 == 998
replace att_tax2 = 1 if ccb33 == 2
replace att_tax2 = 1 if ccb34 == 3 | ccb34 == 4
replace att_tax2 = 1 if ccb35 == 3 | ccb35 == 4

gen att_wage = .
replace att_wage = -1 if ccb65 == 3 | ccb65 == 4
replace att_wage = 0 if ccb65 == 5 | ccb65 == 998
replace att_wage = 1 if ccb65 == 1 | ccb65 == 2

gen att_union = .
replace att_union = -1 if ccb71 == 2
replace att_union = -1 if ccb72 == 3 | ccb72 == 4
replace att_union = 0 if ccb71 == 3 | ccb71 == 998
replace att_union = 0 if ccb72 == 5 | ccb72 == 998
replace att_union = 1 if ccb71 == 1
replace att_union = 1 if ccb72 == 1 | ccb72 == 2

gen att_hc1 = .
replace att_hc1 = -1 if ccc03 == 2
replace att_hc1 = -1 if ccc04 == 3 | ccc04 == 4
replace att_hc1 = 0 if ccc03 == 3 | ccc03 == 998
replace att_hc1 = 0 if ccc04 == 5 | ccc04 == 998
replace att_hc1 = 1 if ccc03 == 1
replace att_hc1 = 1 if ccc04 == 1 | ccc04 == 2

gen att_hc2 = .
replace att_hc2 = -1 if ccc05 == 2
replace att_hc2 = -1 if ccc06 == 3 | ccc06 == 4
replace att_hc2 = 0 if ccc05 == 3 | ccc05 == 998
replace att_hc2 = 0 if ccc06 == 5 | ccc06 == 998
replace att_hc2 = 1 if ccc05 == 1
replace att_hc2 = 1 if ccc06 == 1 | ccc06 == 2

gen att_ss = .
replace att_ss = -1 if ccc33 == 1
replace att_ss = -1 if ccc32 == 1 | ccc32 == 2
replace att_ss = 0 if ccc33 == 998
replace att_ss = 0 if ccc32 == 5 | ccc32 == 998
replace att_ss = 1 if ccc33 == 2
replace att_ss = 1 if ccc32 == 3 | ccc32 == 4

gen att_edu1 = .
replace att_edu1 = -1 if ccc39 == 1 | ccc39 == 2
replace att_edu1 = 0 if ccc39 == 5 | ccc39 == 998
replace att_edu1 = 1 if ccc39 == 3 | ccc39 == 4

gen att_edu2 = .
replace att_edu2 = -1 if ccc40 == 3 | ccc40 == 4
replace att_edu2 = 0 if ccc40 == 2 | ccc40 == 998
replace att_edu2 = 1 if ccc40 == 1

gen att_mil = .
replace att_mil = -1 if ccd03 == 1
replace att_mil = 0 if ccd03 == 2 | ccd03 == 998
replace att_mil = 1 if ccd03 == 3 | ccd03 == 4

gen att_iraq1 = .
replace att_iraq1 = -1 if ccd19 == 1
replace att_iraq1 = 0 if ccd19 == 3 | ccd19 == 998
replace att_iraq1 = 1 if ccd19 == 2

gen att_iraq2 = .
replace att_iraq2 = -1 if ccd35 == 1
replace att_iraq2 = 0 if ccd35 == 3 | ccd35 == 998
replace att_iraq2 = 1 if ccd35 == 2

gen att_home = .
replace att_home = -1 if ccd57 == 1
replace att_home = 0 if ccd57 == 2 | ccd57 == 998
replace att_home = 1 if ccd57 == 3 | ccd57 == 4

gen att_pat = .
replace att_pat = -1 if ccd67 == 1
replace att_pat = 0 if ccd67 == 3 | ccd67 == 998
replace att_pat = 1 if ccd67 == 2

gen att_abor1 = .
replace att_abor1 = -1 if cce01 == 1 | cce01 == 2
replace att_abor1 = 0 if cce01 == 5 | cce01 == 998
replace att_abor1 = 1 if cce01 == 3 | cce01 == 4

gen att_abor2 = .
replace att_abor2 = -1 if cce02 == 1 | cce02 == 2
replace att_abor2 = 0 if cce02 == 5 | cce02 == 998
replace att_abor2 = 1 if cce02 == 3 | cce02 == 4

gen att_stem1 = .
replace att_stem1 = -1 if cce07 == 2
replace att_stem1 = -1 if cce08 == 2
replace att_stem1 = -1 if cce09 == 3 | cce09 == 4
replace att_stem1 = 0 if cce07 == 998
replace att_stem1 = 0 if cce08 == 998
replace att_stem1 = 0 if cce09 == 5 | cce09 == 998
replace att_stem1 = 1 if cce07 == 1
replace att_stem1 = 1 if cce08 == 1
replace att_stem1 = 1 if cce09 == 1 | cce09 == 2

gen att_stem2 = .
replace att_stem2 = -1 if cce14 == 3 | cce14 == 4
replace att_stem2 = 0 if cce14 == 5 | cce14 == 998
replace att_stem2 = 1 if cce14 == 1 | cce14 == 2

gen att_gun1 = .
replace att_gun1 = -1 if cce31 == 3 | cce31 == 4
replace att_gun1 = 0 if cce31 == 2 | cce31 == 998
replace att_gun1 = 1 if cce31 == 1

gen att_gun2 = .
replace att_gun2 = -1 if cce32 == 2
replace att_gun2 = -1 if cce33 == 2
replace att_gun2 = -1 if cce34 == 3 | cce34 == 4
replace att_gun2 = 0 if cce32 == 998
replace att_gun2 = 0 if cce33 == 998
replace att_gun2 = 0 if cce34 == 5 | cce34 == 998
replace att_gun2 = 1 if cce32 == 1
replace att_gun2 = 1 if cce33 == 1
replace att_gun2 = 1 if cce34 == 1 | cce34 == 2

gen att_tort1 = .
replace att_tort1 = -1 if ccg01 == 1
replace att_tort1 = -1 if ccg02 == 1 | ccg02 == 2
replace att_tort1 = 0 if ccg01 == 998
replace att_tort1 = 0 if ccg02 == 5 | ccg02 == 998
replace att_tort1 = 1 if ccg01 == 2
replace att_tort1 = 1 if ccg02 == 3 | ccg02 == 4

gen att_tort2 = .	
replace att_tort2 = -1 if ccg07 == 1 | ccg07 == 2
replace att_tort2 = 0 if ccg07 == 5 | ccg07 == 998
replace att_tort2 = 1 if ccg07 == 3 | ccg07 == 4

************************************************************************
*   	Recoding therms & knowledge variables (pre-election)		
************************************************************************

gen therm_bush = .
replace therm_bush = caa01 if caa01 ~= . & caa01 <= 10

gen therm_kerry = .
replace therm_kerry = cab01 if cab01 ~= . & cab01 <= 10

gen therm_diff = abs(therm_bush - therm_kerry)
gen therm_max = max(therm_bush, therm_kerry)

gen know_bush = .
replace know_bush = 1 if caa01 ~= . & caa01 <= 10
replace know_bush = 0 if caa01 == 11 | caa01 == 12

gen know_kerry = .
replace know_kerry = 1 if cab01 ~= . & cab01 <= 10
replace know_kerry = 0 if cab01 == 11 | cab01 == 12

gen know_cheney = .
replace know_cheney = 1 if cac01 ~= . & cac01 <= 10
replace know_cheney = 0 if cac01 == 11 | cac01 == 12

gen know_edwards = .
replace know_edwards = 1 if cac04 ~= . & cac04 <= 10
replace know_edwards = 0 if cac04 == 11 | cac04 == 12

gen place_bush = .
replace place_bush = 0 if caa30 == 4 | caa30 == 5 ///
	| caa30 == 998 | caa30 == 999
replace place_bush = 1 if caa30 == 1 | caa30 == 2 | caa30 == 3

gen place_kerry = .
replace place_kerry = 0 if cab27 == 1 | cab27 == 2 ///
	| cab27 == 998 | cab27 == 999
replace place_kerry = 1 if cab27 == 5 | cab27 == 4 | cab27 == 3

***Generating knowledege scales
egen know_scale = rsum(know*)
egen place_scale = rsum(place*)
replace know_scale = know_scale + place_scale
replace know_scale = . if know_bush == . | know_kerry == . ///
	| know_cheney == . | know_edwards == .

sum therm* know* place*

tab1 know_scale, missing

************************************************************************
*   	Recoding control variables 
*
*	(Controls are later imputed for use as IVs, and are kept
*	distinct from non-imputed versions which are used as DVs)	
************************************************************************

gen control_therm_bush = therm_bush
gen control_therm_kerry = therm_kerry
gen control_know_scale = know_scale

gen control_pid_party = beh_pid_party

gen control_ideology = .
replace control_ideology = (6 - cma06) if cma06 <= 5

gen control_interest = .
replace control_interest = beh_interest

gen control_pid_strength = beh_pid_strength

gen dem_northeast = 0
replace dem_northeast = 1 if ///
	state == "ME" | ///
	state == "NH" | ///
	state == "VT" | ///
	state == "MA" | ///
	state == "RI" | ///
	state == "CT" | ///
	state == "NY" | ///
	state == "NJ" | ///
	state == "DE" | ///
	state == "MD" | ///
	state == "DC" | ///
	state == "PA"

gen dem_south = 0
replace dem_south = 1 if ///
	state == "AL" | ///
	state == "AR" | ///
	state == "FL" | ///
	state == "GA" | ///
	state == "KY" | ///
	state == "LA" | ///
	state == "MO" | ///
	state == "MS" | ///
	state == "NC" | ///
	state == "SC" | ///
	state == "TN" | ///
	state == "VA" | ///
	state == "WV" 

gen dem_west = 0
replace dem_west = 1 if ///
	state == "AZ" | ///
	state == "CA" | ///
	state == "NV" | ///
	state == "OR" | ///
	state == "WA"

gen dem_central = 0
replace dem_central = 1 if ///
	state == "ND" | ///
	state == "SD" | ///
	state == "NE" | ///
	state == "KS" | ///
	state == "OK" | ///
	state == "ID" | ///
	state == "CO" | ///
	state == "WY" | ///
	state == "NM" | ///
	state == "MT" | ///
	state == "TX" | ///
	state == "UT"


************************************************************************
*   	Cropping dataset to only coded variables and labeling		
************************************************************************

keep ckey cdate dem* beh* control* know* place* att* therm* sdays*

label variable dem_female "Female"
label variable dem_age "Age"
label variable dem_educ "Education"
label variable dem_unemployed "Unemployed"
label variable dem_student "Student"
label variable dem_retired "Retired"
label variable dem_selfemployed "Self-employed"
label variable dem_govt "Government employee"
label variable dem_professional "Professional Job"
label variable dem_bluecollar "Blue-collar Job"
label variable dem_income "Income"
label variable dem_union "Union household"
label variable dem_hispanic "Hispanic"
label variable dem_white "White"
label variable dem_black "Black"
label variable dem_asian "Asian"
label variable dem_native "Native American"
label variable dem_immigrant "Foreign-born"
label variable dem_church "Religious Attendance"
label variable dem_catholic "Catholic"
label variable dem_jewish "Jewish"
label variable dem_mormon "Mormon"
label variable dem_muslim "Muslim"
label variable dem_orthodox "Orthodox"
label variable dem_otherreligion "Other religion"
label variable dem_atheist "Atheist / Agnostic"
label variable dem_evangelical "Evangelical"
label variable dem_military "Military household"
label variable dem_urbanity "Urbanity"
label variable dem_guns "Gun-owning household"
label variable dem_gays "Gay Friend, Colleague, or Family member"
label variable control_ideology "Ideological Self-Placement"
label variable control_interest "Political Interest (Control)"
label variable beh_vote "Vote Choice / Intention"
label variable beh_vi "Vote Intention"
label variable beh_vc_ncs "Vote Choice (from Cross-Section)"
label variable beh_vc_gep "Vote choice (from GE Panel)"
label variable beh_turnout "Voter turnout"
label variable beh_discuss "# of days Discussed Politics in Last Week"
label variable beh_pid_binary "Partisanship Binary"
label variable beh_pid_party "Party Affiliation"
label variable beh_pid_twoparty "Party Affiliation (two-party)"
label variable beh_pid_strength "Strong Partisan Binary"
label variable beh_influence "Whether R tried to influence others"
label variable beh_interest "Political Interest"
label variable beh_donate "Whether R donated to candidate"
label variable beh_follow "How closely R follows politics"
label variable dem_northeast "Northeastern State Dummy"
label variable dem_south "Southern State Dummy"
label variable dem_west "Western State Dummy"
label variable dem_central "Central/Mountain State Dummy"
label variable control_margin "Logged Pres Vote Margin"
label variable control_senate "Senate Race Dummy"
label variable control_governor "Governor Race Dummy"

sum

************************************************************************
*   	Hotdecking lightly-missing data for missing values		
*									
*	(Imputing non-continuous variables requires complete data on 	
*	RHS, so I'm hotdecking demographics with <2% missing, then	
*	using this "full" data to predict more seriously-missing 	
*	variables via MI. Hotdecking done by gender, region, and 	
*	urbanity strata.)						
*									
************************************************************************

gen temp_region = 0
replace temp_region = 1 if dem_northeast == 1
replace temp_region = 2 if dem_south == 1
replace temp_region = 3 if dem_central == 1
replace temp_region = 4 if dem_west == 1

bysort dem_female dem_urbanity temp_region:  ///
	hotdeckvar dem_age dem_educ dem_unemployed dem_student dem_retired  ///
	dem_selfemployed dem_govt dem_professional dem_bluecollar  ///
	dem_union dem_hispanic dem_white dem_black dem_asian dem_native /// 
	dem_immigrant dem_church dem_military

drop temp_region

local vars dem_age dem_educ dem_unemployed dem_student dem_retired ///
	dem_selfemployed dem_govt dem_professional dem_bluecollar  ///
	dem_union dem_hispanic dem_white dem_black dem_asian ///
	dem_native dem_immigrant dem_church dem_military

while "`vars'" ~="" {
		
	gettoken v vars : vars

	drop `v'
	rename `v'_i `v'

	}

************************************************************************
*   	Generating missing data via MI					
************************************************************************

mi set flong

mi register imputed dem_income dem_catholic dem_jewish dem_mormon  ///
	dem_muslim dem_orthodox dem_otherreligion dem_atheist  ///
	dem_evangelical dem_guns dem_gays control_pid_party  ///
	control_ideology control_interest control_pid_strength ///
	att_econ att_tax1 att_tax2 att_wage att_union att_hc1 att_hc2 ///
	att_ss att_edu1 att_edu2 att_mil att_iraq1 att_iraq2 att_home ///
	att_pat att_abor1 att_abor2 att_stem1 att_stem2 att_gun1 att_gun2 ///
	att_tort1 att_tort2 ///
	control_therm_bush control_therm_kerry control_know_scale

*** Imputing income categories via multinomial logit
mi impute mlogit dem_income dem_female i.dem_urbanity dem_northeast  ///
	dem_south dem_west dem_central i.dem_age i.dem_educ dem_unemployed  ///
	dem_student dem_retired dem_selfemployed dem_govt dem_professional  ///
	dem_bluecollar dem_union dem_hispanic dem_white dem_black  ///
	dem_asian dem_native dem_immigrant i.dem_church dem_military sdays*,  ///
	add(5) rseed(0929) dots noisily
	
*** Imputing binary variables bia logit

local vars dem_catholic dem_jewish dem_mormon ///
	dem_muslim dem_orthodox dem_otherreligion dem_atheist ///
	dem_evangelical dem_guns dem_gays control_pid_strength

while "`vars'" ~= "" {

	gettoken v vars : vars

	mi impute logit `v' dem_female i.dem_urbanity dem_northeast ///
	dem_south dem_west dem_central i.dem_age i.dem_educ dem_unemployed  ///
	dem_student dem_retired dem_selfemployed dem_govt dem_professional  ///
	dem_bluecollar dem_union dem_hispanic dem_white dem_black  ///
	dem_asian dem_native dem_immigrant i.dem_church dem_military sdays*,  ///
	replace rseed(0929) dots noisily

	}
	
*** Imputing scales via ologit

local vars control_interest control_therm_bush control_therm_kerry ///
	control_know_scale att_econ att_tax1 att_tax2 att_wage att_union ///
	att_hc1 att_hc2 att_ss att_edu1 att_edu2 att_mil att_iraq1 ///
	att_iraq2 att_home att_pat att_abor1 att_abor2 att_stem1 ///
	att_stem2 att_gun1 att_gun2 att_tort1 att_tort2

while "`vars'" ~= "" {

	gettoken v vars : vars

	mi impute ologit `v' dem_female i.dem_urbanity dem_northeast ///
	dem_south dem_west dem_central i.dem_age i.dem_educ dem_unemployed  ///
	dem_student dem_retired dem_selfemployed dem_govt dem_professional  ///
	dem_bluecollar dem_union dem_hispanic dem_white dem_black  ///
	dem_asian dem_native dem_immigrant i.dem_church dem_military sdays*,  ///
	replace rseed(0929) dots noisily

	}

*** Imputing pid and ideology via mlogit	
	
local vars control_pid_party control_ideology

while "`vars'" ~= "" {

	gettoken v vars : vars

	mi impute mlogit `v' dem_female i.dem_urbanity dem_northeast ///
	dem_south dem_west dem_central i.dem_age i.dem_educ dem_unemployed  ///
	dem_student dem_retired dem_selfemployed dem_govt dem_professional  ///
	dem_bluecollar dem_union dem_hispanic dem_white dem_black  ///
	dem_asian dem_native dem_immigrant i.dem_church dem_military sdays*,  ///
	replace rseed(0929) dots noisily

	}

************************************************************************
*   	Generating summary measures of policy attitudes
************************************************************************

mi passive: gen att_con_vote = .
mi passive: gen att_con_all = .

mi passive: gen att_dem = 0
mi passive: gen att_rep = 0

*** Looping over attitudes and counting agreement with Dems and Reps

local vars att_econ att_tax1 att_tax2 att_wage att_union ///
	att_hc1 att_hc2 att_ss att_edu1 att_edu2 att_mil att_iraq1 ///
	att_iraq2 att_home att_pat att_abor1 att_abor2 att_stem1 ///
	att_stem2 att_gun1 att_gun2 att_tort1 att_tort2

while "`vars'" ~= "" {

	gettoken v vars : vars

	mi passive: replace att_dem = att_dem + 1 if `v' == 1
	mi passive: replace att_rep = att_rep + 1 if `v' == -1

	}

*** Coding attitudinal consistency with PID

mi passive: replace att_con_vote = (att_dem - att_rep) /// 
	/ (att_dem + att_rep) if beh_pid_twoparty == 1
mi passive: replace att_con_vote = (att_rep - att_dem) ///
	/ (att_dem + att_rep) if beh_pid_twoparty == 0

*** Coding internal consistency of policy attitudes
	
mi passive: replace att_con_all = abs((att_dem - att_rep) /// 
	/ (att_dem + att_rep))	


************************************************************************
*   	Generating and labeling imputed control variables		
************************************************************************

mi passive: gen control_democrat = .
mi passive: replace control_democrat = 0 if control_pid_party <= 3
mi passive: replace control_democrat = 1 if control_pid_party == 2

mi passive: gen control_republican = .
mi passive: replace control_republican = 0 if control_pid_party <= 3
mi passive: replace control_republican = 1 if control_pid_party == 1

mi passive: gen control_pid_binary = .
mi passive: replace control_pid_binary = 0 if control_pid_party == 3
mi passive: replace control_pid_binary = 1 if control_pid_party == 2
mi passive: replace control_pid_binary = 1 if control_pid_party == 1

mi passive: gen control_pid_strength_3pt = .
mi passive: replace control_pid_strength_3pt = 0 if ///
	control_pid_binary == 0
mi passive: replace control_pid_strength_3pt = 1 if ///
	control_pid_binary == 1
mi passive: replace control_pid_strength_3pt = 2 if ///
	control_pid_binary == 1 & control_pid_strength == 1


label variable control_democrat "Democrat Dummy"
label variable control_republican "Republican Dummy"
label variable control_pid_party "Party Affiliation"
label variable control_pid_binary "Partisanship binary"
label variable control_pid_strength "Strong Partisan Binary"
label variable control_pid_strength_3pt "3pt Partisan Strength"

************************************************************************
*   	Setting base categories						
************************************************************************

mi fvset base 3 dem_income control_ideology dem_age dem_educ ///
	dem_church beh_follow beh_interest beh_discuss control_interest ///
	beh_pid_party control_pid_party 

mi fvset base 2 dem_urbanity

mi fvset base 0 control_pid_strength_3pt

************************************************************************
*   	Closing & Saving						
************************************************************************

keep ckey cdate control* sdays* dem* beh* att* know* _mi* therm*

mi describe
summ if _mi_m == 0
summ if _mi_m ~= 0

save naes_prepped.dta, replace

log close
