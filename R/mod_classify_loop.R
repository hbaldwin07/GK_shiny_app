# Module UI
  
#' @title   mod_classify_loop_ui and mod_classify_loop_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_classify_loop
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_classify_loop_ui <- function(id){
  ns <- NS(id)
  tagList(
    mod_classify_ui(id = ns("mod"))
  )
}
    
# Module Server
    
#' @rdname mod_classify_loop
#' @export
#' @keywords internal
    
mod_classify_loop_server <- function(input, output, session, r, classify, n){
  ns <- session$ns

  r$loop = reactiveValues() 
  
  #browser()
  data = data.frame()
  values = reactiveValues(data=data)
  
  img = callModule(mod_load_img_server, "mod_img_temp", ix=n, r=r)
  dapi = callModule(mod_norm_ch_server, "mod_dapi_temp", img=img, n=reactive(r$mod3$DAPI), r=r)
  pheno = callModule(mod_norm_ch_server, "mod_pheno_temp", img=img, n=reactive(r$mod3$GFP), r=r)
  nseg = callModule(mod_n_segment_server, "mod_nseg_temp", nuc_norm=dapi, params=reactive(r$mod4), r=r)
  cseg = callModule(mod_ph_segment_server, "mod_cseg_temp", ph_norm=pheno, params=reactive(r$mod6), nseg=nseg, r=r)
  #browser()
  table = callModule(mod_classify_server, id="mod", r=r, img=img, cell_seg=cseg, ph_norm=pheno, classify=classify)
  #browser()
  observeEvent(table(),{
    values$data <- rbind(values$data, table())
  })
  
  observe({
    if (classify() == "pos") {
      r$loop$pos = values$data
    } else {
      r$loop$neg = values$data
    }
  })
  
  }
  
  #r$mod = reactiveValues()
  # data = data.frame()
  # values= reactiveValues(data=data)
  # count = 0
  
  # observeEvent(r$button, {
  #   count <<- count + 1
  #   cl = classify()
  #   if (count>0) {
  #     mod_out(count, cl)
  #     # output$ui = renderUI({
  #     #   return(reactive({mod_out(count, cl)}))
  #     # })
  #     # img = callModule(mod_load_img_server, "mod_img_temp", ix=reactive(i), r=r)
  #     # dapi = callModule(mod_norm_ch_server, "mod_dapi_temp", img=img, n=reactive(r$mod3$DAPI), r=r)
  #     # pheno = callModule(mod_norm_ch_server, "mod_pheno_temp", img=img, n=reactive(r$mod3$GFP), r=r)
  #     # nseg = callModule(mod_n_segment_server, "mod_nseg_temp", nuc_norm=dapi, params=reactive(r$mod4), r=r)
  #     # #browser()
  #     # cseg = callModule(mod_ph_segment_server, "mod_cseg_temp", ph_norm=pheno, params=reactive(r$mod6), nseg=nseg(), r=r)
  #     # # callModule(mod_classify_server, 'temp', r=r, img=img, cell_seg=cseg(), ph_norm=pheno, classify=reactive(cl), ix=reactive(i))
  #     # callModule(mod_classify_server, paste0("mod_", i), r=r, img=img, cell_seg=cseg, ph_norm=pheno, classify=reactive(cl), ix=reactive(i))
  #     # output$class_ui = renderUI({
  #     #   callModule(mod_classify_server, 'temp', r=r, img=img, cell_seg=cseg(), ph_norm=pheno, classify=reactive(cl), ix=reactive(i))
  #     # })
  #   }
  #   # output$class_ui = renderUI({
  #   #   #return(mod_classify_ui(paste0("mod_", count)))
  #   #   mod_classify_ui(paste0("mod_", count))
  #   # })
  
  # observe({
  #   r$mod$button = input$button
  #   r$mod$int = input$int
  # })
  
  # observeEvent(input$button, {
  #   count <<- count + 1
  #   f = r$img_dir$files
  #   classify = classify()
  #   if (count == 0) {
  #     return(NULL)
  #   } else {
  #     output$class_ui <- renderUI({
  #       return(paste0("mod_classify_ui_", i))
  #     })
  #   }
  #   
  #   #table = mod_out(count)
  #   # output$class_ui <- renderUI({
  #   #   mod_out(count)
  #   # })
  #       
  #   # observeEvent(table(), {
  #   #   values$data <- rbind(values$data, table())})
  #   #browser()
  #   # output$class_ui = renderUI({
  #   #   plot = rlist$plot
  #   #   plotOutput(plot())
  #   # })
  #   #table = rlist$table
  #   #values$data <- rbind(values$data, table())
  # })
  
  # mod_out = function(i) {
  #   browser()
  #   img = reactive({callModule(mod_load_img_server, "mod_img_temp", ix=reactive(i), r=r)})
  #   dapi = reactive({callModule(mod_norm_ch_server, "mod_dapi_temp", img=img(), n=reactive(r$mod3$DAPI), r=r)})
  #   pheno = reactive({callModule(mod_norm_ch_server, "mod_pheno_temp", img=img, n=reactive(r$mod3$GFP), r=r)})
  #   nseg = callModule(mod_n_segment_server, "mod_nseg_temp", nuc_norm=dapi(), params=reactive(r$mod4), r=r)
  #   cseg = callModule(mod_ph_segment_server, "mod_cseg_temp", ph_norm=pheno(), params=reactive(r$mod6), nseg=nseg, r=r)
  #   callModule(mod_classify_server, paste0("mod_classify_ui_", i), r=r, img=img(), cell_seg=cseg, ph_norm=pheno(), classify=reactive(cl), ix=reactive(i))
  # }
  

  
  # loop <- function(i, cl) {
  #   img = callModule(mod_load_img_server, "mod_img_temp", ix=reactive(i), r=r)
  #   dapi = callModule(mod_norm_ch_server, "mod_dapi_temp", img=img, n=reactive(r$mod3$DAPI), r=r)
  #   pheno = callModule(mod_norm_ch_server, "mod_pheno_temp", img=img, n=reactive(r$mod3$GFP), r=r)
  #   nseg = callModule(mod_n_segment_server, "mod_nseg_temp", nuc_norm=dapi, params=reactive(r$mod4), r=r)
  #   cseg = callModule(mod_ph_segment_server, "mod_cseg_temp", ph_norm=pheno, params=reactive(r$mod6), nseg=nseg, r=r)
  #   #browser()
  #   callModule(mod_classify_server, paste0("mod_classify_ui_", i), r=r, img=img, cell_seg=cseg, ph_norm=pheno, classify=reactive(cl), ix=reactive(i))
  # }
  # 
  # output$dl_training <- downloadHandler(
  #   filename <- function() {
  #     classify = classify()
  #     if (classify == "pos") {
  #       txt = "positive_training.rds"
  #     } else {
  #       txt = "negative_training.rds"
  #     }
  #     paste0(txt)
  #   },
  #   content <- function(file) {
  #     table <- values$data
  #     saveRDS(table, file=file)
  #   }
  # )

  # output$dl_training_N <- downloadHandler(
  #   filename <- function() {
  #     paste("negative_training.rds")
  #   },
  #   content <- function(file) {
  #     table2 <- values$data
  #     saveRDS(table2, file=file)
  #   }
  #)
  # 
  # 
  # filenames = reactive({
  #   path = r$img_dir$path
  #   tifs = dir(paste0(path)[grep(".tif", dir(paste0(path)))])
  #   filenames= as.list(tifs)
  # })
  # 
  # observe({
  #   r$classify_input_int = input$int
  # })
  # 
  # data = data.frame()
  # values= reactiveValues(data=data)
  # #rv = reactiveValues()
  # count = 0
  # 
  # observeEvent(input$button, {
  #   count <<- count + 1
  #   loop(count)
  #   #table <- loop(count)
  #   #browser()
  #   output$pos_class_ui <- renderUI({
  #     return(mod_classify_ui("mod_classify_ui_1"))
  #     #return(mod_classify_ui(paste0("mod_classify_ui_", count)))
  #   })
  #   # observeEvent(table(), {
  #   #   #browser()
  #   #   values$data <- rbind(values$data, table())
  #   # })
  # })
  # 
  # loop <- function(i) {
  #   img = reactive({callModule(mod_load_img_server, "temp", ix=reactive(i), r=r)})
  #   dapi = reactive({callModule(mod_norm_ch_server, "temp", img=img(), n=reactive(r$mod3$DAPI), r=r)})
  #   pheno = reactive({callModule(mod_norm_ch_server, "temp", img=img(), n=reactive(r$mod3$GFP), r=r)})
  #   nseg = reactive({callModule(mod_n_segment_server, "temp", nuc_norm=dapi(), params=reactive(r$mod4), r=r)})
  #   cseg = reactive({callModule(mod_ph_segment_server, "temp", ph_norm=pheno(), params=reactive(r$mod6), nseg=nseg(), r=r)})
  #   browser()
  #   callModule(mod_classify_server, "mod_classify_ui_1", r=r, img=img(), cell_seg=cseg(), ph_norm=pheno(), classify=reactive("pos"))
  #   #callModule(mod_classify_server, paste0("mod_classify_ui_", i), r=r, img=img(), cell_seg=cseg(), ph_norm=pheno(), classify=reactive("pos"), ix=reactive(i))
  #   #callModule(mod_classify_server, paste0("mod_classify_ui_", i), r=r, img=img(), cell_seg=cseg(), ph_norm=pheno(), classify=classify())
  #   #isolate({values[[paste0("df", count)]] = callModule(mod_classify_server, "mod_classify_ui_1", r=r, img=img(), cell_seg=cseg(), ph_norm=pheno(), classify=reactive("pos"))})
  # }
  # 
# }

# observeEvent(input$save, {
#   if (count ==0) {
#     output$table<- renderTable({
#       data.frame(0)
#     })
#   }
#   output$table <- renderTable({
#     callModule(mod_classify_server, "mod_classify_ui_1", r=r, img=img(), cell_seg=cseg(), ph_norm=pheno(), classify=reactive("pos"))
#   })
# })
#   

#   # output$text <- renderText({
#   #   if (classify()=="pos") {
#   #     text = "Download Positive Examples"
#   #   } else {
#   #     text = "Download Negative Examples"
#   #   }
#   # })
#   # output$text2 <- renderText({
#   #   if (classify()=="pos") {
#   #     text2 = "Select Positive Examples"
#   #   } else {text2 = "Select Negative Examples"}
#   # })
#   
#   filenames = reactive({
#     path = r$img_dir$path
#     tifs = dir(paste0(path)[grep(".tif", dir(paste0(path)))])
#     filenames= as.list(tifs)
#   })
#   fn_length = length(filenames())
#   browser()
#   
#   observeEvent(input$button, {
#       for (i in 1:fn_length) {
#         #browser()
#         img = reactive({callModule(mod_load_img_server, paste0("load_img_ui_", i), ix=reactive(i), r)})
#         dapi = reactive({callModule(mod_norm_ch_server, paste0("norm_ch_ui_", i), img=img(), n=reactive(r$mod3$DAPI), r)})
#         pheno = reactive({callModule(mod_norm_ch_server, paste0("norm_ch_ui_", i), img=img(), n=reactive(r$mod3$GFP), r)})
#         nseg = reactive({callModule(mod_n_segment_server, paste0("n_segment_ui_", i), nuc_norm=dapi(), params=reactive(r$mod4), r)})
#         cseg = reactive({callModule(mod_ph_segment_server, paste0("ph_segment_ui_", i), ph_norm=pheno(), params=reactive(r$mod6), nseg=nseg(), r)})
#         
#         output$plot = renderUI({callModule(mod_classify_server, paste0("classify_ui_", i), r, img=img(), cell_seg=cseg(), ph_norm=pheno(), classify=classify())})
#       }
#   
#     #browser()
#   }
#   )
# }
#   # 
#   # 
#   # observeEvent(input$button,
#   #              {if (input$button>0) {
#   #                filenames = reactive({
#   #                  path = r$img_dir$path
#   #                  tifs = dir(paste0(path)[grep(".tif", dir(paste0(path)))])
#   #                  filenames= as.list(tifs)
#   #                })
#   #                #browser()
#   #                fn_length = length(filenames())
#   #                #DF_list = list()
#   #                for (i in 1:fn_length) {
#   #                  # img = callModule(mod_load_img_server, paste0("load_img_ui_", i), ix=reactive(i), r)
#   #                  # dapi = callModule(mod_norm_ch_server, paste0("norm_ch_ui_", i), img=img, n=reactive(r$mod3$DAPI), r)
#   #                  # pheno = callModule(mod_norm_ch_server, paste0("norm_ch_ui_", i), img=img, n=reactive(r$mod3$GFP), r)
#   #                  # nseg = callModule(mod_n_segment_server, paste0("n_segment_ui_", i), nuc_norm=dapi, params=reactive(r$mod4), r)
#   #                  # cseg = callModule(mod_ph_segment_server, paste0("ph_segment_ui_", i), ph_norm=pheno, params=reactive(r$mod6), nseg=nseg, r)
#   #                  img = reactive({callModule(mod_load_img_server, paste0("load_img_ui_", i), ix=reactive(i), r)})
#   #                  dapi = reactive({callModule(mod_norm_ch_server, paste0("norm_ch_ui_", i), img=img(), n=reactive(r$mod3$DAPI), r)})
#   #                  pheno = reactive({callModule(mod_norm_ch_server, paste0("norm_ch_ui_", i), img=img(), n=reactive(r$mod3$GFP), r)})
#   #                  nseg = reactive({callModule(mod_n_segment_server, paste0("n_segment_ui_", i), nuc_norm=dapi(), params=reactive(r$mod4), r)})
#   #                  cseg = reactive({callModule(mod_ph_segment_server, paste0("ph_segment_ui_", i), ph_norm=pheno(), params=reactive(r$mod6), nseg=nseg(), r)})
#   #                  #browser()
#   #                  
#   #                  table_test <- reactive({
#   #                    #browser()
#   #                    # cseg = reactive({
#   #                    #   imageData(cseg)})
#   #                    #pheno = reactive({pheno})
#   #                    table_test_shape = computeFeatures.shape(cseg(),pheno())
#   #                    table_test_moment = computeFeatures.moment(cseg(),pheno())
#   #                    table_test_basic = computeFeatures.basic(cseg(),pheno())
#   #                    # table_test_shape = computeFeatures.shape(cseg,pheno)
#   #                    # table_test_moment = computeFeatures.moment(cseg,pheno)
#   #                    # table_test_basic = computeFeatures.basic(cseg,pheno)
#   #                    table_test<-data.frame(cbind(table_test_basic,table_test_moment,table_test_shape))
#   #                    rownameTable<-row.names(table_test)
#   #                    table_test<-data.frame(cbind(rownameTable,table_test))
#   #                  })
#   #                  #browser()
#   #                  initX <-1
#   #                  initY <-2
#   #                  source_coords <- reactiveValues(xy=c(x=initX, y=initY))
#   #                  dest_coords <- reactiveValues(x=initX, y=initY)
#   #                  observeEvent(plot_click_slow(), {
#   #                    dest_coords$y <- c(dest_coords$y, floor(plot_click_slow()$y))})
#   #                  plot_click_slow<- debounce(reactive(input$plot_click), 300)
#   #                  DistCost <- reactive({
#   #                    num_points <- length(dest_coords$x)
#   #                    list(Lost = lapply(seq(num_points), function(n) {c(dest_coords$x[n], dest_coords$y[n])}))})
#   #                  output$image <- renderPlot({
#   #                    par(bg=NA)
#   #                    plot.new()
#   #                    plot.window(
#   #                      xlim = c(0, 10), ylim=c(0, 10),
#   #                      yaxs="i", xaxs="i")
#   #                    axis(1)
#   #                    axis(2)
#   #                    grid(10, 10, col="black")
#   #                    box()
#   #                    plot(cseg())
#   #                    points(source_coords$xy[1], source_coords$xy[2], cex=3, pch=intToUtf8(8962))
#   #                    text(dest_coords$x, dest_coords$y, paste0(DistCost()$Lost),col="red")
#   #                    #browser()
#   #                  })
#   #                  
#   #                  # output$ui = renderUI({
#   #                  #   initX <-1
#   #                  #   initY <-2
#   #                  #   #browser()
#   #                  #   source_coords <- reactiveValues(xy=c(x=initX, y=initY))
#   #                  #   dest_coords <- reactiveValues(x=initX, y=initY)
#   #                  #   observeEvent(plot_click_slow(), {
#   #                  #     dest_coords$y <- c(dest_coords$y, floor(plot_click_slow()$y))})
#   #                  #   plot_click_slow<- debounce(reactive(input$plot_click), 300)
#   #                  #   DistCost <- reactive({
#   #                  #     num_points <- length(dest_coords$x)
#   #                  #     list(Lost = lapply(seq(num_points), function(n) {c(dest_coords$x[n], dest_coords$y[n])}))})
#   #                  #   output$image <- renderPlot({
#   #                  #     par(bg=NA)
#   #                  #     plot.new()
#   #                  #     plot.window(
#   #                  #       xlim = c(0, 10), ylim=c(0, 10),
#   #                  #       yaxs="i", xaxs="i")
#   #                  #     axis(1)
#   #                  #     axis(2)
#   #                  #     grid(10, 10, col="black")
#   #                  #     box()
#   #                  #     plot(cseg())
#   #                  #     points(source_coords$xy[1], source_coords$xy[2], cex=3, pch=intToUtf8(8962))
#   #                  #     text(dest_coords$x, dest_coords$y, paste0(DistCost()$Lost),col="red")
#   #                  #   })
#   #                    #plotOutput(ns("image"), click=ns("plot_click"))
#   #                    #plotOutput("image", click=ns("plot_click"))
#   #                    #browser()
#   #                  #})
#   #                  #browser()
#   #                  xy <- reactive({
#   #                    xy <- computeFeatures.moment(cseg())[,c('m.cx','m.cy')]})
#   #                    #xy <- computeFeatures.moment(cseg)[,c('m.cx','m.cy')]
#   #                    
#   #                  # rds_training <- reactive({
#   #                  #   df <- data.frame(matrix(unlist(DistCost()), nrow=length(DistCost()$Lost), byrow=T))
#   #                  #   knn.out <- yaImpute::ann(as.matrix(xy()), as.matrix(df[2:nrow(df),]), k=2)
#   #                  #   row_n <- knn.out$knnIndexDist
#   #                  #   class(row_n)
#   #                  #   row_n <- as.data.frame(row_n)
#   #                  #   Ts.training <- table_test()
#   #                  #   Ts.training$predict <- 0
#   #                  #   classify <- classify()
#   #                  #   if (classify == "pos") {
#   #                  #     classify1 = "P"} 
#   #                  #   else { classify1 = "N"}
#   #                  #   Ts.training[row_n$V1, 21] <- classify1
#   #                  #   rds_training <- Ts.training
#   #                  # })
#   #                  # DF_list[[i]] = renderTable({
#   #                  #   rds_training()
#   #                  # })
#   #                  # DF_list[[i]] = reactive({
#   #                  #   table = rds_training()
#   #                  #   as.data.frame(table)
#   #                  # })
#   #                  #browser()
#   #                }
#   #                # browser()
#   #                # final_table = data.table::rbindlist(DF_list)
#   #                # output$dl_training <- downloadHandler(
#   #                #   filename <- function() {
#   #                #     if (classify()=="pos") {
#   #                #       paste("positive_training.rds", sep="_")}
#   #                #     else {paste("negative_training.rds", sep="_")}},
#   #                #   content <- function(file) {
#   #                #     table <- final_table
#   #                #     saveRDS(table, file=file)})
#   #              }
#   #              }
#   #              
#   # )
#   # }
#   # 

    
## To be copied in the UI
# mod_classify_loop_ui("classify_loop_ui_1")
    
## To be copied in the server
# callModule(mod_classify_loop_server, "classify_loop_ui_1")
 
