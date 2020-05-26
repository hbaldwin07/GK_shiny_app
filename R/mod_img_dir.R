# Module UI
  
#' @title   mod_img_dir_ui and mod_img_dir_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_img_dir
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_img_dir_ui <- function(id){
  ns <- NS(id)
  tagList(
    #shinyDirectoryInput::directoryInput(ns('directory'), label = 'select a directory')
    # shinyDirButton(ns("dir"), "Input directory", "Upload"),
    # verbatimTextOutput(ns("dir"), placeholder = TRUE)  
    fluidRow(
      fileInput(ns("file"), 'Select Image Files',multiple = TRUE),
      textOutput("for segmentation & training")
    )
  )
}
    
# Module Server
    
#' @rdname mod_img_dir
#' @export
#' @keywords internal
    
mod_img_dir_server <- function(input, output, session, r){
  ns <- session$ns
  r$img_dir = reactiveValues()
  
  observeEvent(input$file, {
    r$img_dir$files = input$file
  })
  
  # output$contents <- renderTable({
  #   # input$file1 will be NULL initially. After the user selects
  #   # and uploads a file, it will be a data frame with 'name',
  #   # 'size', 'type', and 'datapath' columns. The 'datapath'
  #   # column will contain the local filenames where the data can
  #   # be found.
  #   inFile <- input$file1
  #   if (is.null(inFile)) {
  #     return(NULL)
  #   } else {
  #     df = read.csv(inFile$datapath, header = input$header)
  #     browser()
  #   }
  # })
}
#   volumes = getVolumes()
#   shinyDirChoose(input, "dir", roots = volumes(), session = session)
#   
#   observe({
#     path = parseDirPath(volumes(), input$dir)
#     r$img_dir$path = path
#   })
#   output$dir <- renderText({
#     r$img_dir$path
#   })
  #path = parseDirPath(volumes(), input$dir)
  #global = reactiveValues(datapath=parseDirPath(volumes(), input$dir))
  #dir = reactive(input$dir)
  
  # output$dir <- renderText({
  #   global$datapath
  # })
  
  # observe({
  #   shinyDirChoose(input, "dir", roots = volumes(), session = session)
  #   browser()
  #   path = parseDirPath(volumes(), input$dir)
  # })
  # 
  
 
  # shinyFiles::shinyDirChoose(
  #   input,
  #   'dir',
  #   roots = roots,
  #   session=session
  #   #filetypes = c('', 'tif')
  # )
  # 
  # global <- reactiveValues(datapath = getwd())
  # dir <- reactive(input$dir)
  # 
  # output$dir <- renderText({
  #   global$datapath
  # })
  # 
  # observeEvent(ignoreNULL = TRUE, eventExpr = {
  #                input$dir},
  #              handlerExpr = {
  #                if (!"path" %in% names(dir())) {
  #                  return()
  #                }
  #                home <- normalizePath("~")
  #                global$datapath <-
  #                  file.path(home, paste(unlist(dir()$path[-1]), collapse = .Platform$file.sep))
  #              })
  # observe({
  #   r$img_dir$path = global$datapath
  #   #browser()
  # })
  
  # ##DEV MODE ONLY##
  # observe({
  #   r$img_dir$path = "~/Documents/test_tifs/"
  # })
  # ##
  
  # observeEvent(
  #   ignoreNULL = TRUE,
  #   eventExpr = {input$directory},
  #   handlerExpr = {
  #     if (input$directory>0) {
  #       path = shinyDirectoryInput::choose.dir(default=shinyDirectoryInput::readDirectoryInput(session, "directory"))
  #       shinyDirectoryInput::updateDirectoryInput(session, 'directory', value = path)
  #       r$img_dir$path = path
  #     }
  #   }
  #   )


  # observeEvent(
  #   eventExpr = {input$directory}, 
  #   handlerExpr = {
  #     if (input$directory > 0 ) {
  #       path = shinyDirectoryInput::choose.dir(default = shinyDirectoryInput::readDirectoryInput(session, "directory"))
  #       shinyDirectoryInput::updateDirectoryInput(session, 'directory', value = path)
  #       filenames <- reactive({
  #         filenames = dir(paste0(path)[grep(".tif", dir(paste0(path)))])
  #       })
  #       r$load_img$files = filenames()
  #       output$test <- renderText({
  #         paste0(r$load_img$files)
  #       })
  #     }
  #     
  #   }
  # )
#}
    
## To be copied in the UI
# mod_img_dir_ui("img_dir_ui_1")
    
## To be copied in the server
# callModule(mod_img_dir_server, "img_dir_ui_1")
 
