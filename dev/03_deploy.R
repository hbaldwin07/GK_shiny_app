# Deploy a Prod-Ready, Robust Shiny Application.
# 
# 4. Test my package

devtools::test()
#rhub::check_for_cran()

# 5. Deployment elements

## 5.1 If you want to deploy on RStudio related platforms
#golem::add_rstudioconnect_file()
golem::add_shinyappsio_file()
#golem::add_shinyserver_file()
# 
getOption("repos")
#BiocManager::repositories()
library(BiocManager)
install.packages("BiocManager")
options(repos = BiocManager::repositories())
#BiocManager::repositories()
# 
# ## 5.2 If you want to deploy via a generic Dockerfile
# golem::add_dockerfile(
#   path = "DESCRIPTION",
#   output = "Dockerfile",
#   pkg = get_golem_wd(),
#   from = paste0("rocker/r-ver:", R.Version()$major, ".", R.Version()$minor),
#   as = NULL,
#   sysreqs = TRUE,
#   repos = c("https://cran.rstudio.com/", "https://bioconductor.org/packages/3.10/bioc"),
#   expand = FALSE,
#   open = TRUE,
#   update_tar_gz = TRUE,
#   build_golem_from_source = TRUE
# )

## 5.2 If you want to deploy to ShinyProxy
#golem::add_dockerfile_shinyproxy()

## 5.2 If you want to deploy to Heroku
#golem::add_dockerfile_heroku()
