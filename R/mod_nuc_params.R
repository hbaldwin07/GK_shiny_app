# Module UI
  
#' @title   mod_nuc_params_ui and mod_nuc_params_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_nuc_params
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_nuc_params_ui <- function(id){
  ns <- NS(id)
  tagList(
    h4("Segmentation Parameters"),
    actionButton(ns("reset_input"),"Reset inputs"),
    sliderInput(ns("int"), "Image Intensity:", 1,500,100, step=5),
    sliderInput(ns("wh"),"Threshold size:",1,200,100,step=1),
    sliderInput(ns("gm"),"Threshold offset:",0.0001,0.1,0.002,step=0.001),
    sliderInput(ns("filter"),"Detect nuclei edges:",1,99,13,step=2),
    sliderInput(ns("size_s"),"Remove small objects:",1,500,30,step=1)
  )
}
    
# Module Server
    
#' @rdname mod_nuc_params
#' @export
#' @keywords internal
    
mod_nuc_params_server <- function(input, output, session, r){
  ns <- session$ns
  r$mod4 <- reactiveValues()
  observeEvent(input$reset_input,{
    shinyjs::reset("side-panel")
  })
  observe({
    r$mod4$nuc_int <- input$int
    r$mod4$nuc_wh <- input$wh
    r$mod4$nuc_gm <- input$gm
    r$mod4$nuc_filter <- input$filter
    r$mod4$nuc_size_s <- input$size_s
  })
}
    
## To be copied in the UI
# mod_nuc_params_ui("nuc_params_ui_1")
    
## To be copied in the server
# callModule(mod_nuc_params_server, "nuc_params_ui_1")
 
