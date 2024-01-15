process PREPARE_DEPTH_COVERAGE{
    label 'process_medium'

    container 'container <container>'

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
