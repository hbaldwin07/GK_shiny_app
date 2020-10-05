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

  data = data.frame()
  values = reactiveValues(data=data)
  
  if (r$par == TRUE) {
    #browser()
      param = reactive({
        df.parameter <- r$csv
        if (is.null(df.parameter))
          return(NULL)
        param <- read.csv(df.parameter$datapath, stringsAsFactors = F)
      })
      n_dapi = param()$DAPI
      n_ph = param()$GFP
      pars_ph = param()
      pars_n = param()
  } else {
      n_dapi = r$mod3$DAPI
      n_ph = r$mod3$GFP
      pars_n = r$mod4
      pars_ph = r$mod6
  }
  
  img = callModule(mod_load_img_server, "mod_img_temp", ix=n, r=r)
  dapi = callModule(mod_norm_ch_server, "mod_dapi_temp", img=img, n=reactive(n_dapi), r=r)
  pheno = callModule(mod_norm_ch_server, "mod_pheno_temp", img=img, n=reactive(n_ph), r=r)
  nseg = callModule(mod_n_segment_server, "mod_nseg_temp", nuc_norm=dapi, params=reactive(pars_n), r=r)
  cseg = callModule(mod_ph_segment_server, "mod_cseg_temp", ph_norm=pheno, params=reactive(pars_ph), nseg=nseg, r=r)
  table = callModule(mod_classify_server, id="mod", r=r, img=img, cell_seg=cseg, ph_norm=pheno, classify=classify)
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

    
## To be copied in the UI
# mod_classify_loop_ui("classify_loop_ui_1")
    
## To be copied in the server
# callModule(mod_classify_loop_server, "classify_loop_ui_1")
 
