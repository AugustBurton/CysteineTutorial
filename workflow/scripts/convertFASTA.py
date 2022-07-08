"""
converts HMMER hit output file from Stockholm format to FASTA
"""
import os.path  # Allows script to access/change local directories/files

# Biopython module must be installed. Enables transition between bioinformatics file types
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord

# Sys gives access to variables maintained by interpreter, including variables passed to script
import sys

output_msa = sys.argv[1]  # HMMER MSA output in Stockholm format for given gene/strain search
FASTA = sys.argv[2]  # Directory in which to store FASTA conversion

basename = os.path.basename(output_msa)
genome_gene = os.path.splitext(basename)[0]

records = []
msa = SeqIO.parse(output_msa, "stockholm")
for hit in msa:
    ungapped_seq = str(hit.seq.ungap("-"))
    ungapped_seq_upper = ungapped_seq.upper()
    record = SeqRecord(
        Seq(ungapped_seq_upper),
        id=hit.id,
        description=genome_gene
        )
    records.append(record)
SeqIO.write(records, FASTA, "fasta")