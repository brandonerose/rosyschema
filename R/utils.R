#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr:pipe]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
#' @param lhs A value or the magrittr placeholder.
#' @param rhs A function call using the magrittr semantics.
#' @return The result of calling `rhs(lhs)`.
NULL

pkg_name<-.packageName
pkg_version<-as.character(utils::packageVersion(.packageName))
pkg_date<-Sys.Date()

#' Columns wrappers
#'
#' These are convenient wrappers around
#' `column(12, ...)`, `column(6, ...)`, `column(4, ...)`...
#'
#' @noRd
#'
#' @importFrom shiny column
col_12 <- function(...) {
  column(12, ...)
}

#' @importFrom shiny column
col_10 <- function(...) {
  column(10, ...)
}

#' @importFrom shiny column
col_8 <- function(...) {
  column(8, ...)
}

#' @importFrom shiny column
col_6 <- function(...) {
  column(6, ...)
}


#' @importFrom shiny column
col_4 <- function(...) {
  column(4, ...)
}


#' @importFrom shiny column
col_3 <- function(...) {
  column(3, ...)
}


#' @importFrom shiny column
col_2 <- function(...) {
  column(2, ...)
}


#' @importFrom shiny column
col_1 <- function(...) {
  column(1, ...)
}

make_table<-function(DF){
  DT::datatable(DF,
                selection = 'single',
                editable = F,
                rownames = F,
                # extensions = 'Buttons',
                options = list(
                  columnDefs = list(list(className = 'dt-center',targets = "_all")),
                  paging = T,
                  fixedColumns = TRUE,
                  ordering = TRUE,
                  scrollY = "500px",
                  scrollX = T,
                  # autoWidth = T,
                  # searching = T,
                  # dom = 'Bfrtip',
                  # buttons = c('csv', 'excel',"pdf"),
                  scrollCollapse = T,
                  stateSave = F
                ),
                class = "cell-border",
                filter = 'top',
                escape =F
  )
}
