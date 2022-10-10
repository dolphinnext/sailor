$HOSTNAME = ""
params.outdir = 'results'  


if (!params.inputfile){params.inputfile = ""} 
if (!params.Genome){params.Genome = ""} 
if (!params.knownSnps){params.knownSnps = ""} 
if (!params.Alignment){params.Alignment = ""} 

Channel.fromPath(params.inputfile, type: 'any').map{ file -> tuple(file.baseName, file) }.set{g_0_sample_set0_g_1}
g_3_fastaFile1_g_1 = file(params.Genome, type: 'any')
g_4_bed2_g_1 = file(params.knownSnps, type: 'any')
Channel.fromPath(params.Alignment, type: 'any').toSortedList().set{g_5_bam_file3_g_1}


process Sailor {

publishDir params.outdir, mode: 'copy', saveAs: {filename -> if (filename =~ /${name}\/SAILOR-JOB-LOG.txt$/) "outputparam/$filename"}
input:
 set val(name), file(input_yaml) from g_0_sample_set0_g_1
 file fasta from g_3_fastaFile1_g_1
 file knownSnps from g_4_bed2_g_1
 set alignment from g_5_bam_file3_g_1

output:
 file "${name}/SAILOR-JOB-LOG.txt"  into g_1_log_file00
 file "${name}/results"  into g_1_resultsdir11

"""
#shell example: 

#!/bin/sh 
sailor-1.0.4 ${input_yaml}
"""
}


workflow.onComplete {
println "##Pipeline execution summary##"
println "---------------------------"
println "##Completed at: $workflow.complete"
println "##Duration: ${workflow.duration}"
println "##Success: ${workflow.success ? 'OK' : 'failed' }"
println "##Exit status: ${workflow.exitStatus}"
}
