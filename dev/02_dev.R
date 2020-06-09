# Building a Prod-Ready, Robust Shiny Application.
# 
# Each step is optional. 
# 

# 2. All along your project

## 2.1 Add modules
## 
# golem::add_module( name = "load_img" ) # Name of the module
# golem::add_module( name = "display_ch" ) # Name of the module
# golem::add_module( name = "select_ch" )
# golem::add_module( name = "nuc_params" )
#golem::add_module( name = "n_segment" )
#golem::add_module( name = "ph_params" )
# golem::add_module( name = "ph_segment" )
# golem::add_module( name = "dl_params" )
# golem::add_module( name = "dl_model" )
# golem::add_module( name = "load_testfiles" )
# golem::add_module( name = "dv_input" )
# golem::add_module( name = "test_model" )
#golem::add_module( name = "norm_ch")
#golem::add_module(name="classify")
#golem::add_module(name="img_dir")
#golem::add_module(name="create_model")
#golem::add_module(name="cmodel_dir")
#golem::add_module(name="img_setup")

#install.packages("shinyWidgets")

## 2.2 Add dependencies
#usethis::use_package("BiocInstaller")
usethis::use_package("shinyWidgets")
usethis::use_package( "BiocManager" )
usethis::use_package("yaImpute")
usethis::use_package( "EBImage" ) 
#usethis::use_package( "outliers" )
usethis::use_package( "shinycssloaders" )
#usethis::use_package( "shinyDND" )
#usethis::use_dev_package("shinyDirectoryInput")
usethis::use_package( "shinyjs" )
#usethis::use_package( "gplots" )
#usethis::use_package( "ROCR" )
usethis::use_package( "e1071" )
#usethis::use_package("shinyFiles")


## 2.3 Add tests

usethis::use_test( "app" )

## 2.4 Add a browser button

golem::browser_button()

## 2.5 Add external files

# golem::add_js_file( "script" )
# golem::add_js_handler( "handlers" )
# golem::add_css_file( "custom" )

# 3. Documentation

## 3.1 Vignette
usethis::use_vignette("SVMshiny")
devtools::build_vignettes()

## 3.2 Code coverage
## You'll need GitHub there
usethis::use_github()
#usethis::use_travis()
#usethis::use_appveyor()

# You're now set! 
# go to dev/03_deploy.R
#rstudioapi::navigateToFile("dev/03_deploy.R")
