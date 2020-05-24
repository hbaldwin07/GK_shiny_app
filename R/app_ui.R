#' @import shiny
#' @import EBImage
app_ui <- function() {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    fluidPage(
      h1("svm2"),
      tabsetPanel(
        tabPanel("Image Setup",
                 sidebarLayout(
                   sidebarPanel(
                     mod_img_dir_ui("img_dir_ui_1"),
                     actionButton("reset_input","Reset inputs"),
                     h4("Choose Channel Inputs"),
                     mod_select_ch_ui("select_ch_ui_1")
                   ),
                   mainPanel(
                     #textOutput("test")
                     tabsetPanel(
                       tabPanel("Channel 1", mod_display_ch_ui("display_ch_ui_1")),
                       tabPanel("Channel 2", mod_display_ch_ui("display_ch_ui_2")),
                       tabPanel("Channel 3", mod_display_ch_ui("display_ch_ui_3")),
                       tabPanel("Channel 4", mod_display_ch_ui("display_ch_ui_4"))
                     )
                   )
                 )),
        tabPanel("Image Segmentation",
                 tabsetPanel(
                   tabPanel("Nucleus Segmentation",
                            sidebarLayout(
                              sidebarPanel(
                                mod_nuc_params_ui("nuc_params_ui_1")
                              ),
                              mainPanel(
                                mod_n_segment_ui("n_segment_ui_1")
                              )
                            )),
                   tabPanel( "Phenotype Segmentation",
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
                 tabsetPanel(
                   tabPanel("Positive",
                            sidebarLayout(
                              sidebarPanel(
                                actionButton(("button"), label="Load Image / Save"),
                                sliderInput(("int"), "Image Intensity:",1,500,100, step=5),
                                downloadButton(("dl_training_P"),
                                               label="Save Classification File"),
                                HTML('<script type="text/javascript">
                                $(document).ready(function() {
                                $("#button").click(function() {
                                $("#pos_class_ui").text("Loading...");
                                });
                                });
                                     </script>')
                                ),
                              mainPanel(
                                uiOutput("pos_class_ui"))
                              )
                            )
                   )),
                           
        tabPanel("Create Model", 
                 fluidRow(
                   mod_cmodel_dir_ui("cmodel_dir_ui_1")
                 ),
                 fluidRow(
                   mod_create_model_ui("create_model_ui_1")
                 )
        ),
        tabPanel("Test Model",
                 mod_test_model_ui("test_model_ui_1")
        )
      )
    )
  )
}
        
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
    'www', system.file('app/www', package = 'svm2')
  )
  
  tags$head(
    golem::activate_js(),
    golem::favicon()
    # Add here all the external resources
    # If you have a custom.css in the inst/app/www
    # Or for example, you can add shinyalert::useShinyalert() here
    #tags$link(rel="stylesheet", type="text/css", href="www/custom.css")
  )
}
