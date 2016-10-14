#!/bin/bash
# written by Fritz Sedlazeck, for questions: fsedlazeck@cshl.edu
# modified by Ruibang Laurent Luo to work with SLURM on MARCC, rluo5@jhu.edu

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

  echo "reconstructing file"
  #create a merged file:
  #header:
  echo "$ref $query" > $work/'merged_results.delta'
  echo "NUCMER" >> $work/'merged_results.delta'
  #footer:
  for i in `/bin/ls $work/*/nucmer.*.proc`
  do
    DIR=$(dirname "${i}")
    if [ ! -f $DIR'/nucmer.success' ]; then
      echo "ERROR: One subprocess exit with error!"
      exit
    fi
    awk ' NR > 2 {print $0} ' $DIR/*.delta >> $work/'merged_results.delta'
  done
  #cleaning up the working directory
  tmp=1
  for i in $(cat $work/summary)
  do
    rm $i
    rm -r $work/$tmp
    tmp=$((tmp+1))
  done
  rm $work/summary
  rm $work'/mummer.sh'
  echo "Finished succesfully."
else
  echo "Splits and aligns the ref.fa to the query.fa"
  echo "File path of the ref file"
  echo "File path of the query file"
  echo "Working directory"
fi

