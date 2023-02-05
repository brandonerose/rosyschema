#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinydashboard
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    shinydashboardPlus::dashboardPage(
      options = list(
        sidebarExpandOnHover = F
      ),
      header = shinydashboardPlus::dashboardHeader(
        # fixed = F,
        title = tagList(
          span(class = "logo-lg", .packageName),
          tags$a(
            href="https://thecodingdocs.com",
            target="_blank",
            tags$img(src = "www/logo.png", width="100%")
          )
        )
      ),
      sidebar = shinydashboardPlus::dashboardSidebar(
        minified = F,
        collapsed = F,

        TCD_SBH(),
        textOutput("test"),
        TCD_SBF(),
        actionButton("new_list","New List")
      ),
      body = shinydashboard::dashboardBody(
        fluidRow(
          box(
            title = h1("Tables"),
            width = 4,
            p(""),
            DT::DTOutput("TABLES"),
            fluidRow(
              col_12(textInput("table_name","Table Name"))
            ),
            fluidRow(
              col_6(actionButton("add_table","Add Table")),
              col_6(actionButton("rem_table","Remove Table"))
            )
          ),
          box(
            title = h1("Columns"),
            width = 4,
            p(""),
            DT::DTOutput("COLUMNS"),
            fluidRow(
              col_3(textInput("column","Column")),
              col_3(textInput("column_name","Column Name")),
              col_3(selectInput("column_type","Column Type",c("character","factor","date","logical"),"character")),
              col_3(uiOutput("column_ordered_"))
            ),
            fluidRow(
              col_6(actionButton("add_column","Add Column")),
              col_6(actionButton("rem_column","Remove Column"))
            )
          ),
          box(
            title = h1("Choices"),
            width = 4,
            p(""),
            DT::DTOutput("CHOICES"),
            fluidRow(
              col_6(uiOutput("choice_")),
              col_6(uiOutput("choice_name_"))
            ),
            fluidRow(
              col_6(actionButton("add_choice","Add Choice")),
              col_6(actionButton("rem_choice","Remove Choice"))
            )

          )

        ),
        fluidRow(
          box(
            title = h1("All Tables"),
            width = 4,
            p(""),
            DT::DTOutput("TABLES_all")
          ),
          box(
            title = h1("All Columns"),
            width = 4,
            p(""),
            DT::DTOutput("COLUMNS_all")
          ),
          box(
            title = h1("All Choices"),
            width = 4,
            p(""),
            DT::DTOutput("CHOICES_all")
          )

        )
      ),
      controlbar = shinydashboardPlus::dashboardControlbar(
        TCD_SBH(),
        div(style="text-align:center",p(paste0('Version: ',pkg_version))),
        div(style="text-align:center",p(paste0('Last Updated: ',pkg_date))),
        TCD_SBF(),
        fluidRow(
          column(
            12,
            p("This app is still in development."),
            p("Consider donating for more."),
            p("Contact with issues."),
            p("Consider using R package."),
            align="center"
          )
        )
      ),
      title = "DashboardPage",
      footer = TCD_NF()
    )
  )
}

#' Add external Resources to the Application
#' This function is internally used to add external
#' resources inside the Shiny application.
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(ext = 'png'),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = .packageName
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
