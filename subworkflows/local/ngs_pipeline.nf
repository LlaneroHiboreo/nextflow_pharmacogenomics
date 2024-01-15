include { CREATE_INPUT_VCF               } from '../../modules/local/pypgx/create_input_vcf'
include { PREPARE_DEPTH_COVERAGE         } from '../../modules/local/pypgx/prepare_depth_coverage'
include { COMPUTE_CONTROL_STATISTICS     } from '../../modules/local/pypgx/compute_control_statistics'
include { RUN_NGS_PIPELINE as RUN_NGS_PIPE_STAR_ALLELES         } from '../../modules/local/pypgx/run_ngs_pipeline'
include { RUN_NGS_PIPELINE as RUN_NGS_PIPE_NO_STAR_ALLELES      } from '../../modules/local/pypgx/run_ngs_pipeline'
include { TABIX_TABIX                    } from '../../modules/nf-core/tabix/tabix/main'                                                                           
include { GATHER_RESULTS                 } from '../../modules/local/pypgx/gather_results'

workflow NGS_PIPELINE{
    take:
        bam_alignment
        reference_fasta
        panels
        na_panels
        cnv_callers
        pymerge
    main:
        // initialize channel to gather versions
        ch_versions = Channel.empty()

        // MODULE: PREPARE VCF from BAM && create index
        CREATE_INPUT_VCF(bam_alignment, reference_fasta)
        TABIX_TABIX(CREATE_INPUT_VCF.out.vcf)
        ch_vcf_tbi = CREATE_INPUT_VCF.out.vcf.join(TABIX_TABIX.out.tbi)

        // MODULE: PREPARE DEPTH OF COVERAGE from BAM
        PREPARE_DEPTH_COVERAGE(bam_alignment)

        // MODULE: COMPUTE CONTROL STATS
        COMPUTE_CONTROL_STATISTICS(bam_alignment)

        ch_generated_files = ch_vcf_tbi.join(PREPARE_DEPTH_COVERAGE.out.coverage).join(COMPUTE_CONTROL_STATISTICS.out.stats)

        // MODULE: EXECUTE NGS PIPELINE with STAR ALLELES
        //gather gene databases into same channel
        ch_panel_cnv = panels.join(cnv_callers)

        ch_generated_files_panel_cnv = ch_generated_files.combine(ch_panel_cnv)
        //ch_generated_files_panel_cnv.view()
        RUN_NGS_PIPE_STAR_ALLELES(ch_generated_files_panel_cnv)
        
        // MODULE: RUN NGS PIPELINE with NO STAR ALLELES
        // PREPARE INPUT without CNV for genes 
        ch_panels = na_panels.map{meta,vcf,tbi->
            [meta,vcf,tbi,[]]
        }
        ch_generated_files_panel = ch_generated_files.combine(ch_panels)

        RUN_NGS_PIPE_NO_STAR_ALLELES(ch_generated_files_panel)

        ch_gather_results_ngs = RUN_NGS_PIPE_STAR_ALLELES.out.ngs.groupTuple()
        ch_gather_results_na_ngs = RUN_NGS_PIPE_NO_STAR_ALLELES.out.ngs.groupTuple()

        // MODULE: Gather results from STAR ALLELES into same file
        GATHER_RESULTS(ch_gather_results_ngs, ch_gather_results_na_ngs, pymerge.first())

    emit:
        ch_versions
}