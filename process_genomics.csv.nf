#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// Step 1: Read the genomics CSV file
Channel.fromPath('gene_expression.csv')
	.map { it -> file(it) }
	.set { csvFile}

// what it does:
// Finds the file gene_expression.csv in the current directory.
// Creates a channel (a stream of data) from the file.
// Maps the file into a format that Nextflow understands (file(it)).
// Saves the channel output into a variable called csvFile, which will be used in the next step.


// Step 2: Process to filter genes with average TPM > 50
process filterGenes {
	input:
		path csvFile
// what it does:
// Defines a "process" called filterGenes.
// Takes csvFile as an input (which is the gene_expression.csv file).
// Treats it as a path (file location) so Nextflow knows how to find it.
	output:
		path "results/filtered_genes.csv"
// what it does:
// Saves the output to a new file: results/filtered_genes.csv.
// Creates a directory called results/ if it doesn’t exist.
	script:
		"""
		mkdir -p results
		awk -F',' 'NR==1 || (\$2+\$3+\$4)/3 > 50 { print }' $csvFile > results/filtered_genes.csv
		"""
// what it does:
// Create the results/ folder if it doesn't exist (mkdir -p results)
// Uses awk (a command-line tool) to filter genes:
// NR==1 → Keeps the header row
// ($2+$3+$4)/3 > 50 → Filters genes where the average expression (TPM) is greater than 50.
// > results/filtered_genes.csv → Saves the filtered output


}

// Step 3: Define workflow execution
workflow {
	filterGenes(csvFile)
}

// what it does:
// Tells Nextflow what to execute
// Runs the filterGenes process, using csvFile as input
