
<!-- README.md is generated from README.Rmd. Please edit that file -->
QTLseqr v0.5.8
==============

QTLseqr is an R package for QTL mapping using NGS Bulk Segregant Analysis.

QTLseqr is still under development and is offered with out any guarantee.

Installation
============

<!-- You can install and update QTLseqr by using our [drat](http://dirk.eddelbuettel.com/code/drat.html) repository hosted on our github page: -->
<!-- ```{r drat-install, eval = FALSE} -->
<!-- install.packages("QTLseqr", repos = "http://bmansfeld.github.io/drat") -->
<!-- ``` -->
<!-- OR You can install QTLseqr from github with: -->
You can install QTLseqr from github with:

``` r
# install devtools first to download packages from github
install.packages("devtools")

# use devtools to install QTLseqr
devtools::install_github("bmansfeld/QTLseqr")
```

**Note:** Apart from regular package dependencies, there are some Bioconductor tools that we use as well, as such you will be prompted to install support for Bioconductor, if you haven't already. QTLseqr makes use of C++ to make some tasks significantly faster (like counting SNPs). Because of this, in order to install QTLseqr from github you will be required to install some compiling tools (Rtools and Xcode, for Windows and Mac, respectively).

### For updates read the [NEWS.md](https://github.com/bmansfeld/QTLseqr/blob/master/NEWS.md)

**If you use QTLseqr in published research, please cite:**

> Mansfeld B.N. and Grumet R, QTLseqr: An R package for bulk segregant analysis with next-generation sequencing *bioRxiv* 208140; doi: <https://doi.org/10.1101/208140>

Abstract
--------

Since the early 1990’s, Bulk Segregant Analysis (BSA) has been a valuable tool for rapidly identifying markers in a genomic region associated with a trait of interest. BSA is amenable to any type of codominant markers, including single nucleotide polymorphism (SNP) markers. This has allowed for the adaptation of this technology for use with next-generation sequencing (NGS) reads. SNPs detected in reads aligning to genomic regions closely linked to the trait should deviate from the expected ~50% representation observed in non-linked regions. In the past several years, the main pipeline used for NGS-BSA for plant breeding research was QTL-seq. While this approach has been widely used in several crops for many traits, the released pipeline has not been updated in several years, and as a result software and version incompatibility issues have arisen. This limits the widespread utilization of this otherwise well-designed pipeline. While an alternate approach for evaluating statistical significance of QTL from NGS-BSA based on a tricube-smoothed G statistic exists, a software implementation was never developed or distributed. We thus present “QTLseqr”, an R package for NGS-BSA, that incorporates both methods above. QTLseqr, can quickly import and filter SNP data from the Genome Analysis Tool Kit (GATK) pipeline, then calculate and plot SNP distributions, relative allele frequencies, the tricube-smoothed G values, as well as log10(p-values). This allows for easy plotting and identification of QTL regions.

The package is an R implementation of the analysis described in The Statistics of Bulk Segregant Analysis Using Next Generation Sequencing Magwene PM, Willis JH, Kelly JK (2011) The Statistics of Bulk Segregant Analysis Using Next Generation Sequencing. PLOS Computational Biology 7(11): e1002255. doi: [10.1371/journal.pcbi.1002255](http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1002255)

It also incorperates Δ(SNP-index) type analysis as described by Takagi, Hiroki, et al. "QTL‐seq: rapid mapping of quantitative trait loci in rice by whole genome resequencing of DNA from two bulked populations." The Plant Journal 74.1 (2013): 174-183. [doi:10.1111/tpj.12105](http://onlinelibrary.wiley.com/doi/10.1111/tpj.12105/full)

Example
-------

### **For more detailed instructions please read the vignette [here](https://drive.google.com/file/d/0B3wMyxzoUzkVOFFmN1VtZjdlV28/view?usp=sharing)**

This is a basic example which shows you how to import and analyze NGS-BSA data.

``` r

#load the package
library("QTLseqr")

#Set sample and file names
HighBulk <- "SRR834931"
LowBulk <- "SRR834927"
file <- "SNPs_from_GATK.table"

#Choose which chromosomes will be included in the analysis (i.e. exclude smaller contigs)
Chroms <- paste0(rep("Chr", 12), 1:12)

#Import SNP data from file
df <-
    importFromGATK(
        file = file,
        highBulk = HighBulk,
        lowBulk = LowBulk,
        chromList = Chroms
     )

#Filter SNPs based on some criteria
df_filt <-
    filterSNPs(
        SNPset = df,
        refAlleleFreq = 0.20,
        minTotalDepth = 100,
        maxTotalDepth = 400,
        minSampleDepth = 40,
        minGQ = 99
    )


#Run G' analysis
df_filt <- runGprimeAnalysis(
    SNPset = df_filt,
    windowSize = 1e6,
    outlierFilter = "deltaSNP")

#Plot
plotQTLStats(SNPset = df_filt, var = "deltaSNP", plotThreshold = TRUE, q = 0.01)
plotQTLStats(SNPset = df_filt, var = "Gprime", plotThreshold = TRUE, q = 0.01)

#export summary CSV
getQTLTable(SNPset = df_filt, alpha = 0.01, export = TRUE, fileName = "my_BSA_QTL.csv")
```
