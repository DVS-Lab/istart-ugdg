#!/usr/bin/env bash

# this script will convert your BIDS *events.tsv files into the 3-col format for FSL
# it relies on Tom Nichols' converter, which we store locally under /data/tools
# https://github.com/bids-standard/bidsutils

# note: has to be run from Smith Lab Linux box

# To do:
# 1) add parametric modulators?
# 2) log missing inputs?
# 3) zero padding for run number. fix at heudiconv conversion

datadir=/data/projects/istart-data

scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"
baseout=${maindir}/derivatives/fsl/EVfiles
if [ ! -d ${baseout} ]; then
  mkdir -p $baseout
fi


sub=$1


for run in 1 2; do
  input=${datadir}/bids/sub-${sub}/func/sub-${sub}_task-ugdg_run-0${run}_events.tsv

# for pmod tsvs (d is for pmod decision, c is pmod endowment)
  output=${baseout}/sub-${sub}/ugdg_GLM3

# For normal tsvs

#output=${baseout}/sub-${sub}/ugdg

  mkdir -p $output
  if [ -e $input ]; then # sub-3176/ugdg/run-01_event_computer_punish.txt

   # for pmod tsvs
bash /data/tools/bidsutils/BIDSto3col/BIDSto3col.sh -h "Decision_pmod"  $input ${output}/run-0${run} #Change Endowment to Decision if necessary

# For normal tsvs

#bash /data/tools/bidsutils/BIDSto3col/BIDSto3col.sh $input ${output}/run-0${run}

  else
    echo "PATH ERROR: cannot locate ${input}."
    exit
  fi
done
