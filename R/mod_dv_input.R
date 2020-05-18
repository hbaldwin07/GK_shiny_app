# Module UI
  
#' @title   mod_dv_input_ui and mod_dv_input_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_dv_input
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_dv_input_ui <- function(id){
  ns <- NS(id)
  tagList(
  
  )
}
    
# Module Server
    
#' @rdname mod_dv_input
#' @export
#' @keywords internal
    
mod_dv_input_server <- function(input, output, session){
  ns <- session$ns
}
    
## To be copied in the UI
# mod_dv_input_ui("dv_input_ui_1")
    
## To be copied in the server
# callModule(mod_dv_input_server, "dv_input_ui_1")
 
