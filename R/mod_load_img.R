# Module UI
  
#' @title   mod_load_img_ui and mod_load_img_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_load_img
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_load_img_ui <- function(id){
  ns <- NS(id)
  tagList(
  )
}
    
# Module Server
    
#' @rdname mod_load_img
#' @export
#' @keywords internal
    
mod_load_img_server <- function(input, output, session, r, ix){
  ns <- session$ns
  #browser()
  
  path = reactive({
    path = r$img_dir$path
  })

  f = reactive({
    req(path())
    #path = r$img_dir$path
    #tifs = dir(paste0(path())[grep(".tif", dir(paste0("/",path())))])
    #tifs = dir(paste0(path)[grep(".tif", dir(paste0(path)))])
    tifs = dir(path())[grep(".tif", dir(path()))]
    f = tifs
    #browser()
  })
  img = reactive({
    req(f(), path())
    f = f()
    i=as.numeric(ix())
    readImage(paste0(path(), "/", f[i]))
  })
  return(img)
  
  # observeEvent(ignoreNULL = TRUE, eventExpr = {r$img_dir$path}, 
  #              handlerExpr = {
  #                path = reactive({
  #                  path = r$img_dir$path
  #                })
  #                
  #                f = reactive({
  #                  req(path())
  #                  tifs = dir(paste0(path())[grep(".tif", dir(paste0(path())))])
  #                  f = tifs
  #                })
  #                img = reactive({
  #                  req(f(), path())
  #                  f = f()
  #                  i=as.numeric(ix())
  #                  #browser()
  #                  readImage(paste0(path(), f[i]))
  #                })
  #                return(img) 
  #              })
}
    
## To be copied in the UI
# mod_load_img_ui("load_img_ui_1")
    
## To be copied in the server
# callModule(mod_load_img_server, "load_img_ui_1")
 
