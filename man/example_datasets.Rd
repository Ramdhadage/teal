% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dummy_functions.R
\name{example_datasets}
\alias{example_datasets}
\title{Get datasets to go with example modules.}
\usage{
example_datasets()
}
\value{
named list of \code{FilteredData} objects, each with \code{ADSL} set.
}
\description{
Creates a nested list, the structure of which matches the module hierarchy created by \code{example_modules}.
Each list leaf is the same \code{FilteredData} object.
}
\keyword{internal}
