#!/usr/bin/env bash

# Define root directory
ROOT_DIR="/mmfs1/scratch/gas0042/Pratical_data"

# Define sample numbers
samples=($(seq 5 1 15))

# Define k-mer sizes
kmer1=(15 17 19 21 23 25 27)
kmer2=(27 29 31 33 35 37 39)
kmer3=(49 51 53 55 57 59 61)
kmer4=(71 73 75 77 79 81 83)

total_jobs=$((${#samples[@]} * ${#kmer1[@]} * ${#kmer2[@]} * ${#kmer3[@]} * ${#kmer4[@]}))
echo "Total jobs: $total_jobs"

# Run metaSPAdes for each sample and each k-mer size
> logs/runMe_KmersTesting-jobs.txt
for id in ${samples[@]}; do
    infile="${ROOT_DIR}/Data/sample_${id}/2017.12.29_11.37.26_sample_${id}/reads/anonymous_reads.fq.gz"
    for k1 in ${kmer1[@]}; do
        for k2 in ${kmer2[@]}; do
            for k3 in ${kmer3[@]}; do
                for k4 in ${kmer4[@]}; do
                    outdir="${ROOT_DIR}/Results/Spades/sample_${id}/S${id}_k${k1}-${k2}-${k3}-${k4}"
                    if [ -s "$outdir/scaffolds.fasta" ]; then
                        continue
                    elif [ $(squeue --me | wc -l) -gt 4000 ]; then
                        echo "Waiting for jobs to finish"
                        sleep 12h
                    fi
sbatch <<-EOF | cut -d ' ' -f 4 >> logs/runMe_KmersTesting-jobs.txt
#!/usr/bin/env bash

#SBATCH --job-name=KmersTesting_S${id}_k${k1}-${k2}-${k3}-${k4}
#SBATCH --output=logs/Spades/KmersTesting_S${id}_k${k1}-${k2}-${k3}-${k4}.log
#SBATCH --ntasks=15
#SBATCH --partition=nova,general,nova_ff
#SBATCH --mem=50GB
#SBATCH --time=36:00:00
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=gas0042_hpc@icloud.com

# Load conda environment
source /mmfs1/home/gas0042/miniforge3/bin/activate Spades

spades.py --12 $infile -o $outdir --meta -k $k1,$k2,$k3,$k4 --threads 15
EOF

                done
            done
        done
    done
done