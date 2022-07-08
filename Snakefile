from os.path import join
import os

# Sets snakemake config to correct location
configfile: "config/config.yml"

# Create strain list for strain wildcard
with open("config/strain_list.txt", 'r') as f:
    strains = f.read()
    NT_STRAINS = strains.split()  # What does NT stand for?

# Create gene list for gene wildcard
with open("config/gene_list.txt", 'r') as f:
    genes = f.read()
    GENES = genes.split()

# Comment this section thoroughly. Weird deal with Gene names. Check with RC.
rule all:
    input:
        expand("config/referenceGeneMSA/{gene}_msa.faa", gene=GENES), # makeProfileHMM/makeMSA:
        expand("config/profileHMMs/{gene}.HMM", gene=GENES),
        expand(join(config["geneCoordDir"],"{strain}_geneCoord.out"), strain=NT_STRAINS),
        expand(join(config["proteinSeqDir"],"{strain}_prodigal.faa"), strain=NT_STRAINS),
        expand("workflow/out/{gene}/hmmer_output/{strain}_{gene}.hmm.out",strain=NT_STRAINS,gene=GENES),
        expand("workflow/out/{gene}/hmmer_output/{strain}_{gene}.domtblout",strain=NT_STRAINS,gene=GENES),
        expand("workflow/out/{gene}/hmmer_output/{strain}_{gene}.sto",strain=NT_STRAINS,gene=GENES),
        expand("workflow/out/{gene}/csv_summary/{strain}_{gene}_hits.csv",strain=NT_STRAINS,gene=GENES),
        expand("workflow/out/{gene}/faa_summary/{strain}_{gene}_hits.faa",strain=NT_STRAINS,gene=GENES),
        expand("workflow/out/summary_all/csv_summary/compiled_{gene}_hits.csv", gene=GENES),
        expand("workflow/out/summary_all/faa_summary/compiled_{gene}_hits.faa", gene=GENES)



# The first line must be used for the first two lines in the all rule. The second line for the rest
include:
    # "workflow/rules/makeProfileHMM.smk"
    "workflow/rules/runHMMER.smk"
