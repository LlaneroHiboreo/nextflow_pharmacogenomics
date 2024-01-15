#!/usr/bin/env python3
import os
import zipfile
import argparse
import re
# Function to extract and process the tsv file from a results.zip folder
def process_results_zip(zip_file_path, output_file, c, gene_name):
    if c == 0:
        header = None
    else:
        header = True

    with zipfile.ZipFile(zip_file_path, 'r') as zip_file:
        # Assuming there's only one tsv file in each results.zip folder
        tsv_files = [file for file in zip_file.namelist() if file.endswith('.tsv')]
        if len(tsv_files) == 1:
            tsv_file_name = tsv_files[0]
            with zip_file.open(tsv_file_name) as tsv_file:
                lines = tsv_file.read().decode('utf-8').split('\n')
                if len(lines) > 0:
                    # Get the header from the first TSV file
                    if header is None:
                        output_file.write(f"{lines[0]} \t Gene \n")
                        output_file.write(f"{lines[1]} \t {gene_name} \n")
                    else:
                        # Write the rest of the content (excluding the header) to the output file
                        for line in lines[1:]:
                            if len(line)< 3:
                                pass
                            else:
                                output_file.write(f"{line} \t {gene_name} \n")
# Function to process directories
def process_directories(directories, output_file_path):
    c = 0
    with open(output_file_path, 'w', encoding='utf-8') as output_file:
        for directory in directories:
            pattern = r'_(.*?)_pipe'
            match = re.search(pattern, directory)
            gene_name = match.group(1)
            for root, _, files in os.walk(directory):
                for file in files:
                    if file == 'results.zip':
                        results_zip_path = os.path.join(root, file)
                        process_results_zip(results_zip_path, output_file,c, gene_name)
                        c += 1

def main():
    parser = argparse.ArgumentParser()

    parser.add_argument("-rsa", "--result_star_alleles", nargs='+', help="Star alleles")
    #parser.add_argument("-rnsa", "--result_no_star_alleles", help="No star alleles")
    parser.add_argument("-o", "--output", help="Tsv output gathered")

    args = parser.parse_args()

    # Input directories where you want to search for results.zip folders
    star_files = args.result_star_alleles
    #star_list = star_files.strip('[]').split()
    input_directories = star_files

    # Output file where you want to store the information from tsv files without the header
    output_file_path = str(args.output)

    # Process the directories and store the information in the output file
    process_directories(input_directories, output_file_path)


main()