This repository documents my learning process with Nextflow

## 📌 What is Nextflow?
[Nextflow](https://www.nextflow.io/) is a **workflow automation tool** that makes it easy to run scalable and reproducible pipelines in **bioinformatics, genomics, and machine learning**.

---

## 📂 Repository Structure
📁 **hello.nf** → A basic Nextflow script that prints "Hello, Nextflow!".  
📁 **parallel_example.nf** → Running multiple tasks in parallel.  
📁 **file_output.nf** → Writing Nextflow process outputs to files.  
📁 **two_step_pipeline.nf** → Multi-step workflow demonstrating data flow.  

---

## 🛠️ Code Examples & Explanations

### ✅ **1. Basic "Hello, Nextflow!" Script**
File: [`hello.nf`](hello.nf)
```nextflow
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
    sayHello("Putri")
}
```

### ✅ **2. Running Multiple Processes in Parallel**
File: [`parallel_example.nf`](parallel_example.nf)
```nextflow
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
```

### ✅ **3. Writing Output to Files**
File: [`file_output.nf`](file_output.nf)
```nextflow
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
```

### ✅ **4. Multi-Step Workflow**
File: [`two_step_pipeline.nf`](file_output.nf)
```nextflow
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
    processed = items.map { x -> "Processed_$x" }  // Generate processed results directly
    secondStep(processed)
}
```

### ✅ **5. Channels & Data Flow**
File: [`channels_example.nf`](file_output.nf)
- Learned how to pass data dynamically from a directory
- Linked processes together to create a bioinformatics-like pipeline
- Instead of writing loops, Nextflow automatically distibutes tasks
- Each number is processed independently, enabling parallel execution
- Can be applied to real bioinformatics tasks (e.g. processing multiple FASTQ files)
```nextflow
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
```

### ✅ **6. Process and Filter Data**
File: ['process_genomics.csv.nf'](process_genomics.csv.nf)
```nextflow
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
```

### ✅ 7 **Create and Parallel Processing of Nextflow Script** 
File:['parallel_processing.nf'](parallel_processing.nf)

```nextflow
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

```

