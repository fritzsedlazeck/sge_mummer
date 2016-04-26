!/bin/bash
# written by Fritz Sedlazeck, for questions: fsedlazeck@cshl.edu

min_args=3
#path to the mumer install directory:
script_path=/seq/schatz/fritz/sge_mummer2/sge_mummer/
#path to the mumer install directory:
mummer_path=/sonas-hs/schatz/hpc/home/fsedlaze/programs/MUMmer3.23/

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
	
	#create sge job:
	num=$(wc -l < $work/summary)
	sed "s/NUMMER/$num/g" $script_path/sge_mummer_helper.sh > $work'/mummer.sh'
	qsub -sync y -N mummersplit -o $work/output.txt -e $work/error.txt -v PATHMUM=\'$mummer_path\',REF_FASTA_LIST=\'$work/summary\',QRY=\'$query\',WORK=\'$work\' $work'/mummer.sh'
	echo "wating for mummer to finish"
	echo "reconstructing file"
	#create a merged file:
	#header:
	echo "$ref $query" > $work/'merged_results.delta'
	echo "NUCMER" >> $work/'merged_results.delta'
	#footer:
	for i in `/bin/ls $work/*/nucmer.proc`
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

