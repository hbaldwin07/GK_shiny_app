# Module UI
  
#' @title   mod_test_model_ui and mod_test_model_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_test_model
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_test_model_ui <- function(id){
  ns <- NS(id)
  tagList(
    fileInput(ns("rds_file"), label=h4("Load the RDS file")),
    fileInput(ns("csv_file"), label=h4("Load the parameter (csv) file")),
    downloadButton(ns("parameters"), "Get Image Settings"), 
    #fileInput(ns("image_new"), "Load image: test model"),
    sliderInput(ns("dv"), "SVM Decision Value", -5, 5, 0, step=0.1),
    sliderInput(ns("int"), "Image intensity:", 1, 1000, 10, step=1),
    plotOutput(ns("img_test"))
  )
}
    
# Module Server
    
#' @rdname mod_test_model
#' @export
#' @keywords internal
    
mod_test_model_server <- function(input, output, session, r){
  ns <- session$ns
  mymodel <- reactive({
    m <- input$rds_file
    if (is.null(m))
      return(NULL)
    mymodel <- readRDS(m$datapath)
  })
  img <- reactive({
    f <- r$file
    if (is.null(f))
      return(NULL)
    readImage(f$datapath, all=T)
  })
  param.set <- reactive({
    df.parameter <- input$csv_file
    if (is.null(df.parameter))
      return(NULL)
    parameter.set <- read.csv(df.parameter$datapath, stringsAsFactors = F)
  })
  
  imageAnalysis.list <- reactive({
    ll.temp <- list()
    param.set.temp <- param.set()
    size <- as.numeric(dim(img()))
  })
  
}
    
## To be copied in the UI
# mod_test_model_ui("test_model_ui_1")
    
## To be copied in the server
# callModule(mod_test_model_server, "test_model_ui_1")
 
