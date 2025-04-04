% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prepare_data.R
\name{prepare_data}
\alias{prepare_data}
\title{Function to prepare the data to be displaysed with a reactable}
\usage{
prepare_data(
  data,
  filter_date,
  filter_price,
  filter_location,
  filter_group,
  filter_artist,
  filter_album,
  filter_genre,
  filter_type
)
}
\arguments{
\item{data}{Data to be prepare}

\item{filter_date}{Shiny filter on date}

\item{filter_price}{Shiny filter on price}

\item{filter_location}{Shiny filter on location}

\item{filter_group}{Shiny filter on group}

\item{filter_artist}{Shiny filter on artist}

\item{filter_album}{Shiny filter on album}

\item{filter_genre}{Shiny filter on genre}

\item{filter_type}{Shiny filter on type}
}
\value{
a dataframe filtered with the Shiny inputs
}
\description{
Function to prepare the data to be displaysed with a reactable
}
