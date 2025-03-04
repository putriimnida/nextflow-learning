#!/usr/bin/env nextflow

// 📌 1. Create a dynamic channel with numbers
Channel.from(1, 2, 3, 4, 5)  // Generates a list dynamically
    .set { numbers }

// 📌 2. Process: Takes a number and squares it
process squareNumbers {
    input:
        val x from numbers  // Receives/takes one value at a time from the channel

    output:
        val squaredResult

    script:
        """
        echo $(( x * x ))   // Computes the square of x
        """
}

// 📌 3. Collect results & print them
squaredResults = squareNumbers(numbers)

squaredResults.view { result -> "Squared result: ${result}" }    // Prints each squared number

// Expected output:
// Squared result: 1
// Squared result: 4
// Squared result: 9
// Squared result: 16
// Squared result: 25

