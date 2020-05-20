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
        actionButton(ns("img_button"), label="Show Image"),
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
  
  observeEvent(input$img_button, {
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
    browser()
    dapi_norm = reactive({callModule(mod_norm_ch_server, "norm_ch_ui_a", img=img(), n=reactive(param()$DAPI), r)})
    pheno_norm = reactive({callModule(mod_norm_ch_server, "norm_ch_ui_b", img=img(), n=reactive(param()$GFP), r)})
    nseg = reactive({callModule(mod_n_segment_server, "n_segment_ui_a", nuc_norm=dapi_norm(), params=reactive(param()), r)})
    #cseg = reactive({callModule(mod_ph_segment_server, "ph_segment_ui_1", ph_norm=pheno_norm(), params=reactive(param()), nseg=nseg(), r)})
    
    new_nseg = reactive({
      int.dapi = computeFeatures.basic(nseg(), dapi_norm())
      y=which(scores(int.dapi[,1], type="z", prob=0.95))
      tp = as.numeric(attr(y, "names"))
      nseg2 = rmObjects(nseg(), tp)
      df = as.data.frame(computeFeatures.shape(nseg2))
      xy = computeFeatures.moment(nseg1)[,c("m.cx", "m.cy")]
      df = cbind(df, xy)
      df2 = as.data.frame(matrix(0, nrow(xy), 5))
      colnames(df2) = c("x", "y", "area_real", "area_circ", "ratio")
      df2$x = xy[,1]
      df2$y = xy[,2]
      df2$area_real = df[,1]
      df2$area_circ = pi*(df[,3])^2
      df2$ratio = df2[,4]/df[,1]
      nr = which(df2[,5]>1)
      new_seg = rmObjects(nseg2, nr)
    })
    new_cseg = reactive({callModule(mod_ph_segment_server, "ph_segment_ui_a", ph_norm=pheno_norm(), params=reactive(params), nseg=new_nseg(), r)})
    
    table_test =  reactive({
      table_test_shape = computeFeatures.shape(new_cseg(),pheno_norm())
      table_test_moment = computeFeatures.moment(new_cseg(),pheno_norm())
      table_test_basic = computeFeatures.basic(new_cseg(),pheno_norm())
      table_test= data.frame(cbind(table_test_basic,table_test_moment,table_test_shape))
    })
    
    var.list = reactive({
      ll.temp = list()
      
      rownametable= row.names(table_test())
      table_test= data.frame(cbind(rownametable,table_test()))
      Ts.mix = table_test[,2:12]
      rownametable2 = table_test[,1]
      
      xy = computeFeatures.moment(new_cseg())[,c("m.cx", "m.cy")]
      
      ll.temp$Ts.mix = Ts.mix
      ll.temp$table_test = table_test
      ll.temp$rownameTable = rownametable2
      ll.temp$new_seg = new_nseg()
      ll.temp$ph_norm = pheno_norm()
      ll.temp$cseg = new_cseg()
      ll.temp$xy = xy
      var.list = ll.temp
    })
    
    cseg_pos = reactive({
      ll.temp = list()
      imglist = var.list()
      Ts.mix = imglist$Ts.mix
      table_test = imglist$table_test
      rownameTable = imglist$rownameTable
      cseg = imglist$cseg
      ph_n = imglist$ph_norm
      y.pred = predict(mymodel(), Ts.mix, decision.values=T)
      length(y.pred)
      d = attr(y.pred, "decision.values")
      new.y.pred = rep("P", length(y.pred))
      new_cutoff = input$dv
      new.y.pred[d>new_cutoff]="N"
      length(new.y.pred)
      d = round(d, 1)
      Ts.mix$pred = as.array(new.y.pred)
      Ts.mix = Ts.mix[1:length(table_test[,1]),]
      Ts.mix$rownameTable = rownameTable
      nr = which(Ts.mix$pred %in% "P")
      seg_pos = rmObjects(cseg, nr)
      ll.temp$segpos = seg_pos
      cseg_pos = ll.temp
    })
    pos_out = reactive({
      seg_selected = cseg_pos()$segpos
      ph_n = imageAnalysis.list()$ph_norm
      pos_out = paintObjects(seg_selected, toRGB(ph_n), opac=c(1,0.8),col=c("Green",NA),thick=TRUE,closed=FALSE)
    })
    output$model_img = renderPlot({
      plot(pos_out())
    })
    
    # imageAnalysis.list <- reactive({
    #   # ll.temp <- list()
    #   # params <- param()
    #   # size <- as.numeric(dim(img()))
    #   # dapi_norm = callModule(mod_norm_ch_server, "norm_ch_ui_a", img=img(), n=reactive(params$DAPI), r)
    #   # pheno_norm = callModule(mod_norm_ch_server, "norm_ch_ui_b", img=img(), n=reactive(params$GFP), r)
    #   # nseg = callModule(mod_n_segment_server, "n_segment_ui_a", nuc_norm=dapi_norm(), params=reactive(params), r)
    #   # #cseg = callModule(mod_ph_segment_server, "ph_segment_ui_1", ph_norm=pheno_norm(), params=reactive(params), nseg=nseg1(), r)
    #   # int.dapi = computeFeatures.basic(nseg, dapi_norm)
    #   # y=which(scores(int.dapi[,1], type="z", prob=0.95))
    #   # tp = as.numeric(attr(y, "names"))
    #   # nseg2 = rmObjects(nseg, tp)
    #   # df = as.data.frame(computeFeatures.shape(nseg2))
    #   # xy = computeFeatures.moment(nseg1)[,c("m.cx", "m.cy")]
    #   # df = cbind(df, xy)
    #   # df2 = as.data.frame(matrix(0, nrow(xy), 5))
    #   # colnames(df2) = c("x", "y", "area_real", "area_circ", "ratio")
    #   # df2$x = xy[,1]
    #   # df2$y = xy[,2]
    #   # df2$area_real = df[,1]
    #   # df2$area_circ = pi*(df[,3])^2
    #   # df2$ratio = df2[,4]/df[,1]
    #   # nr = which(df2[,5]>1)
    #   # new_seg = rmObjects(nseg2, nr)
    #   # cseg = callModule(mod_ph_segment_server, "ph_segment_ui_a", ph_norm=pheno_norm(), params=reactive(params), nseg=reactive(new_seg), r)
    #   # table_test_shape = computeFeatures.shape(cseg,pheno_norm)
    #   # table_test_moment = computeFeatures.moment(cseg,pheno_norm)
    #   # table_test_basic = computeFeatures.basic(cseg,pheno_norm)
    #   # table_test= data.frame(cbind(table_test_basic,table_test_moment,table_test_shape))
    #   # rownametable= row.names(table_test)
    #   # table_test= data.frame(cbind(rownametable,table_test))
    #   # Ts.mix = table_test[,2:12]
    #   # rownametable2 = table_test[,1]
    #   # ll.temp$Ts.mix = Ts.mix
    #   # ll.temp$table_test = table_test
    #   # ll.temp$rownameTable = rownametable2
    #   # ll.temp$new_seg = new_seg
    #   # ll.temp$ph_norm = pheno_norm
    #   # ll.temp$cseg = cseg
    #   # ll.temp$xy = xy
    #   # imageAnalysis.list = ll.temp
    # })
   
  })

}
    
## To be copied in the UI
# mod_test_model_ui("test_model_ui_1")
    
## To be copied in the server
# callModule(mod_test_model_server, "test_model_ui_1")
 