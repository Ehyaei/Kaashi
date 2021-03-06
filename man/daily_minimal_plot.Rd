% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/theme.R
\name{daily_minimal_plot}
\alias{daily_minimal_plot}
\title{Plot and save tile with Daily Minimal Theme}
\usage{
daily_minimal_plot(
  tile,
  savePath,
  type = "svg",
  base_size = 9,
  background = "#EEEEEE",
  textColor = "#101010",
  base_family = "Virtuous Slab",
  dark = FALSE,
  caption = "Daily Motif \\n \\n NO. 1"
)
}
\arguments{
\item{tile}{the sf object that is a output of motif function.}

\item{savePath}{the path of save image.}

\item{type}{the output type of image}

\item{base_size}{base font size of ggplot theme}

\item{background}{the background color of plot}

\item{textColor}{the text color}

\item{base_family}{the textfont family}

\item{dark}{if True replace the background by textColor}
}
\value{

}
\description{
Plot and save tile with Daily Minimal Theme
}
\examples{
library(ggplot2)
library(Kaashi)
square = regularPolygon(6)
tile <- motif(square,n = 6,theta = 45, delta = 0.3, polyLine = F, dist = 0.1)
daily_minimal_plot(tile,"~/Desktop/motif.svg",caption = "Daily Motif \n \n NO. 1")
}
