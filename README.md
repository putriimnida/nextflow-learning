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
