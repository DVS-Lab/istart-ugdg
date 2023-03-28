#!/bin/bash

# This run_* script is a wrapper for L3stats.sh, so it will loop over several
# copes and models. Note that Contrast N for PPI is always PHYS in these models.


# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"


# Change the type of analysis in the " " marks.

for analysis in "nppi-ecn"; do # act ppi_seed-NAcc-bin nppi-dmn nppi-ecn 
	

# Define the contrast value and the name you would like in the output. 

analysistype=${analysis}
		for copeinfo in "1 Cue_dict" "2 Cue_ug-p" "3 Cue_ug-r" "4 dg_choice" "5 ug-p_choice" "6 ug-r_choice" "7 DG_endowment_pmod" "8 UG_P_endowment_pmod" "9 UG_R_endowment_pmod" "10 DGP cue_UGP Cue" "11 dg_choice_pmod_UGP pmod cue" "12 DGP_UGP" "13 dg_choice_pmod" "14 ugp_choice_pmod" "15 ugr_choice_pmod" "16 dg_dec_pmod_ugp" "17 phys"; do # "17 PHYS" "18 l_eye" "19 r_eye" "20 l_r_eye"; do
			

# split copeinfo variable
		set -- $copeinfo
		copenum=$1
		copename=$2

		NCORES=12
		SCRIPTNAME=${maindir}/code/L3stats.sh
		while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
			sleep 1s
		done
		bash $SCRIPTNAME $copenum $copename $analysistype &

	done
done
