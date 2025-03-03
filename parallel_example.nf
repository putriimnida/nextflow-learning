#!/usr/bin/env nextflow

process sayHello {
    input:
        val name

    output:
        stdout

    script:
        """
        echo "Hello, $name!"
        """
}

workflow {
    names = Channel.from("Putri", "Nextflow", "Bioinformatics")
    sayHello(names)
}

