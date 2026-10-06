#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { BASESPACE_FETCH } from "./modules/basespace.nf"
include { LOCALFILES_FETCH } from "./modules/localfiles.nf"
include { FASTQC } from "./modules/readProcessing.nf"
include { FASTP } from "./modules/readProcessing.nf"
include { MAP_READS } from "./modules/mapping.nf"
workflow{

    ch_samples = Channel.fromPath(params.biosample_csv) \
        .view() \
        .splitCsv(header:false) \
        .view()

    //get data from basespace or from local files
    if( params.use_basespace ){
        BASESPACE_FETCH(ch_samples.map{ it -> it[0]}).view()
        ch_reads = BASESPACE_FETCH.output
    }
    else{
        LOCALFILES_FETCH(ch_samples)
        ch_reads = LOCALFILES_FETCH.output
    }

    FASTQC(ch_reads)
    FASTP(ch_reads)
    FASTP.output.view()
    MAP_READS(FASTP.output, file("${params.genome}"))
}