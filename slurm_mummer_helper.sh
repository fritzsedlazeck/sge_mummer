#!/bin/bash

#SBATCH
#SBATCH --job-name=MUMMER
#SBATCH --time=72:0:0
#SBATCH --cpus-per-task=24
#SBATCH --mail-type=end
#SBATCH --mail-user=rluo5\@jhu.edu
#SBATCH --export=Variables
#SBATCH --requeue
#SBATCH --partition=parallel
#SBATCH -o mummer_%A_%a.out
#SBATCH -e mummer_%A_%a.err

## Variables set from outside: $WORK, $REF_FASTA_LIST, $QRY

JOBPERNODE=18;
GROUP=$SLURM_ARRAY_TASK_ID;
MAX=`wc -l < $REF_FASTA_LIST`
COUNT=1

## echo $REF
# run commands and application
pwd
date
hostname

while [ $COUNT -le $JOBPERNODE ]
do
  ID=$(($JOBPERNODE * $GROUP + $COUNT))
  COUNT=$(($COUNT + 1))
  if [ $ID -gt $MAX ]
  then
    break
  fi

  MY_WORK="$WORK/$ID"

  ## define against which ref mummer is aligning
  REF=$(awk "NR==$ID" $REF_FASTA_LIST)

  ## preparing the directory
  echo "Processing task $ID $REF $QRY $MY_WORK"
  if [ ! -e $MY_WORK/$ID.delta ]
  then
    mkdir -p $MY_WORK
    echo "Aligning reads $ID"
    ln -sf $REF $MY_WORK/ref.fa
    ln -sf $QRY $MY_WORK/qry.fa

    cd $MY_WORK

    touch nucmer.${ID}.proc
    $PATHMUM/nucmer -maxmatch -l 100 -c 500 ref.fa qry.fa -p $ID && touch nucmer.success &
  fi

done

wait
date

