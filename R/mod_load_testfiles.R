# Module UI
  
#' @title   mod_load_testfiles_ui and mod_load_testfiles_server
#######UNUSED SCRIPT#########

#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_load_testfiles
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_load_testfiles_ui <- function(id){
  ns <- NS(id)
  tagList(
  
  )
}
    
# Module Server
    
#' @rdname mod_load_testfiles
#' @export
#' @keywords internal
    
mod_load_testfiles_server <- function(input, output, session){
  ns <- session$ns
}
    
## To be copied in the UI
# mod_load_testfiles_ui("load_testfiles_ui_1")
    
## To be copied in the server
# callModule(mod_load_testfiles_server, "load_testfiles_ui_1")
 
