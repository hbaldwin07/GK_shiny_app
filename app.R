pkgload::load_all(export_all = FALSE,helpers = FALSE,attach_testthat = FALSE)
options( "golem.app.prod" = TRUE)
SVMshiny::run_app() # add parameters here (if any)
# Launch the ShinyApp (Do not remove this comment)
# To deploy, run: rsconnect::deployApp()


