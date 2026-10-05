process LOCALFILES_FETCH{
    time { 1.hour * task.attempt }
    cpus 1
    memory 16.Gb

    publishDir "${params.outdir}/${params.runID}/fastq/", mode: "copy"

    input:
        tuple val(sampleID), val(r1FileName), val(r2FileName)

    output:
        tuple val("${sampleID}"), file("${sampleID}_R1.fastq.gz"), file("${sampleID}_R2.fastq.gz")

    script:
    """
    zcat ${params.localFastqDir}/${r1FileName} > ${sampleID}_R1.fastq
    zcat ${params.localFastqDir}/${r2FileName} > ${sampleID}_R2.fastq
    gzip ${sampleID}_R1.fastq ${sampleID}_R2.fastq
    """

}