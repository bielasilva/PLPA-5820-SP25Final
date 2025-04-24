#!/bin/bash

# Load conda environment
source /mmfs1/home/gas0042/miniforge3/bin/activate Quast

# Define root directory
ROOT_DIR="/mmfs1/scratch/gas0042/PLPA_project"

# Define sample numbers
samples=($(seq 5 1 15))

# Run metaQuast for each sample and each k-mer size

> logs/runMe_metaQUAST_gs-jobs.txt

for id in ${samples[@]}; do
    reads="${ROOT_DIR}/Data/sample_${id}/2017.12.29_11.37.26_sample_${id}/reads/anonymous_reads.fq.gz"
    # Define Ref assembly
    infile="${ROOT_DIR}/Data/sample_${id}/2017.12.29_11.37.26_sample_${id}/contigs/anonymous_gsa.fasta"
    outdir="${ROOT_DIR}/Results/Metaquast/sample_${id}/S${id}_GS"
sbatch <<-EOF | cut -d ' ' -f 4 >> logs/runMe_metaQUAST_gs-jobs.txt
#!/bin/bash

#SBATCH --job-name=R_MetaQUAST_S${id}_GS
#SBATCH --output=logs/MetaQUAST/S${id}/MetaQUAST_S${id}_GS.log
#SBATCH --ntasks=10
#SBATCH --partition=nova,general,nova_ff
#SBATCH --time=10-00

quast.py $infile -o $outdir --pe12 $reads --threads 10
EOF
done