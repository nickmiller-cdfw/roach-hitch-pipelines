/* Module  to map reads to genome */


process MAP_READS{
    time { 6.hour * task.attempt }
    cpus 8
    memory 16.Gb
    container "oras://community.wave.seqera.io/library/minimap2_samtools:c86efd7778885457"
    publishDir "${params.outdir}/${params.runID}/mapped/", mode: "copy"

    input:
        tuple val(id), path(merged), path(r1), path(r2)
        path(genome)

    output:
        path("${id}.bam"), emit: "bam"
        path("${id}.bam.bai"), emit: "bai"

    script:
    """
        minimap2 -ax sr -t ${task.cpus} ${genome} ${merged} | samtools view -b  > tmp.merged.bam
        minimap2 -ax sr -t ${task.cpus} ${genome} ${r1} ${r2} | samtools view -b  > tmp.paired.bam
        samtools sort -@ ${task.cpus} tmp.merged.bam > tmp2.merged.bam
        samtools sort -@ ${task.cpus} tmp.paired.bam > tmp2.paired.bam
        samtools merge -o tmp.combined.bam tmp2.merged.bam tmp2.paired.bam 
        samtools addreplacerg -@ ${task.cpus} -r ID:${id} -r SM:${id} -o ${id}.bam tmp.combined.bam
        samtools index ${id}.bam
        rm tmp*
    """


}

