# Module UI
  
#' @title   mod_dl_model_ui and mod_dl_model_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_dl_model
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_dl_model_ui <- function(id){
  ns <- NS(id)
  tagList(
  
  )
}
    
# Module Server
    
#' @rdname mod_dl_model
#' @export
#' @keywords internal
    
mod_dl_model_server <- function(input, output, session){
  ns <- session$ns
}
    
## To be copied in the UI
# mod_dl_model_ui("dl_model_ui_1")
    
## To be copied in the server
# callModule(mod_dl_model_server, "dl_model_ui_1")
 
