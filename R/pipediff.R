#' Show diff between piped steps
#'
#' Override the pipe `%>%` in the caller environment, the newly created pipe
#' displays in the viewer the diffs between steps, then self destruct.
#'
#' @param once `TRUE` by default, if `FALSE` the pipe is not reset so all future
#'   pipe calls in current env will show diffs until `pipereset()` is called.
#' @return Returns `NULL` invisibly, called for side effects
#' @export
#'
#' @examples
#' library(dplyr, warn = FALSE)
#' pipediff()
#' starwars %>%
#'   group_by(species) %>%
#'   summarise(n = n(), mass = mean(mass, na.rm = TRUE)) %>%
#'   filter(n > 1, mass > 50)  %>%
#'   mutate(mass = round(mass)) %>%
#'   as.data.frame() %>%
#'   nrow()
pipediff <- function(once = TRUE) {
  pipe <- function (lhs, rhs) {
    on.exit({
      extra <-
        if(tibble::is_tibble(lhs) && tibble::is_tibble(res))
          list(n=Inf, width = Inf) else list()
      previous <-  lhs
      added_nm <- deparse(expr)[[1]]
      assign(added_nm, res)
      diff_obj_expr <- substitute(
        diffobj::diffPrint(previous, added, mode = "sidebyside", extra = extra),
        list(added = as.symbol(added_nm))
      )
      print(eval(diff_obj_expr))
      if (once) pipereset(parent.frame())
    })
    expr <- substitute(rhs)
    if (is.symbol(expr) || expr[[1]] == quote(`(`)) {
      expr <- as.call(c(expr, quote(.)))
    }
    else if (length(expr) == 1) {
      expr <- as.call(c(expr[[1]], quote(.)))
    }
    else if (expr[[1]] != quote(`{`) && !any(vapply(expr[-1],
                                                    identical, quote(.), FUN.VALUE = logical(1))) && !any(vapply(expr[-1],
                                                                                                                 identical, quote(`!!!.`), FUN.VALUE = logical(1)))) {
      expr <- as.call(c(expr[[1]], quote(.), as.list(expr[-1])))
    }
    res <- eval(expr, envir = list(. = lhs), enclos = parent.frame())
    res
  }
  assign("%>%", pipe, envir = parent.frame())
  invisible(NULL)
}

pipereset <- function(env = parent.frame()) {
  suppressWarnings(rm(list = "%>%", envir = env))
}
