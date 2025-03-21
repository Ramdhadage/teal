% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dummy_functions.R
\name{example_module}
\alias{example_module}
\title{An example \code{teal} module}
\usage{
example_module(label = "example teal module", filters = "all")
}
\arguments{
\item{label}{(\code{character(1)}) Label shown in the navigation item for the module. Any label possible except
\code{"global_filters"} - read more in \code{mapping} argument of \link{teal_slices}.}

\item{filters}{(\code{character}) A vector with \code{datanames} that are relevant for the item. The
filter panel will automatically update the shown filters to include only
filters in the listed datasets. \code{NULL} will hide the filter panel,
and the keyword \code{'all'} will show the filters of all datasets. \code{filters} determines also
a subset of datasets which are appended to the \code{data} argument in \code{server} function.}
}
\value{
A \code{teal} module which can be included in the \code{modules} argument to \code{\link[=init]{init()}}.
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}
}
\examples{
app <- init(
  data = teal_data(
    dataset("IRIS", iris),
    dataset("MTCARS", mtcars)
  ),
  modules = example_module()
)
if (interactive()) {
  shinyApp(app$ui, app$server)
}
}
