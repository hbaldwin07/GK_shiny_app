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
    shinyDirectoryInput::directoryInput(ns('directory'), label = 'select a directory', value="~")
  )
}
    
# Module Server
    
#' @rdname mod_cmodel_dir
#' @export
#' @keywords internal
    
mod_cmodel_dir_server <- function(input, output, session, r){
  ns <- session$ns
  r$model = reactiveValues()
  observeEvent(
    ignoreNULL = TRUE,
    eventExpr = {input$directory},
    handlerExpr = {
      if (input$directory>0) {
        path = shinyDirectoryInput::choose.dir(default=shinyDirectoryInput::readDirectoryInput(session, "directory"))
        shinyDirectoryInput::updateDirectoryInput(session, 'directory', value = path)
        r$model$path = path
      }
    }
    )
}
    
## To be copied in the UI
# mod_cmodel_dir_ui("cmodel_dir_ui_1")
    
## To be copied in the server
# callModule(mod_cmodel_dir_server, "cmodel_dir_ui_1")
 
