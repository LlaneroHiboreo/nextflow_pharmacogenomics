process GATHER_RESULTS{
    label 'process_medium'

    container 'quay.io/biocontainers/pypgx:0.21.0--pyh7cba7a3_0'

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
