process CREATE_INPUT_VCF{
    label 'process_medium'

    container '/scratch_isilon/groups/dat/apps/PYPGX/0.21.0/pypgx_0.21.0.sif'

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