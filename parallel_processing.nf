#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// Step 1: Create a channel to collect all CSV files from input_data/ folder
Channel
	.fromPath("input_data/sample*.csv")
	.map { file(it) }
	.set { sampleFiles }

// Step 2: Process each gene expression file in parallel
process analyzeSamples {
	input:
		path sampleFile // Each file from the channel will be processed

	output:
		path "results/processed_${sampleFile.baseName}.csv"

	script:
		"""
		mkdir -p results
		awk -F',' 'NR==1 || \$2 > 100 { print }' $sampleFile > results/processed_${sampleFile.baseName}.csv
		"""
}
// NR==1 → Keeps the header row (so column names don’t get deleted).
// $2 > 100 → Filters genes where TPM (expression level) is greater than 100.
// > results/processed_${sampleFile.baseName}.csv → Saves filtered results.
// After filtering (TPM > 100), MYC will be removed from the output.

// Step 3: Define workflow execution
workflow {
	analyzeSamples(sampleFiles)
}
