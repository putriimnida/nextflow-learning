#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// Step 1: Create a channel from a file
Channel.fromPath('input_data/textfile.txt')
       .set { textFile }

// Step 2: Define a process to modify the file
process modifyFile {
    input:
        path inputFile 

    output:
        path "results/modified_textfile.txt"

    script:
    """
    mkdir -p results
    awk '{print toupper(\$0)}' $inputFile > results/modified_textfile.txt
    """
}

// Step 3: Define workflow execution
workflow {
    modifyFile(textFile)
}

