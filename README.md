# nextflow_pharmacogenomics
Pipeline for pharmacogenomics research based on PyPGx package

## Overview
This document describes the usage of a Nextflow workflow designed for running pharmacogenomics analysis. This workflow is configured to be run with Singularity containers, ensuring reproducibility across different computing environments.

## Prerequisites
- Nextflow >=22.10.1
- Singularity

## Installation
Clone this repository:
```bash
git clone this repository URL
cd  nextflow_pharmacogenomics
```

## Parameters Description
- --outdir results: Specifies the output directory where the results will be saved.
- --input Path to the input CSV file containing sample information. The format should include columns for sample, BAM file, and BAM index file.
- --fasta Path to the reference genome in FASTA format.
- --panel_files Path to the VCF files used for variant calling or analysis.
- --panel_indexes Path to the index files for the VCF files.
- --star_alleles_list [list of genes]: Specifies a list of genes for which star alleles are to be called.
- --no_star_alleles_list [list of genes]: Specifies a list of genes for which star alleles are not to be called.
- --cnv_caller_files Path to CNV caller files, typically in ZIP format.

The VCF Panel files and CNV caller files can be obtained from [here](https://pypgx.readthedocs.io/en/latest/).The list of alleles to use against the analysis can be found [here](https://pypgx.readthedocs.io/en/latest/genes.html)


## Running the Workflow
To successfully run the workflow, different input parameters are required:

```bash
nextflow run main.nf \
-c custom.config \
-profile singularity \
--outdir results \
--input assets/samplesheet.csv \
--fasta /path/to/reference.fasta \
--panel_files '/path/to/pypgx-bundle/1kgp/GRCh38/*.vcf.gz' \
--panel_indexes '/path/to/pypgx-bundle/1kgp/GRCh38/*.vcf.gz.tbi' \
--star_alleles_list CYP2A6,CYP2B6,CYP2D6,CYP2E1,CYP4F2,G6PD,GSTM1,SLC22A2,SULT1A1,UGT1A4,UGT2B15,UGT2B17 \
--no_star_alleles_list ABCB1,ABCG2,CACNA1S,CFTR,CYP1A1,CYP1A2,CYP1B1,CYP2A13,CYP2C8,CYP2C9,CYP2C19,CYP2F1,CYP2J2,CYP2R1,CYP2S1,CYP2W1,CYP3A4,CYP3A5,CYP3A7,CYP3A43,CYP4A11,CYP4A22,CYP4B1,CYP17A1,CYP19A1,CYP26A1,DPYD,F5,GSTP1,IFNL3,NAT1,NAT2,NUDT15,POR,PTGIS,RYR1,SLC15A2,SLCO1B1,SLCO1B3,SLCO2B1,TBXAS1,TPMT,UGT1A1,UGT2B7,VKORC1,XPC \
--cnv_caller_files '/path/to/PYPGX/pypgx-bundle/cnv/GRCh38/*.zip' \
-w work
```
## Input Files
The format of the input file (samplesheet.csv) should contain the following header:

- sample: name of the experiment
- bam: path to the aligned read
- bai: path to the indexed aligned read

