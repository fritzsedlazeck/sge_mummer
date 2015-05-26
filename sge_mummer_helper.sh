#!/bin/bash
# specify BASH shell
#$ -S /bin/bash
# pass environment variables to job, e.g. LD_LIBRARY_PATH
#$ -v LD_LIBRARY_PATH
# run job in the current working directory where qsub is executed from
#$ -cwd
#  specify that the job requires 16GB of memory
#$ -l m_mem_free=16G
# Tell SGE this is an array job with 195 jobs
#$ -t 1-NUMMER

## Variables set from outside: $WORK, $REF_FASTA_LIST. $QRY
MY_WORK="$WORK/$SGE_TASK_ID"
echo $SGE_TASK_ID

## define against which ref mummer is aligning
REF=$(awk "NR==$SGE_TASK_ID" $REF_FASTA_LIST)

## echo $REF
# run commands and application
pwd
date
hostname

## preparing the directory
echo "Processing task $SGE_TASK_ID $REF $QRY $MY_WORK"
mkdir -p $MY_WORK
ln -s $REF $MY_WORK/ref.fa
ln -s $QRY $MY_WORK/qry.fa

cd $MY_WORK

if [ ! -e $MY_WORK/$SGE_TASK_ID.delta ]
then
  echo "Aligning reads"
  $PATHMUM/nucmer -maxmatch -l 100 -c 500 ref.fa qry.fa -p $SGE_TASK_ID && touch nucmer.success
  touch "nucmer.done"
fi

date
