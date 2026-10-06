import java.lang.String

/* A module to process read data prior to mapping etc. */

process FASTQC {
    time { 2.hour * task.attempt }
    cpus 2
    memory 2.Gb
    container "https://depot.galaxyproject.org/singularity/fastqc%3A0.12.1--hdfd78af_0"

    publishDir "${params.outdir}/${params.runID}/fastQC/", mode: "copy"

    input:
    tuple val(id), path(read1), path(read2)

    output:
    path("${read1.toString().replace(".fastq.gz", "_fastqc.html")}")
    path("${read2.toString().replace(".fastq.gz", "_fastqc.html")}")
  
    shell:
    """
    fastqc ${params.fastQC_Opts} -t ${task.cpus} ${read1} ${read2}
    """
}


process FASTP {
    time { 2.hour * task.attempt }
    cpus 4
    memory 16.Gb
    container "https://depot.galaxyproject.org/singularity/fastp%3A1.3.6--h43da1c4_0"
    publishDir "${params.outdir}/${params.runID}/fastp/", mode: "copy"

    input:
        tuple val(id), path(read1), path(read2)

    output:
    tuple val("${id}"), path("${id}.fastq.gz"), path("${id}.r1.fastq.gz"), path("${id}.r2.fastq.gz")

    shell:
    """
    fastp ${params.fastp_Opts} \
    -i ${read1} \
    -I ${read2} \
    -o ${id}.r1.fastq.gz \
    -O ${id}.r2.fastq.gz \
    --merge \
    --merged_out "${id}.fastq.gz"
    """
}
