app_server <- function(input, output,session) {
  # List the first level callModules here
  options(shiny.maxRequestSize=30*1024^2)
  observeEvent(input$reset_input,{
    shinyjs::reset("side-panel")
  })
  r <- reactiveValues()
  
  #callModule(mod_img_dir_server, "img_dir_ui_1", r)
  #img1 <- reactive({callModule(mod_load_img_server, "load_img_ui_1", r, ix=reactive(1))})
  # observeEvent(input$file, {
  #   r$img1 = input$file
  # })
  
  
  img1 <- callModule(mod_img_setup_server, "img_setup_ui_1", r)
  
  # callModule(mod_display_ch_server, "display_ch_ui_1", img=img1(), n=reactive(1), r)
  # callModule(mod_display_ch_server, "display_ch_ui_2", img=img1(), n=reactive(2), r)
  # callModule(mod_display_ch_server, "display_ch_ui_3", img=img1(), n=reactive(3), r)
  # callModule(mod_display_ch_server, "display_ch_ui_4", img=img1(), n=reactive(4), r)
  # callModule(mod_select_ch_server, "select_ch_ui_1", r)
  
  #dapi_norm = callModule(mod_norm_ch_server, "norm_ch_ui_1", img=img1(), n=reactive(r$mod3$DAPI), r)
  dapi_norm = callModule(mod_norm_ch_server, "norm_ch_ui_1", img=img1, n=reactive(r$mod3$DAPI), r)
  callModule(mod_nuc_params_server, "nuc_params_ui_1", r)
  nseg = callModule(mod_n_segment_server, "n_segment_ui_1", nuc_norm=dapi_norm, params=reactive(r$mod4), r)

  callModule(mod_ph_params_server, "ph_params_ui_1", r)
  pheno_norm = callModule(mod_norm_ch_server, "norm_ch_ui_2", img=img1, n=reactive(r$mod3$GFP))
  pseg = callModule(mod_ph_segment_server, "ph_segment_ui_1", ph_norm=pheno_norm, params=reactive(r$mod6), nseg=nseg, r)
  callModule(mod_dl_params_server, "dl_params_ui_1", r)
  
  callModule(mod_img_dir_server, "img_dir_ui_1", r)
  callModule(mod_img_dir_server, "img_dir_ui_2", r)

  callModule(mod_create_model_server, "create_model_ui_1", r)
  callModule(mod_test_model_server, "test_model_ui_1", r)

  observe({
    r$int = input$int
    r$int = input$int_n
  })
  
  output$params_ui = renderUI({
    if (input$up_par) {
      div(
        fileInput(("csv_file"), label=("Load the parameter (csv) file")),
        style = "padding-bottom: 0px; font-size: 80%; height:10 px"
      )
    }
  })
  
  observe({
    r$par = input$up_par
    r$csv = input$csv_file
  })
  
  count = 0
  observeEvent(input$button, {
    count <<- count + 1
    fn = nrow(r$img_dir$files)
    if (count == 0) {
      return(NULL)
    } else if (count <= fn) {
      callModule(mod_classify_loop_server, "mod_classify_loop_ui_1", r=r, classify=reactive("pos"), n=reactive(count))
    }
  })

  count2 = 0
  observeEvent(input$button_n, {
    count2 <<- count2 + 1
    fn = nrow(r$img_dir$files)
    if (count2 == 0) {
      return(NULL)
    } else if (count2 <= fn) {
      i = count2
      callModule(mod_classify_loop_server, "mod_classify_loop_ui_2", r=r, classify=reactive("neg"), n=reactive(i))
    } 
  })
  
  output$dl_training_P <- downloadHandler(
    filename <- function() {
      paste("positive_training.rds")
    },
    content <- function(file) {
      table <- r$loop$pos
      saveRDS(table, file=file)
    }
  )
  output$dl_training_N <- downloadHandler(
    filename <- function() {
      paste("negative_training.rds")
    },
    content <- function(file) {
      table2 <- r$loop$neg
      saveRDS(table2, file=file)
    }
  )
}
  

  
      # table = callModule(mod_classify_loop_server, "mod_classify_loop_ui_1", r=r, classify=reactive("pos"), n=reactive(i))
      #values$data <- rbind(values$data, table())
      #browser()
    # else {
    #   return(print("No more images"))
    # }
    # output$pos_class_ui = renderUI({
    #   return(mod_classify_loop_ui("mod_classify_loop_ui_1"))
    # })
    # observeEvent(table(), {
    #   values$data <- rbind(values$data, table())
    # })
  



  # observeEvent(table(), {
  #   values$data <- rbind(values$data, table())
  #   #browser()
  # })
  
  # data2 = data.frame()
  # values2= reactiveValues(data=data2)
  # count2 = 0
  # observeEvent(input$button_n, {
  #   r$button = input$button_n
  #   r$int = input$int_n
  #   count2 <<- count2 + 1
  #   if (count2 == 0 | count2 > length(r$img_dir$files)) {
  #     return(NULL)
  #   } else {
  #     i = count2
  #     table2 = callModule(mod_classify_loop_server, "mod_classify_loop_ui_2", r=r, classify=reactive("neg"), n=reactive(i))
  #   }
  #   output$neg_class_ui = renderUI({
  #     return(mod_classify_loop_ui("mod_classify_loop_ui_2"))
  #   })
  #   observeEvent(table2(), {
  #     values2$data <- rbind(values2$data, table2())
  #   })
  # })
  # output$dl_training_P <- downloadHandler(
  #   filename <- function() {
  #     paste("positive_training.rds")
  #   },
  #   content <- function(file) {
  #     table <- values$data
  #     saveRDS(table, file=file)
  #   }
  # )



  
  
  
  
  #callModule(mod_n_segment_server, "n_segment_ui_1", nuc_norm=dapi_norm(), params=reactive(r$mod4), r)
  # nseg = reactive({callModule(mod_n_segment_server, "n_segment_ui_1", nuc_norm=dapi_norm(), params=reactive(r$mod4), r)})
  
  #callModule(mod_ph_params_server, "ph_params_ui_1", r)
  
  #dapi_norm = callModule(mod_norm_ch_server, "norm_ch_ui_1", img=img1(), n=reactive(r$mod3$DAPI), r)
  #browser()

  
  
  #pheno_norm = reactive({callModule(mod_norm_ch_server, "norm_ch_ui_2", img=img1(), n=reactive(r$mod3$GFP), r)})
  #callModule(mod_n_segment_server, "n_segment_ui_1", nuc_norm=dapi_norm(), params=reactive(r$mod4), r)
  #callModule(mod_ph_segment_server, "ph_segment_ui_1", ph_norm=pheno_norm(), params=reactive(r$mod6), nseg=nseg1(), r)
  #nseg1 <- reactive({callModule(mod_n_segment_server, "n_segment_ui_1", nuc_norm=dapi_norm(), params=reactive(r$mod4), r)})
 
  
  
  # observeEvent(r$img_dir$path, {
  #   img1 <- reactive({callModule(mod_load_img_server, "load_img_ui_1", r, ix=reactive(1))})
  #   callModule(mod_display_ch_server, "display_ch_ui_1", img=img1(), n=reactive(1), r)
  #   callModule(mod_display_ch_server, "display_ch_ui_2", img=img1(), n=reactive(2), r)
  #   callModule(mod_display_ch_server, "display_ch_ui_3", img=img1(), n=reactive(3), r)
  #   callModule(mod_display_ch_server, "display_ch_ui_4", img=img1(), n=reactive(4), r)
  #   callModule(mod_select_ch_server, "select_ch_ui_1", r)
  #   callModule(mod_nuc_params_server, "nuc_params_ui_1", r)
  #   callModule(mod_ph_params_server, "ph_params_ui_1", r)
  #   dapi_norm = reactive({callModule(mod_norm_ch_server, "norm_ch_ui_1", img=img1(), n=reactive(r$mod3$DAPI), r)})
  #   pheno_norm = reactive({callModule(mod_norm_ch_server, "norm_ch_ui_2", img=img1(), n=reactive(r$mod3$GFP), r)})
  #   callModule(mod_n_segment_server, "n_segment_ui_1", nuc_norm=dapi_norm(), params=reactive(r$mod4), r)
  #   callModule(mod_ph_segment_server, "ph_segment_ui_1", ph_norm=pheno_norm(), params=reactive(r$mod6), nseg=nseg1(), r)
  #   
  #   nseg1 <- reactive({callModule(mod_n_segment_server, "n_segment_ui_1", nuc_norm=dapi_norm(), params=reactive(r$mod4), r)})
  #   
  #   callModule(mod_dl_params_server, "dl_params_ui_1", r)
  # })
  
  # img1 <- reactive({callModule(mod_load_img_server, "load_img_ui_1", r, ix=reactive(1))})
  # callModule(mod_display_ch_server, "display_ch_ui_1", img=img1(), n=reactive(1), r)
  # callModule(mod_display_ch_server, "display_ch_ui_2", img=img1(), n=reactive(2), r)
  # callModule(mod_display_ch_server, "display_ch_ui_3", img=img1(), n=reactive(3), r)
  # callModule(mod_display_ch_server, "display_ch_ui_4", img=img1(), n=reactive(4), r)
  # callModule(mod_select_ch_server, "select_ch_ui_1", r)
  # callModule(mod_nuc_params_server, "nuc_params_ui_1", r)
  # callModule(mod_ph_params_server, "ph_params_ui_1", r)
  # dapi_norm = reactive({callModule(mod_norm_ch_server, "norm_ch_ui_1", img=img1(), n=reactive(r$mod3$DAPI), r)})
  # pheno_norm = reactive({callModule(mod_norm_ch_server, "norm_ch_ui_2", img=img1(), n=reactive(r$mod3$GFP), r)})
  # callModule(mod_n_segment_server, "n_segment_ui_1", nuc_norm=dapi_norm(), params=reactive(r$mod4), r)
  # callModule(mod_ph_segment_server, "ph_segment_ui_1", ph_norm=pheno_norm(), params=reactive(r$mod6), nseg=nseg1(), r)
  # 
  # nseg1 <- reactive({callModule(mod_n_segment_server, "n_segment_ui_1", nuc_norm=dapi_norm(), params=reactive(r$mod4), r)})
  # 
  # callModule(mod_dl_params_server, "dl_params_ui_1", r)
  
  # observe({
  #   r$button = input$button
  # })
  # observe({
  #   r$int = input$int
  # })
  # 
  # # callModule(mod_classify_loop_server, "pos_classify_ui_1", r, reactive("pos"))
  # # callModule(mod_classify_loop_server, "neg_classify_ui_1", r, reactive("neg"))
  # 
  # #callModule(mod_cmodel_dir_server, "cmodel_dir_ui_1", r)
  # callModule(mod_create_model_server, "create_model_ui_1", r)
  # callModule(mod_test_model_server, "test_model_ui_1", r)
  # 
  # observe({
  #   r$button = input$button_n
  # })
  # 
  # # filenames = reactive({
  # #   path = r$img_dir$path
  # #   tifs = dir(paste0(path)[grep(".tif", dir(paste0(path)))])
  # #   filenames= as.list(tifs)
  # # })
  # # observe({
  # #   r$classify_input_int = input$int
  # # })
  # 
  # data = data.frame()
  # values= reactiveValues(data=data)
  # #rv = reactiveValues()
  # count = 0
  # 
  # observeEvent(input$button, {
  #   #browser()
  #   count <<- count + 1
  #   f = r$img_dir$files
  #   if (count == 0) {
  #     return(NULL)
  #   } else if (count <= length(f)) {
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
  #   f = r$img_dir$files
  #   count <<- count + 1
  #   if (count == 0) {
  #     return(NULL)
  #   } else if (count <= length(f)) {
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
  #     paste("positive_training.rds")
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
  # 
  # 
  # #callModule(mod_test_model_server, "test_model_1", r)
  # 
