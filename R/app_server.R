#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic -----

  values<-reactiveValues()
  values$S<-load_cache()
  values$table<-NULL
  values$column<-NULL
  values$choice<-NULL
  #tables-----
  output$TABLES_all <- output$TABLES<-DT::renderDT({
    values$S$tables %>% make_table()
  })
  output$COLUMNS<-DT::renderDT({
    values$S$columns[which(values$S$columns$table==values$table),] %>% make_table()
  })
  output$CHOICES<-DT::renderDT({
    values$S$choices[which(values$S$choices$column==values$S$columns$column[input$COLUMNS_rows_selected]),] %>% make_table()
  })

  output$COLUMNS_all<-DT::renderDT({
    values$S$columns %>% make_table()
  })
  output$CHOICES_all<-DT::renderDT({
    values$S$choices %>% make_table()
  })
  #observe------


  observe({
    values$table<-values$S$tables$table[input$TABLES_rows_selected]
    values$column<-values$S$columns$column[which(values$S$columns$table==values$table)][input$COLUMNS_rows_selected]
    values$choice<-values$S$choices$choice[which(values$S$choices$column==values$column)][input$CHOICES_rows_selected]
  })

  observe({
    updateSelectInput(session,"column_type",selected = values$S$columns$type[which(values$S$columns$table==values$table)][input$COLUMNS_rows_selected])
  })
  observe({
    updateTextInput(session,"column",value = values$S$columns$column[which(values$S$columns$table==values$table)][input$COLUMNS_rows_selected])
  })
  observe({
    updateTextInput(session,"column_name",value = values$S$columns$name[which(values$S$columns$table==values$table)][input$COLUMNS_rows_selected])
  })
  observe({
    updateTextInput(session,"choice",value = values$S$choices$choice[which(values$S$choices$column==values$column)][input$CHOICES_rows_selected])
  })
  observe({
    updateTextInput(session,"choice_name",value = values$S$choices$name[which(values$S$choices$column==values$column)][input$CHOICES_rows_selected])
  })
  observe({
    values$S %>% save_cache()
    values$S %>% save_cache()

  })
  #observeevent add ------

  observeEvent(input$add_table,ignoreInit = T,{
    values$S$tables<-values$S$tables %>% dplyr::bind_rows(
      data.frame(
        table=input$table_name %>% trimws() %>% toupper()
      )
    ) %>% unique()
  })
  observeEvent(input$add_column,ignoreInit = T,{
    values$S$columns<-values$S$columns[which(!(values$S$columns$table==values$table&values$S$columns$column==input$column)),] %>% dplyr::bind_rows(
      data.frame(
        table=values$table,
        column= input$column %>% trimws(),
        name= input$column_name %>% trimws(),
        type= input$column_type,
        ordered= ifelse(purrr::is_empty(input$column_ordered),NA,input$column_ordered)
      )
    ) %>% unique()
  })
  observeEvent(input$add_choice,ignoreInit = T,{
    values$S$choices<-values$S$choices[which(!(values$S$choices$table==values$table&values$S$choices$column==values$column&values$S$choices$table==input$choice)),] %>% dplyr::bind_rows(
      data.frame(
        table=values$table,
        column=values$column,
        choice= input$choice %>% trimws(),
        name= input$choice_name %>% trimws()
      )
    ) %>% unique()
  })
  #observeevent remove ------
  observeEvent(input$rem_table,ignoreInit = T,{
    x<-as.data.frame(values$S$tables[which(values$S$tables$table!=values$table),])
    colnames(x)<-values$S$tables %>% colnames()
    values$S$tables<-x
    x<-as.data.frame(values$S$columns[which(values$S$columns$table!=values$table),])
    colnames(x)<-values$S$columns %>% colnames()
    values$S$columns<-x
    x<-as.data.frame(values$S$choices[which(values$S$choices$table!=values$table),])
    colnames(x)<-values$S$choices %>% colnames()
    values$S$choices<-x
  })
  observeEvent(input$rem_column,ignoreInit = T,{
    x<-as.data.frame(values$S$columns[which(values$S$columns$column!=values$column),])
    colnames(x)<-values$S$columns %>% colnames()
    values$S$columns<-x
    x<-as.data.frame(values$S$choices[which(values$S$choices$column!=values$column),])
    colnames(x)<-values$S$choices %>% colnames()
    values$S$choices<-x
  })
  observeEvent(input$rem_choice,ignoreInit = T,{
    x<-as.data.frame(values$S$choices[which(values$S$choices$choice!=values$choice),])
    colnames(x)<-values$S$choices %>% colnames()
    values$S$choices<-x
  })

  observeEvent(input$new_list,ignoreInit = T,{
    values$S<-list(
      "tables"=data.frame(
        table=c("PATIENTS","SARCOMAS")
      ),
      "columns"=data.frame(
        table="PATIENTS",
        column="PSDB_ID",
        type="character",
        factor=T,
        ordered=T
      ),
      "choices"=data.frame(
        table=character(0),
        column=character(0),
        code=character(0),
        name=character(0)
      )
    )
  })
  #ui------
  output$column_ordered_<-renderUI({
    if(input$column_type=="factor"){
      checkboxInput("column_ordered","Ordered?",value = F)
    }
  })

  output$choice_<-renderUI({
    if(!purrr::is_empty(values$column)){
      textInput("choice","Choice")
    }
  })
  output$choice_name_<-renderUI({
    if(!purrr::is_empty(values$column)){
      textInput("choice_name","Choice Name")
    }
  })
  #text -----
  output$test <- renderText({
    values$choice
  })
}
