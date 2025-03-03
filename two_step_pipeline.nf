#!/usr/bin/env nextflow

process firstStep {
    input:
        val x

    output:
        val processed_result

    script:
        """
        echo "Processed_$x"
        """

}

process secondStep {
    input:
        val data

    output:
        stdout

    script:
        """
        echo "Final step: $data"
        """
}

workflow {
    items = Channel.from("A", "B", "C")
    processed = items.map { x -> "Processed_$x" } // Generate processed results directly
    secondStep(processed)
}

