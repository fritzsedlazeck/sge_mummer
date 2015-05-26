# sge_mummer
Scripts to split reference and run mummer in parallel on an SGE cluster

**************************************

INSTALL:

Download all three scripts:
```
git clone https://github.com/fritzsedlazeck/sge_mummer.git
```

Edit the main script: sge_mummer.sh

Open and correct the paths to the MUMmer installation and to the directory you placed all three scripts. 
Note that nucmer is called with the following parameters: " -maxmatch -l 100 -c 500 ". This can be adjusted in: sge_mummer_helper.sh

**************************************

USAGE:

```
./sge_mummer.sh ref.fa query.fa tmp_directory
```

This script automates the process of "exploding" the reference multi-fasta file into a directory of individual fasta files, and then running in parallel MUMmer/nucmer of the full query dataset against each reference sequence. After the successful completion of the run the tmp_directory will include a merged_results.delta, which is the resulting file from the MUMmer alignments with the headers fixed to point to the original files. This delta file can be used as-if it had been computed directly from the full reference fasta file against the full query fasta file.


***************************************

Questions or comments:
fritz.sedlazeck@gmail.com
