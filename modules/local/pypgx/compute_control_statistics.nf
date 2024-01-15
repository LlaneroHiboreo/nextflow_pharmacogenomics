process COMPUTE_CONTROL_STATISTICS{
    label 'process_medium'

    container <container>

    input:
        tuple val(meta), path(bam), path(bai)
    
    output:
        tuple val(meta), path("*.zip"), emit: stats
        //path("versions.yml")
    
    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def controlGenes = task.ext.control_genes ?:''
    def controlGenesList = ["VDR", "EGFR", "RYR1"]

    if (controlGenesList.contains(controlGenes)) {
        println("CONTROL GENE USED TO COMPUTE CONTROL STATISTICS IS RECOMMENDED.")
    } else {
        exit 1, 'CONTROL GENE USED IS NOT RECOMMENDED, use -> "VDR", "EGFR" or "RYR1" in the module configuration'
    }
    """
    pypgx \\
    compute-control-statistics \\
    --assembly $params.phcg \\
    $controlGenes \\
    $args \\
    ${prefix}.control-statistics-VDR.zip \\
    $bam
    """
}
