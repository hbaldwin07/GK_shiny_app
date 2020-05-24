#' @import shiny
#' @import EBImage
app_server <- function(input, output,session) {
  # List the first level callModules here
  options(shiny.maxRequestSize=30*1024^2)
  observeEvent(input$reset_input,{
    shinyjs::reset("side-panel")
  })
  r <- reactiveValues()
  
  callModule(mod_img_dir_server, "img_dir_ui_1", r)

  img1 <- reactive({callModule(mod_load_img_server, "load_img_ui_1", r, ix=reactive(1))})
  callModule(mod_display_ch_server, "display_ch_ui_1", img=img1(), n=reactive(1), r)
  callModule(mod_display_ch_server, "display_ch_ui_2", img=img1(), n=reactive(2), r)
  callModule(mod_display_ch_server, "display_ch_ui_3", img=img1(), n=reactive(3), r)
  callModule(mod_display_ch_server, "display_ch_ui_4", img=img1(), n=reactive(4), r)
  callModule(mod_select_ch_server, "select_ch_ui_1", r)
  callModule(mod_nuc_params_server, "nuc_params_ui_1", r)
  callModule(mod_ph_params_server, "ph_params_ui_1", r)
  dapi_norm = reactive({callModule(mod_norm_ch_server, "norm_ch_ui_1", img=img1(), n=reactive(r$mod3$DAPI), r)})
  pheno_norm = reactive({callModule(mod_norm_ch_server, "norm_ch_ui_2", img=img1(), n=reactive(r$mod3$GFP), r)})
  callModule(mod_n_segment_server, "n_segment_ui_1", nuc_norm=dapi_norm(), params=reactive(r$mod4), r)
  callModule(mod_ph_segment_server, "ph_segment_ui_1", ph_norm=pheno_norm(), params=reactive(r$mod6), nseg=nseg1(), r)
  
  nseg1 <- reactive({callModule(mod_n_segment_server, "n_segment_ui_1", nuc_norm=dapi_norm(), params=reactive(r$mod4), r)})
  
  callModule(mod_dl_params_server, "dl_params_ui_1", r)
  
  callModule(mod_cmodel_dir_server, "cmodel_dir_ui_1", r)
  callModule(mod_create_model_server, "create_model_ui_1", r)
  callModule(mod_test_model_server, "test_model_ui_1", r)
  
  callModule(mod_classify_loop_server, "pos_classify_ui_1", r, reactive("pos"))
  callModule(mod_classify_loop_server, "neg_classify_ui_1", r, reactive("neg"))
  
  # observe({
  #   r$button = input$button
  # })
  # observe({
  #   r$button = input$button_n
  # })
  # 
  # filenames = reactive({
  #   path = r$img_dir$path
  #   tifs = dir(paste0(path)[grep(".tif", dir(paste0(path)))])
  #   filenames= as.list(tifs)
  # })
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
  #   if (count == 0) {
  #     return(NULL)
  #   } else if (count <= length(filenames())) {
  #     loop(count)
  #     table <- loop(count)
  #   }
  #   output$pos_class_ui <- renderUI({
  #     return(mod_classify_ui(paste0("mod_classify_ui_", count)))
  #   })
  #   observeEvent(table(), {
  #     values$data <- rbind(values$data, table())
  #   })
  # })
  # 
  # observeEvent(input$button_n, {
  #   count <<- count + 1
  #   if (count == 0) {
  #     return(NULL)
  #   } else if (count <= length(filenames())) {
  #     loop2(count)
  #     table2 <- loop2(count)
  #   }
  #   output$neg_class_ui <- renderUI({
  #     return(mod_classify_ui(paste0("mod_classify_n_ui_", count)))
  #   })
  #   observeEvent(table2(), {
  #     values$data <- rbind(values$data, table2())
  #   })
  # })
  # 
  # loop <- function(i) {
  #   img = reactive({callModule(mod_load_img_server, "temp", ix=reactive(i), r=r)})
  #   dapi = reactive({callModule(mod_norm_ch_server, "temp", img=img(), n=reactive(r$mod3$DAPI), r=r)})
  #   pheno = reactive({callModule(mod_norm_ch_server, "temp", img=img(), n=reactive(r$mod3$GFP), r=r)})
  #   nseg = reactive({callModule(mod_n_segment_server, "temp", nuc_norm=dapi(), params=reactive(r$mod4), r=r)})
  #   cseg = reactive({callModule(mod_ph_segment_server, "temp", ph_norm=pheno(), params=reactive(r$mod6), nseg=nseg(), r=r)})
  #   callModule(mod_classify_server, paste0("mod_classify_ui_", i), r=r, img=img(), cell_seg=cseg(), ph_norm=pheno(), classify=reactive("pos"), ix=reactive(i))
  # }
  # loop2 <- function(i) {
  #   img = reactive({callModule(mod_load_img_server, "temp", ix=reactive(i), r=r)})
  #   dapi = reactive({callModule(mod_norm_ch_server, "temp", img=img(), n=reactive(r$mod3$DAPI), r=r)})
  #   pheno = reactive({callModule(mod_norm_ch_server, "temp", img=img(), n=reactive(r$mod3$GFP), r=r)})
  #   nseg = reactive({callModule(mod_n_segment_server, "temp", nuc_norm=dapi(), params=reactive(r$mod4), r=r)})
  #   cseg = reactive({callModule(mod_ph_segment_server, "temp", ph_norm=pheno(), params=reactive(r$mod6), nseg=nseg(), r=r)})
  #   callModule(mod_classify_server, paste0("mod_classify_n_ui_", i), r=r, img=img(), cell_seg=cseg(), ph_norm=pheno(), classify=reactive("neg"), ix=reactive(i))
  # }
  # 
  # output$dl_training_P <- downloadHandler(
  #   filename <- function() {
  #    paste("positive_training.rds")
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
  # )
  
  
  #callModule(mod_test_model_server, "test_model_1", r)
  
   
}

  
  
  
  

  
    # lapply(1:length(filenames()), function(i) {
    #   img = reactive({callModule(mod_load_img_server, paste0("load_img_", i), ix=reactive(i), r=r)})
    #   dapi = reactive({callModule(mod_norm_ch_server, paste0("norm_ch_dapi_", i), img=img(), n=reactive(r$mod3$DAPI), r=r)})
    #   pheno = reactive({callModule(mod_norm_ch_server, paste0("norm_ch_pheno_", i), img=img(), n=reactive(r$mod3$GFP), r=r)})
    #   nseg = reactive({callModule(mod_n_segment_server, paste0("n_seg_", i), nuc_norm=dapi(), params=reactive(r$mod4), r=r)})
    #   cseg = reactive({callModule(mod_ph_segment_server, paste0("c_seg_", i), ph_norm=pheno(), params=reactive(r$mod6), nseg=nseg(), r=r)})
    #   callModule(mod_classify_server, paste0("p", i), r=r, img=img(), cell_seg=cseg(), ph_norm=pheno(), classify=reactive("pos"))
    #   temp_table = callModule(mod_classify_server, paste0("p", i), r=r, img=img(), cell_seg=cseg(), ph_norm=pheno(), classify=reactive("pos"))
    #   output$pos_class_ui <- renderUI({
    #     return(mod_classify_ui(paste0("p", count)))})
    #   observeEvent(input$button_save, {
    #     isolate({ values = rbind(values$df, temp_table())})
    #   })

  # 
  # observe({
  #   for (i in 1:length(filenames())) {
  #     isolate({
  #       images[[i]] = callModule(mod_load_img_server, paste0("load_img_", i), ix=reactive(i), r=r)
  #     })
  #   }
  # })
  # browser()
  # 
  # observeEvent(input$button, {
  #   i=1
  #   callModule(mod_norm_ch_server, paste0("norm_ch_dapi_", i), img=reactive(images[[i]]), n=reactive(r$mod3$DAPI), r=r)
  #   output$pos_class_ui <- renderUI({
  #     return(mod_norm_ch_ui(paste0("norm_ch_dapi_", i)))})
  # })

#   output$test = renderUI{
#     
#     plotOutput
#   }
#   
#   for (n in length(images))
#   
#   loop <- function(i) {
#     img = callModule(mod_load_img_server, paste0("load_img_", i), ix=reactive(i), r=r)
#     dapi = reactive({callModule(mod_norm_ch_server, paste0("norm_ch_dapi_", i), img=img(), n=reactive(r$mod3$DAPI), r=r)})
#     pheno = reactive({callModule(mod_norm_ch_server, paste0("norm_ch_pheno_", i), img=img(), n=reactive(r$mod3$GFP), r=r)})
#     nseg = reactive({callModule(mod_n_segment_server, paste0("n_seg_", i), nuc_norm=dapi(), params=reactive(r$mod4), r=r)})
#     cseg = reactive({callModule(mod_ph_segment_server, paste0("c_seg_", i), ph_norm=pheno(), params=reactive(r$mod6), nseg=nseg(), r=r)})
#     
#     isolate({
#       rv$
#     })
#     
#     
#     callModule(mod_classify_server, paste0("p", i), r=r, img=img(), cell_seg=cseg(), ph_norm=pheno(), classify=reactive("pos"))
#     temp_table = callModule(mod_classify_server, paste0("p", i), r=r, img=img(), cell_seg=cseg(), ph_norm=pheno(), classify=reactive("pos"))
#   }
#   
#   save_loop <- function(i) {
#     isolate({ values = rbind(values$df, temp_table())})
#   }
# 
#   lapply(1:length(filenames()), function(i) {
#     img = reactive({callModule(mod_load_img_server, paste0("load_img_", i), ix=reactive(i), r=r)})
#     dapi = reactive({callModule(mod_norm_ch_server, paste0("norm_ch_dapi_", i), img=img(), n=reactive(r$mod3$DAPI), r=r)})
#     pheno = reactive({callModule(mod_norm_ch_server, paste0("norm_ch_pheno_", i), img=img(), n=reactive(r$mod3$GFP), r=r)})
#     nseg = reactive({callModule(mod_n_segment_server, paste0("n_seg_", i), nuc_norm=dapi(), params=reactive(r$mod4), r=r)})
#     cseg = reactive({callModule(mod_ph_segment_server, paste0("c_seg_", i), ph_norm=pheno(), params=reactive(r$mod6), nseg=nseg(), r=r)})
#     callModule(mod_classify_server, paste0("p", i), r=r, img=img(), cell_seg=cseg(), ph_norm=pheno(), classify=reactive("pos"))
#     temp_table = callModule(mod_classify_server, paste0("p", i), r=r, img=img(), cell_seg=cseg(), ph_norm=pheno(), classify=reactive("pos"))
#     output$pos_class_ui <- renderUI({
#       return(mod_classify_ui(paste0("p", count)))})
#     observeEvent(input$button_save, {
#       isolate({ values = rbind(values$df, temp_table())})
#     })
#     observeEvent(input$button_next, {
#       
#     })
#     
#   } )
#   
#   
#   
#   
#   observeEvent(input$button, {
#     count <<- count + 1
#     output$pos_class_ui <- renderUI({
#       return(mod_classify_ui(paste0("p", count)))})
#     
#     if (count>0) {
#       return(Null) }
#     else if (count==1) {
#       lapply(1:length(filenames()), function(i) {
#         img = reactive({callModule(mod_load_img_server, paste0("load_img_", i), ix=reactive(i), r=r)})
#         dapi = reactive({callModule(mod_norm_ch_server, paste0("norm_ch_dapi_", i), img=img(), n=reactive(r$mod3$DAPI), r=r)})
#         pheno = reactive({callModule(mod_norm_ch_server, paste0("norm_ch_pheno_", i), img=img(), n=reactive(r$mod3$GFP), r=r)})
#         nseg = reactive({callModule(mod_n_segment_server, paste0("n_seg_", i), nuc_norm=dapi(), params=reactive(r$mod4), r=r)})
#         cseg = reactive({callModule(mod_ph_segment_server, paste0("c_seg_", i), ph_norm=pheno(), params=reactive(r$mod6), nseg=nseg(), r=r)})
#         callModule(mod_classify_server, paste0("p", i), r=r, img=img(), cell_seg=cseg(), ph_norm=pheno(), classify=reactive("pos"))
#         temp_table = callModule(mod_classify_server, paste0("p", i), r=r, img=img(), cell_seg=cseg(), ph_norm=pheno(), classify=reactive("pos"))
#       })
#     }
#       
#         observeEvent(input$button_save, {
#           isolate({ values = rbind(values$df, temp_table())})
#         })
#     })
#     } else if (count>1) {
#       
#     }
# })
#     # lapply(1:length(filenames()), function(i) {
#     #   isolate({
#     #     img = reactive({callModule(mod_load_img_server, paste0("load_img_", i), ix=reactive(i), r=r)})
#     #     dapi = reactive({callModule(mod_norm_ch_server, paste0("norm_ch_dapi_", i), img=img(), n=reactive(r$mod3$DAPI), r=r)})
#     #     pheno = reactive({callModule(mod_norm_ch_server, paste0("norm_ch_pheno_", i), img=img(), n=reactive(r$mod3$GFP), r=r)})
#     #     nseg = reactive({callModule(mod_n_segment_server, paste0("n_seg_", i), nuc_norm=dapi(), params=reactive(r$mod4), r=r)})
#     #     cseg = reactive({callModule(mod_ph_segment_server, paste0("c_seg_", i), ph_norm=pheno(), params=reactive(r$mod6), nseg=nseg(), r=r)})
#     #     callModule(mod_classify_server, paste0("p", i), r=r, img=img(), cell_seg=cseg(), ph_norm=pheno(), classify=reactive("pos"))
#     #     temp_table = callModule(mod_classify_server, paste0("p", i), r=r, img=img(), cell_seg=cseg(), ph_norm=pheno(), classify=reactive("pos"))
#     #   })
#     #   observeEvent(input$button_save, {
#     #     isolate({ values = rbind(values$df, temp_table())})
#     #     })
#     #   })
#     # })
# }
#   
# 
#   # count <- 0
#   # observeEvent(input$button, {
#   #   count <<- count + 1 
#   #   
#   #   output$pos_class_ui <- renderUI({
#   #     return(mod_classify_ui(paste0("p", count)))
#   #   })
#   # 
#   #     # lapply(1:2, function(n) {
#   #     #   return(mod_classify_ui(paste0("p", n+count)))
#   #     #   })
#   #     # })
#   #   
#   #   values= reactiveValues()
#   #   
#   #   lapply(0:length(filenames()), function(i) {
#   #     img = reactive({callModule(mod_load_img_server, paste0("load_img_", i+count), ix=reactive(i+count), r=r)})
#   #     dapi = reactive({callModule(mod_norm_ch_server, paste0("norm_ch_dapi_", i+count), img=img(), n=reactive(r$mod3$DAPI), r=r)})
#   #     pheno = reactive({callModule(mod_norm_ch_server, paste0("norm_ch_pheno_", i+count), img=img(), n=reactive(r$mod3$GFP), r=r)})
#   #     nseg = reactive({callModule(mod_n_segment_server, paste0("n_seg_", i+count), nuc_norm=dapi(), params=reactive(r$mod4), r=r)})
#   #     cseg = reactive({callModule(mod_ph_segment_server, paste0("c_seg_", i+count), ph_norm=pheno(), params=reactive(r$mod6), nseg=nseg(), r=r)})
#   #     callModule(mod_classify_server, paste0("p", i+count), r=r, img=img(), cell_seg=cseg(), ph_norm=pheno(), classify=reactive("pos"))
#   #     
#   #     observeEvent(input$button_save, {
#   #       temp_table = callModule(mod_classify_server, paste0("p", i+count), r=r, img=img(), cell_seg=cseg(), ph_norm=pheno(), classify=reactive("pos"))
#   #       isolate({
#   #         values = rbind(values$df, temp_table())
#   #       })
#   #     })
#       #temp_table = callModule(mod_classify_server, paste0("p", i+count), r=r, img=img(), cell_seg=cseg(), ph_norm=pheno(), classify=reactive("pos"))
#       #values = rbind(values$df, temp_table())})
#     #browser()
#   
#   # observeEvent(
#   #   input$button, {
#   #     output$pos_class_ui <- renderUI({
#   #       lapply(1:25, function(n) {
#   #         return(mod_classify_ui(paste0("p", n)))
#   #       })
#   #     })
#       # lapply(1:25, function(i) {
#       #   img = reactive({callModule(mod_load_img_server, ix=reactive(i), r=r)})
#       #   dapi = reactive({callModule(mod_norm_ch_server, img=img(), n=reactive(r$mod3$DAPI), r=r)})
#       #   pheno = reactive({callModule(mod_norm_ch_server, img=img(), n=reactive(r$mod3$GFP), r=r)})
#       #   nseg = reactive({callModule(mod_n_segment_server, nuc_norm=dapi(), params=reactive(r$mod4), r=r)})
#       #   cseg = reactive({callModule(mod_ph_segment_server, ph_norm=pheno(), params=reactive(r$mod6), nseg=nseg(), r=r)})
#       #   callModule(mod_classify_server, paste0("p", i), r=r, img=img(), cell_seg=cseg(), ph_norm=pheno(), classify=reactive("pos"))
#       # })
#   #   }
#   # )
#   
#   
# 
#   #
#   # 

