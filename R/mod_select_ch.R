# Module UI
  
#' @title   mod_select_ch_ui and mod_select_ch_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_select_ch
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_select_ch_ui <- function(id){
  ns <- NS(id)
  tagList(
    selectInput(ns("DAPI"), "Dapi:",  c("ch1", "ch2", "ch3", "ch4")), 
    selectInput(ns("GFP"), "Pheno:", c("ch1", "ch2", "ch3", "ch4"))
  )
}
    
# Module Server
    
#' @rdname mod_select_ch
#' @export
#' @keywords internal
    
mod_select_ch_server <- function(input, output, session, r){
  ns <- session$ns
  r$mod3 <- reactiveValues()
  observe({
    r$mod3$DAPI <- input$DAPI
    r$mod3$GFP <- input$GFP})
}
    
## To be copied in the UI
# mod_select_ch_ui("select_ch_ui_1")
    
## To be copied in the server
# callModule(mod_select_ch_server, "select_ch_ui_1")
 
