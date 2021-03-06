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
      column(6, 
             h5("Nucleus Channel", align="center"),
             plotOutput(ns("dapi_normal"))
             ),
      column(6, 
             h5("Mask", align="center"),
             plotOutput(ns("mask"))
             )
   ),
   br(),
   fluidRow(
     column(6, 
            h5("Final Seg: color masks", align="center"),
            plotOutput(ns("color"))
     ),
     column(6, 
            h5("Final Seg: overlay", align="center"),
            plotOutput(ns("outline"))
     )
   )
  )
}

# Module Server

#' @rdname mod_n_segment
#' @export
#' @keywords internal

mod_n_segment_server <- function(input, output, session, params, nuc_norm, r){
  ns <- session$ns
  
  dapi_norm <- reactive({
    dapi_norm= nuc_norm()*params()$nuc_int
  })
  
  nmask2 <- reactive({
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
    ws = params()$WS
    if (ws == TRUE) {
      nmask = watershed(nmask2())
    } else {
      nmask = bwlabel(nmask2())
    }
    nf = computeFeatures.shape(nmask)
    nr = which(nf[,2] < size_s)
    nseg = rmObjects(nmask, nr)
    nseg=fillHull(nseg)
  })
  seg <- reactive({
    seg = paintObjects(nseg(),toRGB(dapi_norm()),opac=c(1, 1),col=c("red",NA), thick=TRUE, closed=TRUE)
  })
  output$dapi_normal <- renderPlot({
    par(mar=c(3, 3, 3, 3))
    plot(dapi_norm())
    #mtext("Nucleus Channel", side=3, cex=1.5, line=1, outer=TRUE)
  })
  output$mask <- renderPlot({
    par(mar=c(3, 3, 3, 3))
    plot(nmask2())
    #mtext("Nucleus Mask", side=3, cex=1.5, outer=TRUE)
  })
  output$color <- renderPlot({
    par(mar=c(3, 3, 3, 3))
    plot(colorLabels(nseg()))
    #mtext("Final Seg", side=3, line=1, cex=1.5)
    #mtext("Color Label", side=3)
  })
  output$outline <- renderPlot({
    par(mar=c(3, 3, 3, 3))
    plot(seg())
    #mtext("Final Seg", side=3, line=1, cex=1.5)
    #mtext("Outline", side=3)
  })
  return(nseg)
}

## To be copied in the UI
# mod_n_segment_ui("n_segment_ui_1")

## To be copied in the server
# callModule(mod_n_segment_server, "n_segment_ui_1")

