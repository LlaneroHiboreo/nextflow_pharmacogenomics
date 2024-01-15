process CREATE_INPUT_VCF{
    label 'process_medium'

    container 'quay.io/biocontainers/pypgx:0.21.0--pyh7cba7a3_0'

    input:
        tuple val(meta), path(bam), path(bai)
        tuple val(meta_ref), path(reference)
    
    output:
        tuple val(meta), path("*.vcf.gz"), emit: vcf
        //path("versions.yml")
    
    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"

    """
    pypgx \\
    create-input-vcf \\
    --assembly ${meta_ref.ref} \\
    ${args} \\
    ${prefix}.vcf.gz \\
    $reference \\
    $bam
    """
}
