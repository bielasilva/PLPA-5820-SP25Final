#!/bin/bash

#SBATCH --job-name=DownloadDataset           # Job name
#SBATCH --output=logs/DownloadDataset.log          # Output file. %j is replaced with job ID
#SBATCH --cpus-per-task=10
#SBATCH --time=5-00
#SBATCH --mem=5GB
#SBATCH -p jrw0107_std
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=gas0042@auburn.edu

ROOT_DIR="/mmfs1/scratch/gas0042/Pratical_data"

# Download genomes

wget https://frl.publisso.de/data/frl:6421672/dataset/CAMISIM_setup.tar.gz -nv -c -P ${ROOT_DIR}/Data

tar -xzf ${ROOT_DIR}/Data/CAMISIM_setup.tar.gz -C ${ROOT_DIR}/Data

# Download reads

for i in ($(seq 5 1 15)); do
    mkdir -p ${ROOT_DIR}/Data/sample_${i}
    wget https://frl.publisso.de/data/frl:6421672/dataset/2017.12.29_11.37.26_sample_${i}_reads.tar -nv -c -P ${ROOT_DIR}/Data/sample_${i}
    tar -xf ${ROOT_DIR}/Data/sample_${i}/2017.12.29_11.37.26_sample_${i}_reads.tar -C ${ROOT_DIR}/Data/sample_${i}

done
