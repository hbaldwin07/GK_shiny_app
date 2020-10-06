# Module UI
  
#' @title   mod_create_model_ui and mod_create_model_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_create_model
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_create_model_ui <- function(id){
  ns <- NS(id)
  tagList(
    sidebarLayout(
      sidebarPanel(
        fileInput(ns("files"), 'Select (both) Training RDS Files',multiple = TRUE),
        div("# Positive Class Cells:", textOutput(ns("pos_n"))),
        br(),
        div("# Negative Class Cells:",textOutput(ns("neg_n"))),
        downloadButton(ns("model"), "Save model file")
      ),
      mainPanel(
        #h4("PCA Plot"),
        #plotOutput(ns("PCA"), width="100%", height="800px")
        plotOutput(ns("PCA"))
      )
    )
  )
}

# Module Server
    
#' @rdname mod_create_model
#' @export
#' @keywords internal
    
mod_create_model_server <- function(input, output, session, r){
  ns <- session$ns
  
  observeEvent(input$files, {
    rds_files = input$files
    #browser()
    f1 = rds_files[,4]
    Ts.training_sum <- reactive({
    Ts.temp<-NULL
      for (i in 1:length(f1)){
          #browser()
          rds1 = readRDS(f1[i])
          Ts.temp<-rbind(Ts.temp,rds1)
          rm(rds1)
      }
      Ts.training_sum = Ts.temp
    })
    pos_n <- reactive({
      length(which(Ts.training_sum()$predict=="P"))})
    neg_n <- reactive({
      length(which(Ts.training_sum()$predict=="N"))})

    output$pos_n <- renderText({pos_n()})
    output$neg_n <- renderText({neg_n()})

    Ts.training <- reactive({
      
      Ts.training_sum = Ts.training_sum()
      #Ts.training_sum <- Ts.training_sum()[!duplicated(Ts.training_sum()[c("b.sd", "b.mad")]),]
      ind <- which(!Ts.training_sum$predict=="0")
      Ts.training_sum <- Ts.training_sum[ind,]
      
      ind.P <- which(Ts.training_sum$predict == "P")
      ind.N <- which(Ts.training_sum$predict == "N")
      
      if (neg_n() > pos_n()) {
        Ts.training_sum_N <- Ts.training_sum[sample(ind.N, pos_n()),]
        Ts.training_sum_P <- Ts.training_sum[ind.P,]
      } else {
        Ts.training_sum_N <- Ts.training_sum[ind.N, ]
        Ts.training_sum_P <- Ts.training_sum[sample(ind.P, neg_n()),]
        }
      Ts.training <- rbind(Ts.training_sum_N, Ts.training_sum_P)
    })
    output$PCA <- renderPlot({
      #browser()
      Ts <- Ts.training()
      colnames(Ts) <- c("rownameTable","mean intensity", "sd intensity", "mad intesity", "1% intensity", "5% intensity", "50% intensity","95% intensity","99 intensity","center of mass,x", "center of mass,y","major axis","eccentricity", "angle","area","perimeter","radius.mean","radius.sd","radius.min","radius.max","predict")
      myPr <- prcomp(Ts[,2:19], scale=TRUE)
      g1 <- ggbiplot::ggbiplot(myPr, obs.scale = 1, var.scale=1, groups=F, ellipse=F, circle=F, alpha=0.2) +
        ggplot2::theme(axis.title = ggplot2::element_text(size=14),
                       axis.text=ggplot2::element_text(size=12),
                       axis.line=ggplot2::element_line(color="black", size=1),
                       panel.border=ggplot2::element_blank(), panel.background = ggplot2::element_blank()) +
        ggplot2::labs(title="PCA: feature selection") +
        ggplot2::theme(plot.title=ggplot2::element_text(hjust=0.5), 
                       panel.grid.minor=ggplot2::element_line(color="white"), legend.position = "none")
      tryCatch(g1, message="Loading...")
    })
    
    mymodel <- reactive({
      x <- (Ts.training()[,2:12])
      y <- Ts.training()[,21]
      dataTest <- data.frame(x,y)
      acc <- rep(0, 10)
      #TestIndex <- sample(nrow(x), round(nrow(x)/2))
      mymodel <- e1071::svm(y~., data=dataTest, kernel="linear", type="C", cost=5, degree=45)
      return(mymodel)
    })
    output$model <- downloadHandler(
      filename <- function() {
        paste("mymodel.rds")},
      content <- function(file) {
        model <- mymodel()
        saveRDS(model, file=file)
      })
  } )
  
  # path = reactive({
  #   path = r$model$path
  # })
  # Ts.training_sum <- reactive({
  #   #browser()
  #   path = path()
  #   rds <- dir(paste0(path)[grep(".rds", dir(paste0(path)))])
  #   Ts.training <- readRDS(paste0(path, "/", rds[1]))
  #   Ts.training.sum <- Ts.training
  #   for (l in 2:length(rds)) {
  #     Ts.training <- readRDS(paste0(path, "/", rds[l]))
  #     Ts.training.sum <- rbind(Ts.training.sum, Ts.training)
  #   }
  #   Ts.training_sum <- as.data.frame(Ts.training.sum)
  # })
  # pos_n <- reactive({
  #   length(which(Ts.training_sum()$predict=="P"))})
  # neg_n <- reactive({
  #   length(which(Ts.training_sum()$predict=="N"))})
  # 
  # output$pos_n <- renderText({pos_n()})
  # output$neg_n <- renderText({neg_n()})
  #       
  # Ts.training <- reactive({
  #   #browser()
  #   ind <- which(!Ts.training_sum()$predict=="0")
  #   Ts.training_sum <- Ts.training_sum()[ind,]
  #   Ts.training_sum <- Ts.training_sum[!duplicated(Ts.training_sum()[c("b.sd", "b.mad")]),]
  #   ind.P <- which(Ts.training_sum$predict == "P")
  #   ind.N <- which(Ts.training_sum$predict == "N")
  #   if (neg_n() > pos_n()) {
  #     Ts.training_sum_N <- Ts.training_sum[sample(ind.N, pos_n()),]
  #     Ts.training_sum_P <- Ts.training_sum[ind.P,]
  #   } else {Ts.training_sum_N <- Ts.training_sum[ind.N, ]
  #   Ts.training_sum_P <- Ts.training_sum[sample(ind.P, neg_n()),]}
  #   Ts.training <- rbind(Ts.training_sum_N, Ts.training_sum_P)
  # })
  # output$PCA <- renderPlot({
  #   Ts <- Ts.training()
  #   colnames(Ts) <- c("rownameTable","mean intensity", "sd intensity", "mad intesity", "1% intensity", "5% intensity", "50% intensity","95% intensity","99 intensity","center of mass,x", "center of mass,y","major axis","eccentricity", "angle","area","perimeter","radius.mean","radius.sd","radius.min","radius.max","predict")
  #   myPr <- prcomp(Ts[,2:19], scale=TRUE)
  #   g1 <- ggbiplot::ggbiplot(myPr, obs.scale = 1, var.scale=1, groups=F, ellipse=F, circle=F, alpha=0.2) +
  #     ggplot2::theme(axis.title = ggplot2::element_text(size=14), 
  #                    axis.text=ggplot2::element_text(size=12), 
  #                    axis.line=ggplot2::element_line(color="black", size=1), 
  #                    panel.border=ggplot2::element_blank(), panel.background = ggplot2::element_blank()) +
  #     ggplot2::labs(title="PCA: feature selection") +
  #     ggplot2::theme(plot.title=ggplot2::element_text(hjust=0.5), panel.grid.minor=ggplot2::element_line(color="white"), legend.position = "none")
  #   tryCatch(g1, message="Loading...")
  # })
  # mymodel <- reactive({
  #   x <- (Ts.training()[,2:12])
  #   y <- Ts.training()[,21]
  #   dataTest <- data.frame(x,y)
  #   acc <- rep(0, 10)
  #   #TestIndex <- sample(nrow(x), round(nrow(x)/2))
  #   mymodel <- e1071::svm(y~., data=dataTest, kernel="linear", type="C", cost=5, degree=45)
  #   return(mymodel)
  # })
  # output$model <- downloadHandler(
  #   filename <- function() {
  #     paste("mymodel.rds")},
  #   content <- function(file) {
  #     model <- mymodel()
  #     saveRDS(model, file=file)
  #   })
}
    
## To be copied in the UI
# mod_create_model_ui("create_model_ui_1")
    
## To be copied in the server
# callModule(mod_create_model_server, "create_model_ui_1")
 
