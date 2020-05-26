# Module UI
  
#' @title   mod_cmodel_dir_ui and mod_cmodel_dir_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_cmodel_dir
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_cmodel_dir_ui <- function(id){
  ns <- NS(id)
  tagList(
    # shinyFiles::shinyDirButton(ns("dir"), "Input directory", "Upload"),
    # verbatimTextOutput(ns("dir"), placeholder = TRUE)  
    fluidRow(
      fileInput(ns("file"), 'Select Training RDS Files',multiple = TRUE)
  ))
}
    
# Module Server
    
#' @rdname mod_cmodel_dir
#' @export
#' @keywords internal
    
mod_cmodel_dir_server <- function(input, output, session, r){
  ns <- session$ns
  r$model = reactiveValues()
  
  shinyFiles::shinyDirChoose(
    input,
    'dir',
    roots = c(home = '~')
    #,filetypes = c('')
  )
  
  global <- reactiveValues(datapath = getwd())
  dir <- reactive(input$dir)
  
  output$dir <- renderText({
    global$datapath
  })
  
  observeEvent(ignoreNULL = TRUE, eventExpr = {
    input$dir},
    handlerExpr = {
      if (!"path" %in% names(dir())) {
        return()
      }
      home <- normalizePath("~")
      global$datapath <-
        file.path(home, paste(unlist(dir()$path[-1]), collapse = .Platform$file.sep))
    })
  observe({
    r$model$path = global$datapath
    #browser()
  })
  
  # observeEvent(
  #   ignoreNULL = TRUE,
  #   eventExpr = {input$directory},
  #   handlerExpr = {
  #     if (input$directory>0) {
  #       path = shinyDirectoryInput::choose.dir(default=shinyDirectoryInput::readDirectoryInput(session, "directory"))
  #       shinyDirectoryInput::updateDirectoryInput(session, 'directory', value = path)
  #       r$model$path = path
  #     }
  #   }
  #   )
}
    
## To be copied in the UI
# mod_cmodel_dir_ui("cmodel_dir_ui_1")
    
## To be copied in the server
# callModule(mod_cmodel_dir_server, "cmodel_dir_ui_1")
 
