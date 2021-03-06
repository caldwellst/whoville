% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/codes.R
\name{valid_codes}
\alias{valid_codes}
\title{Check if country codes are present in \code{countries} data frame.}
\usage{
valid_codes(codes, type = "iso3")
}
\arguments{
\item{codes}{Character vector of country codes.}

\item{type}{A character value specifying the type of country code supplied.
All possible values available through \code{country_code_types()}.}
}
\value{
Logical vector.
}
\description{
\code{valid_codes()} takes in a vector of country codes and returns a logical vector
on whether that country code is present in \code{countries[["iso3"]]}
}
