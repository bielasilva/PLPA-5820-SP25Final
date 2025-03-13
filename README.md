# Metagenomics K-mer Testing

This repository contains the code and results for a study on the influence of k-mer sizes on genome assembly metrics in metagenomic analyses using metaSPAdes. The goal is to determine the optimal combination of k-mer sizes to maximize genome recovery quality.

## Project Overview

The project explores how varying multiple k-mer sizes affects genome recovery using metaSPAdes, a metagenomic assembler. By testing different combinations of k-mer sizes on the CAMI mouse gut toy dataset, the study aims to optimize assembly parameters for better genome recovery.

## Directory Structure

```text
├── README.md
└── Scripts/
    └── bash/
        ├── runMe_KmersTesting.sh
        └── sbatchMe_download_dataset.sh
```

### Directory and File Descriptions

### Prerequisites

### Data Download

1. **Download the CAMI Dataset**:
   - Navigate to the `Scripts/bash/` directory.
   - Run the SLURM batch script to download the dataset:
        ```bash
        sbatch sbatchMe_download_dataset.sh
        ```
   - This script uses `camiClient.jar` to download the necessary data.
  
### Running Assemblies

- **Assemble with Different K-mer Combinations**:
    - Go to the `Scripts/bash/` directory.
    - Execute the assembly script:
        ```bash
        ./runMe_KmersTesting.sh
        ```
    - This script runs metaSPAdes with various k-mer size combinations as specified in the study.