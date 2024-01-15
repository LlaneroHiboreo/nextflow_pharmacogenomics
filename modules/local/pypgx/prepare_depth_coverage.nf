process PREPARE_DEPTH_COVERAGE{
    label 'process_medium'

    container '/scratch_isilon/groups/dat/apps/PYPGX/0.21.0/pypgx_0.21.0.sif'

    input:
        tuple val(meta), path(bam), path(bai)
    
    output:
        tuple val(meta), path("*.zip"), emit: coverage
        //path("versions.yml")
    
    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"

    """
    pypgx \\
    prepare-depth-of-coverage \\
    --assembly $params.phcg \\
    $args \\
    ${prefix}.depth-of-coverage.zip \\
    $bam
    """
}