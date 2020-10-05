# Module UI

#' @title   mod_ph_segment_ui and mod_ph_segment_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_ph_segment
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_ph_segment_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      # column(4, plotOutput(ns("cell_norm"))),
      # column(4, plotOutput(ns("mask"))),
      # column(4, plotOutput(ns("omask")))
      h5("Local Mask", align="center"),
      column(6, plotOutput(ns("mask"))),
      h5("Global Mask", align="center"),
      column(6, plotOutput(ns("omask")))
    ),
    #fluidRow(h4("Final Segmentation")),
    br(),
    fluidRow(
      h5("Final Seg: color masks", align="center"),
      column(6, plotOutput(ns("color"))),
      h5("Final Seg: overaly", align="center"),
      column(6, plotOutput(ns("outline")))
      #, br(), 
      #sliderInput(ns("int"), "Image Intensity:", 1,100,10, step=5)))
    )
  )
}

# Module Server

#' @rdname mod_ph_segment
#' @export
#' @keywords internal

mod_ph_segment_server <- function(input, output, session, r, params, ph_norm, nseg){
  ns <- session$ns
  cell_norm <- reactive({
    cell_norm= ph_norm()*params()$ph_int
  })
  
  cmask <- reactive({
    filter <- as.numeric(params()$ph_filter)
    wh <- as.numeric(params()$ph_wh)
    gm <- as.numeric(params()$ph_gm)
    smooth <- makeBrush(size=filter, shape = "disc")
    c_norm <-filter2(cell_norm(), smooth, boundary = c("circular", "replicate"))
    thr_cell<-thresh(c_norm, wh, wh, gm)
    cmask = opening(thr_cell, kern=makeBrush(7,shape="disc"))
  })
  omask <- reactive({
    global <- params()$ph_global
    omask<-opening(cell_norm()>global)
  })
  cell_seg <- reactive({
    size_s <- params()$ph_size_s
    size_l <- params()$ph_size_l
    combine <- cmask()
    #n_seg <- imageData(nseg)
    # combine[omask()>cmask()] <- omask()[omask()>cmask()]
    # combine[nseg > combine] <- nseg[nseg>combine]
    # cseg = propagate(cell_norm(), nseg, mask=combine)
    #browser()
    combine[omask()>cmask()] <- omask()[omask()>cmask()]
    combine[nseg() > combine] <- nseg()[nseg()>combine]
    cseg = propagate(cell_norm(), nseg(), mask=combine)
    cseg <- fillHull(cseg)
    xy <- computeFeatures.moment(cseg)[,c('m.cx', 'm.cy')]
    cf <- computeFeatures.shape(cseg)
    cr <- which(cf[,2] < size_s)
    cseg = rmObjects(cseg, cr)
    cf2 <- computeFeatures.shape(cseg)
    cr2 <- which(cf2[,1] > size_l)
    cseg = rmObjects(cseg, cr2)
    dims <- dim(cseg)
    border <- c(cseg[1:dims[1],1], cseg[1:dims[1],dims[2]], cseg[1,1:dims[2]], cseg[dims[1],1:dims[2]])
    ids <- unique(border[which(border!=0)])
    cell_seg <- rmObjects(cseg, ids)
  })
  # seg_out <- reactive({
  #   seg_out = paintObjects(cell_seg(),toRGB(cell_norm()),opac=c(1, 1),col=c("yellow",NA),thick=TRUE,closed=TRUE)
  # })
  # output$cell_norm <- renderPlot({
  #   plot(cell_norm())
  #   #mtext("Phenotype Channel", side=3, cex=1.5)
  # })
  output$mask <- renderPlot({
    par(mar=c(3, 3, 3, 3))
    plot(cmask())
    mtext("Mask:", side=3, line=1, cex=1.5)
    mtext("Individual Cells", side=3)
  })
  output$omask <- renderPlot({
    par(mar=c(3, 3, 3, 3))
    plot(omask())
    mtext("Mask:", side=3, line=1, cex=1.5)
    mtext("Global Outline", side=3)
  })
  output$color <- renderPlot({
    par(mar=c(3, 3, 3, 3))
    plot(colorLabels(cell_seg()))
    mtext("Final Seg", side=3, line=1, cex=1.25)
    mtext("Color Label", side=3)
  })
  output$outline <- renderPlot({
    par(mar=c(3, 3, 3, 3))
    seg_out = paintObjects(cell_seg(),toRGB(cell_norm()),opac=c(1, 1),col=c("yellow",NA),thick=TRUE,closed=TRUE)
    #plot(seg_out())
    plot(seg_out)
    mtext("Final Seg", side=3, line=1, cex=1.25)
    mtext("Outline", side=3)
  })
  
  return(cell_seg)
}

## To be copied in the UI
# mod_ph_segment_ui("ph_segment_ui_1")

## To be copied in the server
# callModule(mod_ph_segment_server, "ph_segment_ui_1")