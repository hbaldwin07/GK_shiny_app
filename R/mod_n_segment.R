# Module UI
  
#' @title   mod_n_segment_ui and mod_n_segment_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_n_segment
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_n_segment_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      column(6, plotOutput(ns("dapi_normal"))),
      column(6, plotOutput(ns("mask")))
    ),
    fluidRow(
      column(6, plotOutput(ns("color"))),
      column(6, plotOutput(ns("outline")))
    )
  )
}
    
# Module Server
    
#' @rdname mod_n_segment
#' @export
#' @keywords internal
    
mod_n_segment_server <- function(input, output, session, r, params, nuc_norm){
  ns <- session$ns
  
  dapi_norm <- reactive({
    #browser()
    dapi_norm= nuc_norm()*params()$nuc_int
  })
  
  nmask2 <- reactive({
    #browser()
    wh <- as.numeric(params()$nuc_wh)
    gm <- as.numeric(params()$nuc_gm)
    filter <- as.numeric(params()$nuc_filter)
    nmask0 = thresh(dapi_norm(), wh, wh, gm)
    mk3 = makeBrush(filter, shape= "diamond")
    nmask0 = opening(nmask0, mk3)
    nmask2 = fillHull(nmask0)
  })
  nseg <- reactive({
    size_s <- params()$nuc_size_s
    nmask = bwlabel(nmask2())
    nf = computeFeatures.shape(nmask)
    nr = which(nf[,2] < size_s)
    nseg = rmObjects(nmask, nr)
    nseg=fillHull(nseg)
  })
  seg <- reactive({
    seg = paintObjects(nseg(),toRGB(dapi_norm()),opac=c(1, 1),col=c("red",NA), thick=TRUE, closed=TRUE)
  })
  output$dapi_normal <- renderPlot({
    plot(dapi_norm()*params()$nuc_int)
    #mtext("Nucleus Channel", side=3, cex=1.5)
  })
  output$mask <- renderPlot({
    plot(nmask2())
    #mtext("Mask", side=3, cex=1.5)
  })
  output$color <- renderPlot({
    plot(colorLabels(nseg()))
    # mtext("Final Seg", side=3, line=1, cex=1.5)
    # mtext("Color Label", side=3)
  })
  output$outline <- renderPlot({
    plot(seg())
    # mtext("Final Seg", side=3, line=1, cex=1.5)
    # mtext("Outline", side=3)
  })
  return(nseg)
}
    
## To be copied in the UI
# mod_n_segment_ui("n_segment_ui_1")
    
## To be copied in the server
# callModule(mod_n_segment_server, "n_segment_ui_1")
 
