log using btt_naes_00_batch_short.log, name(short) replace
log using btt_naes_00_batch_long.log, name(long) replace

local files ///
	btt_naes_01_merge.do ///
	btt_naes_02_prep.do ///
	btt_naes_03_cpscores.do ///
	btt_naes_04_figures.do ///
	btt_naes_05_regressions.do ///
	btt_naes_06_table.do
	
while "`files'" ~="" {
		
	gettoken f files : files

	di "Starting `f' at `c(current_time)' `c(current_date)'"

	qui log off short
	do `f'
	qui log on short

	clear

	}

log close short
log close long

