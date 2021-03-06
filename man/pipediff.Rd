% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pipediff.R
\name{pipediff}
\alias{pipediff}
\title{Show diff between piped steps}
\usage{
pipediff(once = TRUE)
}
\arguments{
\item{once}{\code{TRUE} by default, if \code{FALSE} the pipe is not reset so all future
pipe calls in current env will show diffs until \code{pipereset()} is called.}
}
\value{
Returns \code{NULL} invisibly, called for side effects
}
\description{
Override the pipe \verb{\%>\%} in the caller environment, the newly created pipe
displays in the viewer the diffs between steps, then self destruct.
}
\examples{
library(dplyr, warn = FALSE)
pipediff()
starwars \%>\%
  group_by(species) \%>\%
  summarise(n = n(), mass = mean(mass, na.rm = TRUE)) \%>\%
  filter(n > 1, mass > 50)  \%>\%
  mutate(mass = round(mass)) \%>\%
  as.data.frame() \%>\%
  nrow()
}
