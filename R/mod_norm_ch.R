# Module UI
  
#' @title   mod_norm_ch_ui and mod_norm_ch_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_norm_ch
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_norm_ch_ui <- function(id){
  ns <- NS(id)
  tagList(
  
  )
}
    
# Module Server
    
#' @rdname mod_norm_ch
#' @export
#' @keywords internal
    
mod_norm_ch_server <- function(input, output, session, n, img, r){
  ns <- session$ns
  
  index <- reactive({
    req(n())
    N_ch = n()
    if (N_ch == "ch1") {
      x = 1
    } else if (N_ch == "ch2") {
      x = 2
    } else if (N_ch == "ch3") {
      x = 3
    } else {
      x = 4
    }
    index = as.numeric(x)
  })
  ch_normal <- reactive({
    req(img())
    size = as.numeric(dim(img()))
    ch<-img()[1:size[1],1:size[2],index()]
    #ch <- img()[,,index()]
    min<-min(as.vector(ch))
    max<-max(as.vector(ch))
    chn<-normalize(ch, ft=c(0,1),c(min,max))
    ch_normal<- chn
  })
  return(ch_normal)
}
    
## To be copied in the UI
# mod_norm_ch_ui("norm_ch_ui_1")
    
## To be copied in the server
# callModule(mod_norm_ch_server, "norm_ch_ui_1")
 
