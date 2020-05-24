# Module UI
  
#' @title   mod_img_dir_ui and mod_img_dir_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_img_dir
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_img_dir_ui <- function(id){
  ns <- NS(id)
  tagList(
    shinyDirectoryInput::directoryInput(ns('directory'), label = 'select a directory')
  )
}
    
# Module Server
    
#' @rdname mod_img_dir
#' @export
#' @keywords internal
    
mod_img_dir_server <- function(input, output, session, r){
  ns <- session$ns
  r$img_dir = reactiveValues()
  
  # ##DEV MODE ONLY##
  # observe({
  #   r$img_dir$path = "~/Documents/test_tifs/"
  # })
  # ##
  
  observeEvent(
    ignoreNULL = TRUE,
    eventExpr = {input$directory},
    handlerExpr = {
      if (input$directory>0) {
        path = shinyDirectoryInput::choose.dir(default=shinyDirectoryInput::readDirectoryInput(session, "directory"))
        shinyDirectoryInput::updateDirectoryInput(session, 'directory', value = path)
        r$img_dir$path = path
      }
    }
    )
}


  # observeEvent(
  #   eventExpr = {input$directory}, 
  #   handlerExpr = {
  #     if (input$directory > 0 ) {
  #       path = shinyDirectoryInput::choose.dir(default = shinyDirectoryInput::readDirectoryInput(session, "directory"))
  #       shinyDirectoryInput::updateDirectoryInput(session, 'directory', value = path)
  #       filenames <- reactive({
  #         filenames = dir(paste0(path)[grep(".tif", dir(paste0(path)))])
  #       })
  #       r$load_img$files = filenames()
  #       output$test <- renderText({
  #         paste0(r$load_img$files)
  #       })
  #     }
  #     
  #   }
  # )
#}
    
## To be copied in the UI
# mod_img_dir_ui("img_dir_ui_1")
    
## To be copied in the server
# callModule(mod_img_dir_server, "img_dir_ui_1")
 
