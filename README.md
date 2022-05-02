
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pipediff

Show diff between piped steps using Brodie Gaslam’s {diffobj} package.

## Installation

Install with:

``` r
remotes::install_github("moodymudskipper/pipediff")
```

## Example

``` r
library(dplyr, warn = FALSE)
pipediff::pipediff()
starwars %>%
  group_by(species) %>%
  summarise(n = n(), mass = mean(mass, na.rm = TRUE)) %>%
  filter(n > 1, mass > 50)  %>%
  mutate(mass = round(mass)) %>%
  as.data.frame() %>%
  nrow()
```

![nomnoml](man/figures/pipediff.gif) `pipediff()` Overrides the pipe
`%>%` in the caller environment, the newly created pipe displays in the
viewer the diffs between steps, then self destruct (so `pipediff()`
works “only once”, a bit like \`debugonce()).

`pipediff(once = FALSE)` makes the change permanent in the caller
environment until `pipediff::pipereset()` is called.
