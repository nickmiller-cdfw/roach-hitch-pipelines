process BASESPACE_FETCH{
    time { 1.hour * task.attempt }
    cpus 1
    memory 16.Gb
    container "oras://ghcr.io/nickmiller-cdfw/basespace:latest"

    publishDir "${params.outdir}/${params.runID}/fastq/", mode: "copy"

    input:
        val(sampleID)

    output:
        tuple val("${sampleID}"), file("${sampleID}_R1.fastq.gz"), file("${sampleID}_R2.fastq.gz")

    script:
    """
    bs download biosample --name ${sampleID}
    rm *.json
    DLDIR=\$(ls)
    zcat \$DLDIR/${sampleID}*R1*.fastq.gz > ./${sampleID}_R1.fastq
    zcat \$DLDIR/${sampleID}*R2*.fastq.gz > ./${sampleID}_R2.fastq
    gzip ./*.fastq
    """

}