#!/bin/bash
# written by Fritz Sedlazeck, for questions: fsedlazeck@cshl.edu
# modified by Ruibang Laurent Luo to work with SLURM on MARCC, rluo5@jhu.edu

JOBPERNODE=18

min_args=3
#path to the mumer install directory:
script_path=/work-zfs/mschatz1/rb/slurm_mummer
#path to the mumer install directory:
mummer_path=/work-zfs/mschatz1/rb/MUMmer3.23

#check if user specified the requried parameters
if [ $# -eq $min_args ]; then
  #get full paths:
  ref=$(readlink -f $1)
  query=$(readlink -f $2)
  work=$(readlink -f $3)

  #prepare ref file:
  mkdir -p $work
  echo "split up ref"
  $script_path/explode_fasta.pl $ref $work

  #create slurm job:
  NUMGROUPS=`wc -l < $work/summary`
  NUMGROUPS=$(($NUMGROUPS / $JOBPERNODE))

  cat $script_path/slurm_mummer_helper.sh > $work/mummer.sh
  sbatch --array=0-${NUMGROUPS} -D `pwd` --export=PATHMUM=$mummer_path,REF_FASTA_LIST=$work/summary,QRY=$query,WORK=$work $work/mummer.sh

  echo "job submitted, when finished, please run post processing."
  echo "Finished succesfully."
else
  echo "Splits and aligns the ref.fa to the query.fa"
  echo "File path of the ref file"
  echo "File path of the query file"
  echo "Working directory"
fi

