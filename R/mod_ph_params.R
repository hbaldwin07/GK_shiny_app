# Module UI
  
#' @title   mod_ph_params_ui and mod_ph_params_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_ph_params
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_ph_params_ui <- function(id){
  ns <- NS(id)
  tagList(
    actionButton(ns("reset_input"),"Reset inputs"),
    sliderInput(ns("int"),"Image Intensity:", 1,500,100, step=5),
    sliderInput(ns("wh"),"Threshold size:",1,200,100,step=1),
    sliderInput(ns("gm"),"Threshold offset:",0.0001,0.1,0.002,step=0.001),
    sliderInput(ns("filter"),"Detect local edges:",1,99,13,step=2),
    sliderInput(ns("global"), "Detect global edges:",0.01,20,1,step=0.05),
    sliderInput(ns("size_s"),"Remove small objects:",1,500,30,step=1),
    sliderInput(ns("size_l"), "Remove large objects:",10000,75000,50000,step=100)
  )
  
}
    
# Module Server
    
#' @rdname mod_ph_params
#' @export
#' @keywords internal
    
mod_ph_params_server <- function(input, output, session, r){
  ns <- session$ns
  observeEvent(input$reset_input,{
    shinyjs::reset("side-panel")
  })
  r$mod6 <- reactiveValues()
  observe({
    r$mod6$ph_int <- input$int
    r$mod6$ph_wh <- input$wh
    r$mod6$ph_gm <- input$gm
    r$mod6$ph_filter <- input$filter
    r$mod6$ph_global <- input$global
    r$mod6$ph_size_s <- input$size_s
    r$mod6$ph_size_l <- input$size_l
  })
}
## To be copied in the UI
# mod_ph_params_ui("ph_params_ui_1")
    
## To be copied in the server
# callModule(mod_ph_params_server, "ph_params_ui_1")
 
