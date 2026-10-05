# A pipeline to analyze ISSR-Seq data from roach and hitch

## Input sequencing data

Read data can either be downloaded from basespace or be proveded already-downloaded. In ether case, the start point is a CSV file specifying the samples. The first column is the biosample names to be used. For basespace downloads, this is the only column needed. For local data two additional colmns are needed, specifying the filenames of the forward and reverse reads.