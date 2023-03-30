#!/bin/bash

# This run_* script is a wrapper for L3stats.sh, so it will loop over several
# copes and models. Note that Contrast N for PPI is always PHYS in these models.


# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"


# Change the type of analysis in the " " marks.

for analysis in "act"; do # act ppi_seed-NAcc-bin nppi-dmn nppi-ecn 
	

# Define the contrast value and the name you would like in the output. 

analysistype=${analysis}
		for copeinfo in "1 cue_DGP" "2 cue_UGP" "3 cue_UGR" "4 choice_DGP" "5 choice_UGP" "6 choice_UGR" "7 cue_DGP_pmod" "8 cue_UGP_pmod" "9 cue_UGR_pmod" "10 choice_DGP_pmod" "11 choice_UGP_pmod" "12 choice_UGR_pmod" "13 cue_DGUG" "14 choice_DGUG" "15 cue_DGUG_pmod" "16 choice_DGUG_pmod"; do # "17 PHYS" "18 l_eye" "19 r_eye" "20 l_r_eye"; do
			

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
