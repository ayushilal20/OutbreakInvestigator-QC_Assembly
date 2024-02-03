F1 - 6 students
# Planning Presentation
### General
- Slide 9: You forgot to list PhiX removal. Currently, there's no strategy listed to accomplish this essential task. You'll need to identify a package that does this and implement it during read cleaning for each sample. It's not a replacement for quality trimming, so it has to be ran in addition to the other listed tools.
- You can skip Trim Galore, it isn't worth even assessing anymore.
- Assembly with Canu won't work for Illumina - you would need Oxford Nanopore Technologies (ONT) or Pacific Biosciences (PacBio)
- Replace MaSuRCA assembler with something newer, especially if you find something within the past year first released.
- Contig filtering post-assembly:  for Illumina command-line assemblers, you'll always end up with extra contigs (especially contigs roughly the size of the imput read sizes) you need to discard prior to downstream use of the assembly. If you can setup a python 2.7 with biopython env, feel free to use mine filter.contigs.py and check out all the sweet stats it gives :)
- Why would you need Quast-LG instead of just Quast for bacterial (*not* large Eukaryote sized genomes)?

### Specific Task Delegations
- ++ Wow, terrific, only group to list internal deadlines!

