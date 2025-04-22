# This script summarizes the results of metaQuast runs for different samples and k-mer sizes.
# It should be run on the cluster.

message("Running summarize_stats.R")

# Load necessary libraries
library(tidyverse)

ROOT_DIR <- "/mmfs1/scratch/gas0042/Pratical_data"

# Define sample numbers
samples <- seq(5, 15, 1)

# Define k-mer sizes
kmer1 <- c(15, 17, 19, 21, 23, 25, 27)
kmer2 <- c(27, 29, 31, 33, 35, 37, 39)
kmer3 <- c(49, 51, 53, 55, 57, 59, 61)
kmer4 <- c(71, 73, 75, 77, 79, 81, 83)

# Run metaQuast for each sample and each k-mer size
output_file <- paste0(ROOT_DIR, "/Results/Metaquast_reduced_summary.tsv")

# Function to process each file and relabel the "scaffolds" column
process_metaquast_file <- function(label, file_path) {

  # Read the file, skipping any irrelevant rows
  sample_df <- read_tsv(file_path, col_names = TRUE, show_col_types = FALSE)

  # Rename the "scaffolds" column
  names(sample_df) <- c("Metric", label)

  return(sample_df)
}

message("Processing Metaquast files...")
# Create an empty data frame to store results
summary_df <- data.frame()

for (id in samples) {
  # Process the Gold Standard first
  sample_df <- process_metaquast_file(paste0("S", id, "_GS-GS-GS-GS")
                                    , paste0(ROOT_DIR, "/Results/Metaquast_reduced/sample_", id, "/","S",id,"_GS", "/report.tsv"))
  
  if (nrow(summary_df) == 0) {
    summary_df <- sample_df
  } else {
    summary_df <- full_join(summary_df, sample_df, by = "Metric")
  }
  # Loop through all combinations of k-mer sizes
  for (k1 in kmer1) {
    for (k2 in kmer2) {
      for (k3 in kmer3) {
        for (k4 in kmer4) {
          # Construct the file path
          label <- paste0("S", id, "_k", k1, "-", k2, "-", k3, "-", k4)
          file_path <- paste0(ROOT_DIR, "/Results/Metaquast_reduced/sample_", id, "/",label, "/report.tsv")

          if (file.exists(file_path)) {
            sample_df <- process_metaquast_file(label, file_path)

            summary_df <- full_join(summary_df, sample_df, by = "Metric")
          }
        }
      }
    }
  }
}

message("Saving summarized results...")
# Write the summarized data to a TSV file
write_tsv(summary_df, output_file)

message(paste("Summarized results saved to", output_file))