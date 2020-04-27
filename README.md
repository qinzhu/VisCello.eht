VisCello for Endothelial to Hematopoietic Transition
================
Qin Zhu, Nancy A. Speck, Kai Tan


About VisCello.eht
------------------------

This is a tool for interactive visualization of single cell data of endothelial to hematopoietic transition data from the following publication:

*Zhu, Q., Gao, P., Tober, J., Bennett, L., Chen, C., Uzun, Y., Li, Y., Mumau, M., Yu, W., He, B.,  Speck, N. and Tan. K, 2019. Developmental trajectory of pre-hematopoietic stem cell formation from endothelium. bioRxiv, p.848846.*

You can download and install it as an R package, following intruction below.  

You can also find online version of this tool here: https://cello.shinyapps.io/sceht/. Due to limit on computational resources with current server, we excluded expression of some genes in this online version of EHT explorer. You can explore the full version with VisCello.eht R package in this github repo. We apologize for this inconvenience.

This tool only includes cells on the EHT trajectory for data exploration purpose. It does not include all cells we collected (e.g., cells from genetic perturbation experiments). You can download full dataset from GEO: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE137117.

For using VisCello for other single cell data visualization, please check https://github.com/qinzhu/VisCello.

Screenshot:

[![Alt text](inst/app/www/screenshot.png?raw=true "VisCello screenshot")](https://cello.shinyapps.io/sceht/)


Installation
--------------------------------------

Due to large data file currently being hosted on Git LFS, you cannot use devtools::install_github to install this package. 
Please follow protocol listed below to install:

0. Windows and Linux: install git from https://git-scm.com/book/en/v2/Getting-Started-Installing-Git. 

    MACOS and Linux: Install git-lfs from https://git-lfs.github.com/ (See FAQ for example installation using brew or conda).
    
    Any system: Install R (>3.5.0 required) and latest bioconductor (code below, copy and paste inside R):
    
    ```
    if (!requireNamespace("BiocManager"))
    install.packages("BiocManager")
    BiocManager::install()
    # For first time installer, if prompted "Update all/some/none? [a/s/n]", type a and press return.
    ```

1. In terminal copy paste followng line by line with return:

    ```
    git lfs clone https://github.com/qinzhu/VisCello.eht.git
    R   #Launch R, Windows user open R/Rstudio, setwd() to parent folder of VisCello. 
    ```

2. Now inside R and do the following (line by line):

    ``` r
    install.packages("devtools") 
    devtools::install_local("VisCello.eht", force=T)
    ```

    Now VisCello is ready to go! To launch Viscello, in R:

    ``` r
    library(VisCello.eht)
    cello()
    ```
  
  If you have also installed VisCello, please make sure you do not load VisCello in the same session, as some functions are re-used and may lead to conflicts.

FAQ
-------------------------

* Q: Got installation error: `Error in readRDS("data/eset.rds"): unknown input format`
    
    A: Install git-lfs from Install git-lfs from https://git-lfs.github.com/ and then go to step 1. Example code using brew or conda:
    
    ```
    brew install git-lfs
    git lfs install
    git-lfs clone https://github.com/qinzhu/VisCello.eht.git
    ```
    
    ```
    conda install -c conda-forge git-lfs
    git lfs install
    git-lfs clone https://github.com/qinzhu/VisCello.eht.git
    ```

* Q: Got installation error when running devtools::install_local: `package 'AnnotationDbi' was built under R version xxx, lazy loading failed for package xx`.

  A: Run following code in R:
  
    ```
    BiocManager::install(c("GO.db", "DO.db"))
    install.packages("VisCello.eht", repos = NULL, type = "source")
    ```
  

* Q: Can I use VisCello to explore my own data?
    
  A: Yes. Please use the general version: https://github.com/qinzhu/VisCello and kindly cite VisCello if you use it for publication.
  


Cite our EHT dataset
-------------------------

Zhu, Q., Gao, P., Tober, J., Bennett, L., Chen, C., Uzun, Y., Li, Y., Mumau, M., Yu, W., He, B.,  Speck, N. and Tan. K, 2019. Developmental trajectory of pre-hematopoietic stem cell formation from endothelium. bioRxiv, p.848846.


Cite VisCello
-------------------------

Packer, J. S., Q. Zhu, C. Huynh, P. Sivaramakrishnan, E. Preston, H. Dueck, D. Stefanik, K. Tan, C. Trapnell, J. Kim, R. H. Waterston and J. I. Murray (2019). A lineage-resolved molecular atlas of C. elegans embryogenesis at single-cell resolution. Science: eaax1971.

Q. Zhu, J. I. Murray, K. Tan, J. Kim, qinzhu/VisCello: VisCello v1.0.0 (2019; https://zenodo.org/record/3262313).


