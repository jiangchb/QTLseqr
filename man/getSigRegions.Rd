% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/export_functions.R
\name{getSigRegions}
\alias{getSigRegions}
\title{Return SNPs in significant regions}
\usage{
getSigRegions(SNPset, alpha = 0.05)
}
\arguments{
\item{SNPset}{Data frame SNP set containing previously filtered SNPs}

\item{alpha}{the required false discovery rate alpha}
}
\description{
The function takes a SNP set after calculation of p- and q-values and returns 
a list containing all SNPs with q-values below a set alpha. Each entry in the list
is a SNP set data frame in a contiguous region with adjusted pvalues lower 
than the set false discovery rate alpha.
}
