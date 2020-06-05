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
        fileInput(ns("rds_file"), label=("Load the RDS file")),
        fileInput(ns("csv_file"), label=("Load the parameter (csv) file")),
        sliderInput(ns("dv"), label="SVM Decision Value", -5, 5, 0, step=0.1),
        sliderInput(ns("int"), label="Image intensity:", 1, 100, 5, step=1),
        downloadButton(ns("parameters"), "Download Settings")
      ),
      mainPanel(
        h4("Positive Cells (outlined)"),
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
  
  output$model_img = renderPlot({
    req(input$test_img, input$rds_file, input$csv_file)
    plot(pos_out())
  })

  dapi_norm = callModule(mod_norm_ch_server, id="norm_ch_ui_a", img=reactive(img()), n=reactive(param()$DAPI), r=r)
  ph_norm = callModule(mod_norm_ch_server, id="norm_ch_ui_b", img=reactive(img()), n=reactive(param()$GFP), r)
  nseg = callModule(mod_n_segment_server, "n_segment_ui_a", nuc_norm=reactive(dapi_norm()), params=reactive(param()), r)
    
    new_nseg = reactive({
      check = computeFeatures.shape(nseg())
      int.dapi = computeFeatures.basic(nseg(), dapi_norm())
      y=which(outliers::scores(int.dapi[,1], type="z", prob=0.95))
      tp = as.numeric(attr(y, "names"))
      nseg2 = rmObjects(nseg(), tp)
      df = as.data.frame(computeFeatures.shape(nseg2))
      xy = computeFeatures.moment(nseg2)[,c("m.cx", "m.cy")]
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
    
    new_cseg = callModule(mod_ph_segment_server, "ph_segment_ui_a", ph_norm=reactive(ph_norm()), params=reactive(param()), nseg=reactive(new_nseg()), r)
    
    table_test =  reactive({
      table_test_shape = computeFeatures.shape(new_cseg(),ph_norm())
      table_test_moment = computeFeatures.moment(new_cseg(),ph_norm())
      table_test_basic = computeFeatures.basic(new_cseg(),ph_norm())
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
      ll.temp$ph_norm = ph_norm()
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
      ph_n = var.list()$ph_norm
      pos_out = paintObjects(seg_selected, toRGB(ph_n*input$int), opac=c(1,0.8),col=c("Green",NA),thick=TRUE,closed=FALSE)
    })
    
    xx<-reactive({
      param.df = param()
      dv = data.frame("Decision Value"= c(input$dv))
      xx<-DF
    })
    
    output$parameters <- downloadHandler(
      
      filename <- function(){
        paste("table_new.csv",sep = "_")
      },
      content <- function(file) {
        write.csv(xx(), file, row.names = FALSE)
      }
    )
 }

## To be copied in the UI
# mod_test_model_ui("test_model_ui_1")

## To be copied in the server
# callModule(mod_test_model_server, "test_model_ui_1")
