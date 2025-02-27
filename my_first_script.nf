#!/usr/bin/env nextflow
nextflow.enable.dsl=2  // Enable DSL2

// Define input parameters with a default value
params.name = params.name ?: "Nextflow User"

// Create a channel for the name parameter
name_channel = Channel.of(params.name)

// Define a process to print a greeting
process GREETING {
    input:
    val person_name from name_channel  // Fix input syntax

    output:
    stdout

    script:
    """
    echo "Hello, $person_name! Welcome to Nextflow!"
    """
}

// Define a workflow (mandatory in DSL2)
workflow {
    GREETING(name_channel)
}
