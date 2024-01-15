/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    VALIDATE INPUTS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

// Check mandatory parameters
if (params.input) { ch_input = file(params.input) } else { exit 1, 'Input samplesheet not specified!' }
ch_fasta = Channel.fromPath(params.fasta).map { it -> [[ref:'GRCh38'], it] }.collect()


// Code to prepare list of candidate genes with star alleles
params.star_alleles_list_preprare = params.star_alleles_list?.split(',') as List
ch_target_star_alleles_list  = Channel.fromList(params.star_alleles_list_preprare).map { it -> [id:it] }

// Code to prepare list of candidate genes with star alleles
params.no_star_alleles_list_preprare = params.no_star_alleles_list?.split(',') as List
ch_target_no_star_alleles_list  = Channel.fromList(params.no_star_alleles_list_preprare).map { it -> [id:it] }


// Prepare files for panel alleles
ch_target_panel_files = Channel.fromPath(params.panel_files).map { it -> [[id:it.simpleName], it] }
ch_target_panel_indexes = Channel.fromPath(params.panel_indexes).map { it -> [[id:it.simpleName], it] }
ch_target_file_index = ch_target_panel_files.join(ch_target_panel_indexes)

// Prepare files for caller CNVs
ch_target_cnv_caller_files = Channel.fromPath(params.cnv_caller_files).map { it -> [[id:it.simpleName], it] }

// Prepare files for caller CNVs
ch_pymerge = Channel.fromPath("${workflow.projectDir}/modules/local/pypgx/gather_results.py")


/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    CONFIG FILES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT LOCAL MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// SUBWORKFLOW: Consisting of a mix of local and nf-core/modules
//
include { INPUT_CHECK } from '../subworkflows/local/input_check'
include { NGS_PIPELINE } from '../subworkflows/local/ngs_pipeline'
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT NF-CORE MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// MODULE: Installed directly from nf-core/modules
//
include { CUSTOM_DUMPSOFTWAREVERSIONS } from '../modules/nf-core/custom/dumpsoftwareversions/main'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

// Info required for completion email and summary
def multiqc_report = []

workflow PHARMACOGENOMICS {

    ch_versions = Channel.empty()

    //
    // SUBWORKFLOW: Read in samplesheet, validate and stage input files
    //
    INPUT_CHECK (
        ch_input
    )
    
    ch_versions = ch_versions.mix(INPUT_CHECK.out.versions)

    // Build channels for gene databases
    ch_target_star_alleles_panel = ch_target_star_alleles_list.join(ch_target_file_index)
    ch_target_no_star_alleles_panel = ch_target_no_star_alleles_list.join(ch_target_file_index)
    ch_target_star_alleles_cnv_caller = ch_target_star_alleles_list.join(ch_target_cnv_caller_files)

    //INPUT_CHECK.out.reads.view()

    // EXECUTE PCgx workflow
    NGS_PIPELINE(INPUT_CHECK.out.reads, ch_fasta, ch_target_star_alleles_panel, ch_target_no_star_alleles_panel, ch_target_star_alleles_cnv_caller, ch_pymerge)
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
