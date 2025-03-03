#!/usr/bin/env nextflow

process writeToFile {
    input:
        val name

    output:
        path "hello_${name}.txt"

    script:
        """
        echo "Hello, $name!" > hello_${name}.txt
        """
}

workflow {
    names = Channel.from("Putri", "Nextflow", "Genomics")
    writeToFile(names)
}

