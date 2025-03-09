#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// Step 1: create a channel with test values
Channel.of(1, 2, 3, "error", 5) | set { testValues }

// Step 2: Process that sometimes fails
process faultyProcess {
	input:
	val value

	errorStrategy 'retry'   // Retry if the process fails
	maxRetries 3		// Try up to 3 times before failing

	script:
	"""
	if [[ "$value" == "error" ]]; then
		echo "Simulating failure..." >&2
		exit 1  # simulate a failure

	fi 
	echo "Processing value: $value"
	"""

}
// The process faultyProcess intentionally fails when it encounters "error"
// If an error occurs, it retries up to 3 times before failing.



// Step 3: Workflow execution
workflow {
	testValues.view { "Received value: $it" }
	faultyProcess(testValues)
} 

// Why did it fail?
// The "error" string caused the process to exit with status 1 (exit 1).
// The script retried 3 times (maxRetries 3), but the error persisted.
// After the retries were exhausted, Nextflow reported the process failure.
