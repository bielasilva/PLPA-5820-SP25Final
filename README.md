# Metagenomics K-mer Testing

This repository contains the code and results for a study on the influence of k-mer sizes on genome assembly metrics in metagenomic analyses using metaSPAdes. The goal is to determine the optimal combination of k-mer sizes to maximize genome recovery quality.

## Project Overview

The project explores how varying multiple k-mer sizes affects genome recovery using metaSPAdes, a metagenomic assembler. By testing different combinations of k-mer sizes on the CAMI mouse gut toy dataset, the study aims to optimize assembly parameters for better genome recovery.

## Data disclamer

Due to the large size and the amount of files generated throughout this project, the full data is not included in this repository. The analysis was performed on a SLURM cluster, and the scripts are designed to be run in a Unix-like environment.

The only data included in this repository is the summary of all metaquast results (`Results/Metaquast_summary.tsv`), which contains the assembly metrics for all k-mer combinations tested, and can be used to reproduce the figures in the analysis (`Scripts/Markdown/Analysis.Rmd`).

## Directory Structure

```text
├── README.md
├── Results/
            ├── Analysis_figures/
            └── Metaquast_summary.tsv
└── Scripts/
    ├── bash/
        ├── runMe_KmersTesting.sh
        ├── runMe_metaQuast.sh
        ├── runMe_metaQuast_gs.sh
        └── sbatchMe_download_dataset.sh
    └── Markdown/
        ├── Analysis.Rmd
        ├── Analysis.html
        └── Analysis.pdf
```

### Directory and File Descriptions

- **README.md**: This file. Provides an overview and instructions for the project.
- **Results/**: Contains the results of the analysis.
  - **Analysis_figures/**: Directory for storing figures generated from the analysis.
  - **Metaquast_summary.tsv**: Summary table of assembly metrics generated by metaQUAST.
- **Scripts/**: Contains all scripts used in the project.
  - **bash/**: Contains Bash scripts for running various parts of the pipeline.
    - **runMe_KmersTesting.sh**: Script to run assemblies with different k-mer combinations.
    - **runMe_metaQuast.sh**: Script to run metaQUAST on the assemblies.
    - **runMe_metaQuast_gs.sh**: Script to run metaQUAST on the gold standard references.
    - **sbatchMe_download_dataset.sh**: SLURM batch script for downloading the dataset.
  - **Markdown/**: Contains Markdown documents for analyzing data and generating figures.
    - **Analysis.Rmd**: Markdown file for data analysis and visualization.
    - **Analysis.html**: Rendered HTML report from the `Analysis.Rmd` file.
    - **Analysis.pdf**: PDF version of the rendered HTML report.

### Prerequisites

All softwares were installed in the cluster using `conda` environments, and the scripts are designed to be run in a Unix-like environment. The following software and data are required to run the analysis:

- **Software Requirements**:
    - **SPAdes**: Version 4.0.0 or higher
    - **metaQUAST**: Version 5.2.0
    - **R**: Version 4.4.1
        - Required R packages: `sensitivity`, `pls`, `tidyverse`, `ggpubr`, `RColorBrewer`, `lme4`
    - **Knitr**: For rendering `.Rmd` files
    - **Java**: For running `camiClient.jar`
    - **SLURM**: For batch job submission
- **Data Requirements**:
    - **CAMI Mouse Gut Toy Dataset**

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

### Running metaQUAST

- **Analyze Assemblies with metaQUAST**:
    - To run metaQUAST on the assemblies:
        ```bash
        ./runMe_metaQuast.sh
        ```
    - To include gold standard references in metaQUAST:
        ```bash
        ./runMe_metaQuast_reduced_gs.sh
        ```

### Analysis

- **Summarize Assembly Statistics**:
    - Use the SLURM batch script to summarize stats:
        ```bash
        sbatch sbatchMe_summarize_stats.sh
        ```
    - This will generate summary tables of the assembly metrics.

- **Generate Reports with Rmarkdown**:
    - Go to the `Scripts/Markdown/` directory.
    - Render the Rmarkdown file on Rstudio or using the command line:
        ```bash
        Rscript -e "rmarkdown::render('Analysis.Rmd')"
        ```
    - This will produce an `Analysis.html` and `Analysis.pdf` report in the same directory. Figures will be saved in the `Results/Analysis_figures/` subdirectory.
