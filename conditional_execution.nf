#!usr/bin/env nextflow
nextflow.enable.dsl=2

// Define a parameter for threshold
params.threshold = 100

// Define a channel with some test values
Channel.of(50, 120, 80, 200, 95) | set { values }

// Define a process that only runs if the value is above the threshold
process checkThreshold {
	input:
	val num 

	when:
	num > params.threshold

	script:
	"""
	echo "Processing number: $num"
	"""
}

// Define the workflow
workflow {
	values.view { "Received number: $it" } // Debugging line (optional)
	checkThreshold(values)
}
