process RUN_NGS_PIPELINE{
    label 'process_medium'

    container '<container>'

    input:
        tuple val(meta), path(input_vcf), path(tbi), path(coverage), path(control_stats), val(meta4), path(panel), path(panel_index), path(cnv_callers)
        
    
    output:
        tuple val(meta), path("*"), emit: ngs
        //path("versions.yml")
    
    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"

    cnvcallers = cnv_callers ?"--cnv-caller ${cnv_callers}":""


    """
    pypgx \\
    run-ngs-pipeline \\
    ${meta4.id} \\
    ${prefix}_${meta4.id}_pipe \\
    --variants ${input_vcf} \\
    --depth-of-coverage ${coverage} \\
    --control-statistics ${control_stats} \\
    --panel ${panel} \\
    ${cnvcallers} \\
    --assembly ${params.phcg}
    """
}
