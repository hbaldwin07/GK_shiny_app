#' @import shiny
#' @import EBImage
app_ui <- function() {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    fluidPage(
      h1("SVM Cell Classification Model"),
      tabsetPanel(
        tabPanel("Image Setup",
                 mod_img_setup_ui("img_setup_ui_1")
                 ),
        tabPanel("Segmentation",
          tabsetPanel(
            tabPanel("Nucleus Segmentation",
                     sidebarLayout(
                       sidebarPanel(
                         mod_nuc_params_ui("nuc_params_ui_1")
                       ),
                       mainPanel(
                         mod_n_segment_ui("n_segment_ui_1")
                       )
                     )
                     ),
            tabPanel("Cell Segmentation",
                     sidebarLayout(
                       sidebarPanel(
                         mod_ph_params_ui("ph_params_ui_1")              
                       ),
                       mainPanel(
                         mod_ph_segment_ui("ph_segment_ui_1")
                       )
                     )
                     ), 
            tabPanel("Save Image Parameters",
                     mod_dl_params_ui("dl_params_ui_1")
            )
          )
        ),
        tabPanel("Image Classification",
                 wellPanel(
                   style = "padding: 1px; height: 20 px",
                   fluidRow(
                     column(6, checkboxInput("up_par", label = "Upload Segmentation Parameters?", value=FALSE) ),
                     column(6,uiOutput("params_ui") )
                   )
                 ),
                 tabsetPanel(
                   tabPanel("Positive", 
                            sidebarLayout(
                              sidebarPanel(
                                mod_img_dir_ui("img_dir_ui_1"),
                                actionButton(("button"), label="Load Image"),
                                br(),
                                br(),
                                downloadButton(("dl_training_P"),label="Save (+) Classification File"),
                              ),
                              mainPanel(
                                h4("Select Positive Cells"),
                                mod_classify_loop_ui("mod_classify_loop_ui_1")
                              )
                            )
                   ),
                   tabPanel("Negative", 
                            sidebarLayout(
                              sidebarPanel(
                                mod_img_dir_ui("img_dir_ui_2"),
                                actionButton(("button_n"), label="Load Image"),
                                downloadButton(("dl_training_N"),label="Save (-) Classification File"),
                              ),
                              mainPanel(
                                h4("Select Nositive Cells"),
                                mod_classify_loop_ui("mod_classify_loop_ui_2")
                              )
                            )
                   )
                 )
                   
        ),
        tabPanel("Create Model",
                 mod_create_model_ui("create_model_ui_1")
                 ),
        tabPanel("Test Model", 
                 mod_test_model_ui("test_model_ui_1"))
      )
    )
  )
}

#          tabsetPanel(
#            tabPanel("Positive",
#                     sidebarLayout(
#                       sidebarPanel(
#                         actionButton(("button"), label="Load Image / Save"),
#                         sliderInput(("int"), "Image Intensity:",1,500,100, step=5)
#                         # ,
#                         # downloadButton(("dl_training_P"),
#                         #                label="Save Classification File")
#                         #,
#                         # HTML('<script type="text/javascript">
#                         # $(document).ready(function() {
#                         # $("#button").click(function() {
#                         # $("#pos_class_ui").text("Loading...");
#                         # });
#                         # });
#                         #      </script>')
#                         ),
#                       mainPanel(
#                         #mod_classify_loop_ui("classify_loop_ui_1"))
#                         uiOutput("class_ui")
        # ,
        # tabPanel("Image Segmentation",
        #          tabsetPanel(
        #            tabPanel("Nucleus Segmentation",
        #                     sidebarLayout(
        #                       sidebarPanel(
        #                         mod_nuc_params_ui("nuc_params_ui_1")
        #                       ),
        #                       mainPanel(
        #                         mod_n_segment_ui("n_segment_ui_1")
        #                       )
        #                     ))
                   # ,
                   # tabPanel( "Phenotype Segmentation",
                   #           sidebarLayout(
                   #             sidebarPanel(
                   #               mod_ph_params_ui("ph_params_ui_1")
                   #             ),
                   #             mainPanel(
                   #               mod_ph_segment_ui("ph_segment_ui_1")
                   #             )
                   #           )
                   # ),
                   # tabPanel("Save Image Parameters",
                   #          mod_dl_params_ui("dl_params_ui_1")
                   # )
#                  )
#         )
#         #,
#       )
#     )
#   )
# }
        # ,
        # tabPanel("Image Segmentation",
        #          tabsetPanel(
        #            tabPanel("Nucleus Segmentation",
        #                     sidebarLayout(
        #                       sidebarPanel(
        #                         mod_nuc_params_ui("nuc_params_ui_1")
        #                       ),
        #                       mainPanel(
        #                         mod_n_segment_ui("n_segment_ui_1")
        #                       )
        #                     )),
        #            tabPanel( "Phenotype Segmentation",
        #                      sidebarLayout(
        #                        sidebarPanel(
        #                          mod_ph_params_ui("ph_params_ui_1")
        #                        ),
        #                        mainPanel(
        #                          mod_ph_segment_ui("ph_segment_ui_1")
        #                        )
        #                      )
        #            ),
        #            tabPanel("Save Image Parameters",
        #                     mod_dl_params_ui("dl_params_ui_1")
        #            )
        #          )
        # ),
        # tabPanel("Image Classification",
        #          tabsetPanel(
        #            tabPanel("Positive",
        #                     sidebarLayout(
        #                       sidebarPanel(
        #                         actionButton(("button"), label="Load Image / Save"),
        #                         sliderInput(("int"), "Image Intensity:",1,500,100, step=5)
        #                         # ,
        #                         # downloadButton(("dl_training_P"),
        #                         #                label="Save Classification File")
        #                         #,
        #                         # HTML('<script type="text/javascript">
        #                         # $(document).ready(function() {
        #                         # $("#button").click(function() {
        #                         # $("#pos_class_ui").text("Loading...");
        #                         # });
        #                         # });
        #                         #      </script>')
        #                         ),
        #                       mainPanel(
        #                         #mod_classify_loop_ui("classify_loop_ui_1"))
        #                         uiOutput("class_ui")
        #                       ))),
        #                     
        #              tabPanel("Negative",
        #                       sidebarLayout(
        #                         sidebarPanel(
        #                           actionButton(("button_n"), "Load Image / Save"),
        #                           sliderInput(("int_n"), "Image Intensity:",1,500,100, step=5)
        #                           #,
        #                           # downloadButton(("dl_training_N"), label="Save Classification File"),
        #                           # HTML('<script type="text/javascript">
        #                           # $(document).ready(function() {
        #                           # $("#button_n").click(function() {
        #                           # $("#neg_class_ui").text("Loading...");
        #                           # });
        #                           # });
        #                           #      </script>')),
        #                         ),
        #                         mainPanel(
        #                           uiOutput("neg_class_ui"))
        #                       )))),
        # tabPanel("Create Model", 
        #          # fluidRow(
        #          #   mod_cmodel_dir_ui("cmodel_dir_ui_1")
        #          # ),
        #          fluidRow(
        #            mod_create_model_ui("create_model_ui_1")
        #          )
        # ),
        # tabPanel("Test Model",
        #          mod_test_model_ui("test_model_ui_1")
        # )
#       )
#     )
#   )
# }
        
        # tabPanel("Image Classification",
        #          tabsetPanel(
        #            tabPanel("Positive",
        #                     sidebarLayout(
        #                       sidebarPanel(
        #                         actionButton(("button"), label="Load Image / Save"),
        #                         sliderInput(("int"), "Image Intensity:",1,500,100, step=5)),
        #                         # ,
        #                         # downloadButton(("dl_training_P"),
        #                         #                label="Save Classification File"),
        #                         # HTML('<script type="text/javascript">
        #                         # $(document).ready(function() {
        #                         # $("#button").click(function() {
        #                         # $("#pos_class_ui").text("Loading...");
        #                         # });
        #                         # });
        #                         #      </script>')
        #                         # ),
        #                       mainPanel(
        #                         mod_classify_loop_ui("pos_classify_ui_1"))))),
                   
                            
                           # mod_classify_loop_ui("pos_classify_ui_1")
                            # sidebarLayout(
                            #   sidebarPanel(
                            #     actionButton(("button"), label="Load Image / Save"),
                            #     sliderInput(("int"), "Image Intensity:",1,500,100, step=5),
                            #     downloadButton(("dl_training_P"), 
                            #                    label="Save Classification File"),
                            #     HTML('<script type="text/javascript">
                            #     $(document).ready(function() {
                            #     $("#button").click(function() {
                            #     $("#pos_class_ui").text("Loading...");
                            #     });
                            #     });
                            #          </script>')
                            #     ),
                            #   mainPanel(
                            #     uiOutput("pos_class_ui"))
                 #            )),
                 #   tabPanel("Negative",
                 #            mod_classify_loop_ui("neg_classify_ui_1")
                 #            # sidebarLayout(
                 #            #   sidebarPanel(
                 #            #     actionButton(("button_n"), "Load Image / Save"),
                 #            #     sliderInput(("int"), "Image Intensity:",1,500,100, step=5),
                 #            #     downloadButton(("dl_training_N"), label="Save Classification File"),
                 #            #     HTML('<script type="text/javascript">
                 #            #     $(document).ready(function() {
                 #            #     $("#button_n").click(function() {
                 #            #     $("#neg_class_ui").text("Loading...");
                 #            #     });
                 #            #     });
                 #            #          </script>')),
                 #            #   mainPanel(
                 #            #     uiOutput("neg_class_ui"))
                 #            # ))
                 # )),


#' @import shiny
golem_add_external_resources <- function(){
  
  addResourcePath(
    'www', system.file('app/www', package = 'SVMshiny')
  )
  
  tags$head(
    golem::activate_js(),
    #golem::favicon()
    # Add here all the external resources
    # If you have a custom.css in the inst/app/www
    # Or for example, you can add shinyalert::useShinyalert() here
    #tags$link(rel="stylesheet", type="text/css", href="www/custom.css")
  )
}
