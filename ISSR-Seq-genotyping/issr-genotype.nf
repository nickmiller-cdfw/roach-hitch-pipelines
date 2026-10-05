#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { BASESPACE_FETCH } from "./modules/basespace.nf"
include { LOCALFILES_FETCH } from "./modules/localfiles.nf"

workflow{

    ch_samples = Channel.fromPath(params.biosample_csv) \
        .view() \
        .splitCsv(header:false) \
        .view()

    //get data from basespace or from local files
    if( params.use_basespace ){
        BASESPACE_FETCH(ch_samples.map{ it -> it[0]}).view()
    }
    else{
        LOCALFILES_FETCH(ch_samples)
    }
}