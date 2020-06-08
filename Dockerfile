FROM rocker/r-ver:3.6.2
RUN apt-get update && apt-get install -y  git-core libcurl4-openssl-dev libfftw3-dev libgit2-dev libpng-dev libssh2-1-dev libssl-dev libxml2-dev make pandoc pandoc-citeproc zlib1g-dev && rm -rf /var/lib/apt/lists/*
RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site
RUN echo "options(repos = c(CRAN = 'https://bioconductor.org/packages/3.10/bioc'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site
RUN R -e 'install.packages("remotes")'
RUN R -e 'remotes::install_github("r-lib/remotes", ref = "97bbf81")'
RUN Rscript -e 'remotes::install_version("shiny",upgrade="never", version = "1.4.0.2")'
RUN Rscript -e 'remotes::install_version("golem",upgrade="never", version = "0.2.1")'
RUN Rscript -e 'remotes::install_version("processx",upgrade="never", version = "3.4.2")'
RUN Rscript -e 'remotes::install_version("attempt",upgrade="never", version = "0.3.1")'
RUN Rscript -e 'remotes::install_version("DT",upgrade="never", version = "0.13")'
RUN Rscript -e 'remotes::install_version("glue",upgrade="never", version = "1.4.1")'
RUN Rscript -e 'remotes::install_version("htmltools",upgrade="never", version = "0.4.0")'
RUN Rscript -e 'remotes::install_version("BiocManager",upgrade="never", version = "1.30.10")'
RUN Rscript -e 'remotes::install_version("yaImpute",upgrade="never", version = "1.0-32")'
RUN Rscript -e 'remotes::install_version("EBImage",upgrade="never", version = "4.28.1")'
RUN Rscript -e 'remotes::install_version("shinycssloaders",upgrade="never", version = "0.3")'
RUN Rscript -e 'remotes::install_version("shinyjs",upgrade="never", version = "1.1")'
RUN Rscript -e 'remotes::install_version("e1071",upgrade="never", version = "1.7-3")'
RUN Rscript -e 'remotes::install_version("pkgload",upgrade="never", version = "1.0.2")'
RUN Rscript -e 'remotes::install_version("shinyFeedback",upgrade="never", version = "0.2.0")'
RUN Rscript -e 'remotes::install_version("testthat",upgrade="never", version = "2.3.2")'
RUN Rscript -e 'remotes::install_version("knitr",upgrade="never", version = "1.28")'
RUN Rscript -e 'remotes::install_version("rmarkdown",upgrade="never", version = "2.1")'
RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone
RUN R -e 'remotes::install_local(upgrade="never")'
EXPOSE 80
CMD R -e "options('shiny.port'=80,shiny.host='0.0.0.0');SVMshiny::run_app()"
