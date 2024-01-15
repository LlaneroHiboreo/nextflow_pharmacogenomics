process GATHER_RESULTS{
    label 'process_medium'

    container '/scratch_isilon/groups/dat/apps/PYPGX/0.21.0/pypgx_0.21.0.sif'

    input:
        tuple val(meta), path(results_no_alleles)
        tuple val(meta), path(results_alleles)
        path(py_gather_res)
    
    output:
        path("*.tsv")

    when:
        task.ext.when == null || task.ext.when

    script:
        def args = task.ext.args ?: ''
        def prefix = task.ext.prefix ?: "${meta.id}"

    """
    python3 $py_gather_res -rsa $results_alleles $results_no_alleles -o ${prefix}.tsv
    """
}