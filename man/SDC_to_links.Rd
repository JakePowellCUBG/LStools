% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Sankey_functions.R
\name{SDC_to_links}
\alias{SDC_to_links}
\title{Statistical disclosure to sankey}
\usage{
SDC_to_links(links, round_to = 5, issue_level = 5)
}
\arguments{
\item{links}{links of a sankey diagram}

\item{round_to}{number to round to}

\item{issue_level}{number, where links with fewer students have their value omitted (set to "Below issue_level").}
}
\value{
vector containing the links after performing SDC
}
\description{
Statistical disclosure to sankey
}
