clear
log close _all

log using btt_pnes_03_comparisons.log, replace

************************************************************************
*  File-Name:	btt_pnes_03_comparisons.do        			
*  Date:       	March 2, 2014						
*  Author:     	Andrew Therriault			               	
*  Purpose:    	Compares methods of calculating variance in creating CP	
*				scores, for replication					
*  Data In:     pnes_withcp.dta		     	  		
*  Data Out:    None							
*  Log File:    btt_pnes_03_comparisons.log				
*  Status:		Final		                           		
*  Machine:     AMT-Thinkpad2					
************************************************************************

use pnes_withcp.dta

************************************************************************
*   Computing correlations for first diffs, top-3, and full variance
*  	CP scores 							
************************************************************************

corr cp_fd cp_top cp_full if (_mi_m ~= 0)


************************************************************************
*   Closing 							
************************************************************************

log close


