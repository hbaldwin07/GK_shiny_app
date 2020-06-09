# Module UI

#' @title   mod_classify_ui and mod_classify_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_classify
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_classify_ui <- function(id){
  ns <- NS(id)
  tagList(
    
    fluidRow(
      plotOutput(ns("image"), click=ns("plot_click"), width="500px", height="500px"),
      sliderInput(ns("int"), "Image Intensity:",1,500,100, step=1)
    )
    
  )
}

# Module Server

#' @rdname mod_classify
#' @export
#' @keywords internal

mod_classify_server <- function(input, output, session, r, img, cell_seg, ph_norm, classify){
  ns <- session$ns
  #browser()
  
  output$text2 <- renderText({
    if (classify()=="pos") {
      text2 = "Select Positive Examples"
    } else {text2 = "Select Negative Examples"}
  })
  
  seg_out <- reactive({
    seg_out = paintObjects(cell_seg(),toRGB(ph_norm()*input$int),opac=c(1, 1),col=c("yellow",NA),thick=TRUE,closed=TRUE)
    #seg_out = paintObjects(cell_seg,toRGB(ph_norm*r$int),opac=c(1, 1),col=c("yellow",NA),thick=TRUE,closed=TRUE)
    #seg_out = paintObjects(cell_seg(),toRGB(ph_norm()*r$int),opac=c(1, 1),col=c("yellow",NA),thick=TRUE,closed=TRUE)
  })
  
  initX <-1
  initY <-2
  source_coords <- reactiveValues(xy=c(x=initX, y=initY))
  dest_coords <- reactiveValues(x=initX, y=initY)
  observeEvent(plot_click_slow(), {
    dest_coords$x <- c(dest_coords$x, floor(plot_click_slow()$x))
    dest_coords$y <- c(dest_coords$y, floor(plot_click_slow()$y))
  })
  plot_click_slow<- debounce(reactive(input$plot_click), 300)
  DistCost <- reactive({
    num_points <- length(dest_coords$x)
    list(Lost = lapply(seq(num_points), function(n) {
      c(dest_coords$x[n], dest_coords$y[n])
    }))
  })
  
  output$image <- renderPlot({
    par(bg=NA)
    plot.new()
    plot.window(
      xlim = c(0, 10), ylim=c(0, 10),
      yaxs="i", xaxs="i"
    )
    axis(1)
    axis(2)
    grid(10, 10, col="black")
    box()
    plot(seg_out())
    points(source_coords$xy[1], source_coords$xy[2], cex=3, pch=intToUtf8(8962))
    text(dest_coords$x, dest_coords$y, paste0(DistCost()$Lost),col="red")
  })
  
  xy <- reactive({
    xy <- computeFeatures.moment(cell_seg())[,c('m.cx','m.cy')]
    #xy <- computeFeatures.moment(cell_seg)[,c('m.cx','m.cy')]
  })
  
  rds_training <- reactive({
    df <- data.frame(matrix(unlist(DistCost()), nrow=length(DistCost()$Lost), byrow=T))
    knn.out <- yaImpute::ann(as.matrix(xy()), as.matrix(df[2:nrow(df),]), k=2)
    row_n <- knn.out$knnIndexDist
    class(row_n)
    row_n <- as.data.frame(row_n)
    Ts.training <- table_test()
    #Ts.training <- table_test
    Ts.training$predict <- 0
    classify <- classify()
    if (classify == "pos") {
      classify1 = "P"
    } else { classify1 = "N"}
    Ts.training[row_n$V1, 21] <- classify1
    rds_training <- Ts.training
  })
  
  table_test <- reactive({
    # table_test_shape = computeFeatures.shape(cell_seg,ph_norm)
    # table_test_moment = computeFeatures.moment(cell_seg,ph_norm)
    # table_test_basic = computeFeatures.basic(cell_seg,ph_norm)
    table_test_shape = computeFeatures.shape(cell_seg(),ph_norm())
    table_test_moment = computeFeatures.moment(cell_seg(),ph_norm())
    table_test_basic = computeFeatures.basic(cell_seg(),ph_norm())
    table_test<-data.frame(cbind(table_test_basic,table_test_moment,table_test_shape))
    rownameTable<-row.names(table_test)
    table_test<-data.frame(cbind(rownameTable,table_test))
  })
  
  return(rds_training)
  
  #modvalues <- reactiveValues(new_rows=NULL)
  #count = 0
  
  # n_classified = reactive({
  #   total = nrow(rds_training())
  #   n_c = which(rds_training()$predict == 0)
  #   n_classified = total-length(n_c)
  # })
  # 
  
  # observeEvent(r$button, {
  #   count <<- count + 1
  #   if (count > 1) {
  #     modvalues$new_rows <- data.frame(rds_training())
  #   }
  # })
  
  # observeEvent(r$button, {
  #   count = count + 1
  #   if (count > 1) {
  #     modvalues$new_rows = data.frame(rds_training())
  #   }
  # })
  
  #return(reactive({modvalues$new_rows}))
  
  # output$table = renderTable({
  #   rds_training()
  # })
  # return(rds_training)
}

## To be copied in the UI
# mod_classify_ui("classify_ui_1")

## To be copied in the server
# callModule(mod_classify_server, "classify_ui_1")