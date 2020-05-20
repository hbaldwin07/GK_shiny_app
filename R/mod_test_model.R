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
    sidebarLayout(
      sidebarPanel(
        fileInput(ns("test_img"), label="Choose Test Image"),
        # selectInput(ns("DAPI"), label="Dapi Channel?",  c("ch1", "ch2", "ch3", "ch4")), 
        # selectInput(ns("GFP"), label="Phenotype Channel?", c("ch1", "ch2", "ch3", "ch4")),
        fileInput(ns("rds_file"), label=("Load the RDS file")),
        fileInput(ns("csv_file"), label=("Load the parameter (csv) file")),
        downloadButton(ns("parameters"), "Get Image Settings"), 
        #fileInput(ns("image_new"), "Load image: test model"),
        sliderInput(ns("dv"), label="SVM Decision Value", -5, 5, 0, step=0.1),
        sliderInput(ns("int"), label="Image intensity:", 1, 1000, 10, step=1)
      ),
      mainPanel(
        plotOutput(ns("model_img"))
      )
    )
  )
}
    
# Module Server
    
#' @rdname mod_test_model
#' @export
#' @keywords internal
    
mod_test_model_server <- function(input, output, session, r){
  ns <- session$ns
  
  # r$test_mod <- reactiveValues()
  # observe({
  #   r$test_mod$DAPI <- input$DAPI
  #   r$test_mod$GFP <- input$GFP})
  
  mymodel <- reactive({
    m <- input$rds_file
    if (is.null(m))
      return(NULL)
    mymodel <- readRDS(m$datapath)
  })
  img <- reactive({
    f <- input$test_img
    if (is.null(f))
      return(NULL)
    readImage(f$datapath, all=T)
  })
  
  param <- reactive({
    df.parameter <- input$csv_file
    if (is.null(df.parameter))
      return(NULL)
    param <- read.csv(df.parameter$datapath, stringsAsFactors = F)
  })
  
  # dapi_norm = reactive({callModule(mod_norm_ch_server, "norm_ch_ui_a", img=img(), n=reactive(param()$DAPI), r)})
  # pheno_norm = reactive({callModule(mod_norm_ch_server, "norm_ch_ui_b", img=img(), n=reactive(param$GFP), r)})
  # nseg = reactive({callModule(mod_n_segment_server, "n_segment_ui_a", nuc_norm=dapi_norm(), params=reactive(rparam()), r)})
  # cseg = reactive({callModule(mod_ph_segment_server, "ph_segment_ui_1", ph_norm=pheno_norm(), params=reactive(r$mod6), nseg=nseg1(), r)})
  
  imageAnalysis.list <- reactive({
    ll.temp <- list()
    params <- param()
    size <- as.numeric(dim(img()))
    dapi_norm = callModule(mod_norm_ch_server, "norm_ch_ui_a", img=img(), n=reactive(params$DAPI), r)
    pheno_norm = callModule(mod_norm_ch_server, "norm_ch_ui_b", img=img(), n=reactive(params$GFP), r)
    nseg = callModule(mod_n_segment_server, "n_segment_ui_a", nuc_norm=dapi_norm(), params=reactive(params), r)
    cseg = callModule(mod_ph_segment_server, "ph_segment_ui_1", ph_norm=pheno_norm(), params=reactive(params), nseg=nseg1(), r)
    
  })
  
}
    
## To be copied in the UI
# mod_test_model_ui("test_model_ui_1")
    
## To be copied in the server
# callModule(mod_test_model_server, "test_model_ui_1")
 
