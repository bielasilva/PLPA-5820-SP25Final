#!/bin/bash

# Load conda environment
source /mmfs1/home/gas0042/miniforge3/bin/activate Quast

# Define root directory
ROOT_DIR="/mmfs1/scratch/gas0042/PLPA_project"

# Define misc functions
echo_overwrite() { echo -e "\r\033[1A\033[0K$@"; }
get_time() { date +"%Y-%m-%d %H:%M:%S"; }

# Define sample numbers
samples=($(seq 5 1 15))

# Define k-mer sizes
kmer1=(15 17 19 21 23 25 27)
kmer2=(27 29 31 33 35 37 39)
kmer3=(49 51 53 55 57 59 61)
kmer4=(71 73 75 77 79 81 83)

# Run metaQuast for each sample and each k-mer size

> logs/runMe_metaQUAST-jobs.txt
try=0
for id in ${samples[@]}; do
    reads="${ROOT_DIR}/Data/sample_${id}/2017.12.29_11.37.26_sample_${id}/reads/anonymous_reads.fq.gz"
    for k1 in ${kmer1[@]}; do
        for k2 in ${kmer2[@]}; do
            for k3 in ${kmer3[@]}; do
                for k4 in ${kmer4[@]}; do
                    infile="${ROOT_DIR}/Results/Spades/sample_${id}/S${id}_k${k1}-${k2}-${k3}-${k4}/scaffolds.fasta"
                    outdir="${ROOT_DIR}/Results/Metaquast/sample_${id}/S${id}_k${k1}-${k2}-${k3}-${k4}"
                    if [ -s "$outdir/report.tsv" ] || [ $k1 -eq $k2 ]; then
                        echo_overwrite "Skipping sample $id with k-mer $k1-$k2-$k3-$k4"
                        continue
                    elif [ -s "$infile" ]; then
                        jobs_number=$(squeue --me | grep R_Meta | wc -l)
                        if [ $jobs_number -ge 1000 ]; then
                            try=$((try+1))
                            echo_overwrite "$(get_time) Waiting for jobs to finish ($try)"
                            sleep 1h
                            jobs_number=$(squeue --me | grep R_Meta | wc -l)
                            echo -e "$(get_time) There are $jobs_number in the queue"
                        fi
                        echo_overwrite "Submitting sample $id with k-mer $k1-$k2-$k3-$k4"
sbatch <<-EOF | cut -d ' ' -f 4 >> logs/runMe_metaQUAST-jobs.txt
#!/bin/bash

#SBATCH --job-name=R_MetaQUAST_S${id}_k${k1}-${k2}-${k3}-${k4}
#SBATCH --output=logs/MetaQUAST/S${id}/MetaQUAST_S${id}_k${k1}-${k2}-${k3}-${k4}.log
#SBATCH --ntasks=10
#SBATCH --partition=nova,general,nova_ff
#SBATCH --time=10-00
#SBATCH --mem=10GB

quast.py $infile -o $outdir --pe12 $reads --threads 10
EOF
                    fi
                done
            done
        done
    done
done