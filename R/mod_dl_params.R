# Module UI
  
#' @title   mod_dl_params_ui and mod_dl_params_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_dl_params
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_dl_params_ui <- function(id){
  ns <- NS(id)
  tagList(
    downloadButton(ns("parameters"), "Download Image/Segmentation Settings")
  )
}
    
# Module Server
    
#' @rdname mod_dl_params
#' @export
#' @keywords internal
    
mod_dl_params_server <- function(input, output, session, r){
  ns <- session$ns
  params <- reactive({
    #parameters.df <- as.data.frame(matrix(0,1,14))
    #parameters.df[1,] <- c(r$mod3$DAPI,  r$mod4$nuc_int, r$mod4$nuc_wh, r$mod4$nuc_gm, r$mod4$nuc_filter, r$mod4$nuc_size_s, r$mod3$GFP, r$mod6$ph_int, r$mod6$ph_wh, r$mod6$ph_gm, r$mod6$ph_filter, r$mod6$ph_global, r$mod6$ph_size_s, r$mod6$ph_size_l)
    parameters.df <- data.frame("DAPI"=c(r$mod3$DAPI), "nuc_int"=c(r$mod4$nuc_int), "nuc_wh"=c(r$mod4$nuc_wh), "nuc_gm"=c(r$mod4$nuc_gm), "nuc_filter"= c(r$mod4$nuc_filter), "nuc_size_s"=c(r$mod4$nuc_size_s),"GFP"=c(r$mod3$GFP), "ph_int"=c(r$mod6$ph_int), "ph_wh"= c(r$mod6$ph_wh), "ph_gm"=c(r$mod6$ph_gm), "ph_filter"=c(r$mod6$ph_filter), "ph_global"=c(r$mod6$ph_global), "ph_size_s"= c(r$mod6$ph_size_s), "ph_size_l"=c(r$mod6$ph_size_l))
    params <- parameters.df
  })
  output$parameters <- downloadHandler(
    filename <- function() {
      paste("table.csv", sep="_")
    },
    content <- function(file) {
      params <- params()
      write.csv(params, file)
    }
  )
}
    
## To be copied in the UI
# mod_dl_params_ui("dl_params_ui_1")
    
## To be copied in the server
# callModule(mod_dl_params_server, "dl_params_ui_1")
 
