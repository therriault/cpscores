clear
*log close _all

log using btt_naes_01_merge.log, replace

************************************************************************
*  Filename:	btt_naes_01_merge.do        				
*  Date:       	March 2, 2014						
*  Author:     	Andrew Therriault			               	
*  Purpose:    	Merges NAES 2004 cross-sectional and panel data, along	
*				with an original dataset of state-level controls, for
*				replication code
*  Data In:     naes_data.dta (merged file of 2004 NAES rolling 
*				cross-section (n=81,422) and general election panel
*				(n=8,664), trimmed to variables for this analysis
*				2004_state_controls.dta	(original data)				
*  Data Out:    naes_merged.dta	
*  Log File:    btt_naes_01_merge.log		                           
*  Status:		Final		                           		
*  Machine:     AMT-Thinkpad2
************************************************************************

use naes_data.dta

************************************************************************
*   	Merging in state-level controls				 	
************************************************************************

rename cst state

merge m:1 state using 2004_state_controls.dta, nogen

rename pres_logmargin control_margin
rename senate_dummy control_senate
rename gov_dummy control_governor

************************************************************************
*   	Closing & Saving						
************************************************************************

log close

save naes_merged.dta, replace
