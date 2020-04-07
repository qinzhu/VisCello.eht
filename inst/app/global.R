
# For deploy, set F to T, replace inst/app/data/config.yml, clist.rds and eset.rds. Follow https://github.com/qinzhu/VisCello to deploy.
viscello_DEPLOY = T

lapply(list.files("src/", pattern = "\\.(r|R)$", recursive = F, full.names = TRUE), function(x){source(file = x)})

if(viscello_DEPLOY) {
    library(shiny);library(shinyBS);library(shinyWidgets);library(shinycssloaders);library(htmlwidgets);library(shinyBS);library(R.utils);library(purrr);library(ggplot2);library(RColorBrewer);library(reshape2);library(gridExtra);library(shinythemes);library(plotly);library(heatmaply);library(pheatmap);library(DT);library(dplyr);library(openxlsx);library(knitr);library(monocle);library(clusterProfiler);library(org.Mm.eg.db);library(org.Hs.eg.db);library(ggraph);library(tidygraph);library(limma);library(irlba);library(data.table);library(VisCello)
    
    .GlobalEnv$global_config <- config::get(file = "data/config.yml", use_parent = F)
    .GlobalEnv$mainTitle = paste0("VisCello - ",global_config$study_name)
    .GlobalEnv$organism = global_config$organism
    .GlobalEnv$study_info <- global_config$study_description
    .GlobalEnv$name_col = global_config$feature_name_column
    .GlobalEnv$id_col = global_config$feature_id_column
    tryCatch({
        # .GlobalEnv$eset <- readRDS("data/eset_combine.rds")
        # .GlobalEnv$clist <-readRDS("data/clist_combine.rds")
        .GlobalEnv$eset <- readRDS("data/eset.rds")
        .GlobalEnv$clist <-readRDS("data/clist.rds")
    }, error = function(x){
        stop("Cannot find eset or clist file, please check if the path in config.yml is correct.")
    })
} 




# Global.R
if(Sys.getenv('SHINY_PORT') == "") options(shiny.maxRequestSize=10000*1024^2)

meta_order <- c(colnames(pData(eset)), colnames(clist[[1]]@pmeta))
names(meta_order) <- meta_order

# Don't show factors that's not useful to the user
meta_order <- meta_order[!meta_order %in% c("barcode")]
# Do not edit below
meta_order["Gene Expression"] = "gene.expr"
pmeta_attr <- data.frame(meta_id = meta_order, meta_name = names(meta_order), stringsAsFactors=FALSE)
pData(eset) <- pData(eset)[,which(colnames(pData(eset)) %in% pmeta_attr$meta_id)]

pmeta_attr$is_numeric <- sapply(as.character(pmeta_attr$meta_id), function(x) {
    if(x %in% colnames(pData(eset))) {
        is.numeric(pData(eset)[[x]])
    } else if(x %in% colnames(clist[[1]]@pmeta)) {
        is.numeric(clist[[1]]@pmeta[[x]])
    } else if(x == "gene.expr") {
        T
    } else {
        NA
    }
})

# Edit if necessary, Which meta to show 
pmeta_attr$dpal <- ifelse(pmeta_attr$is_numeric, "viridis", "Set1")
pmeta_attr$dscale <- ifelse(pmeta_attr$is_numeric, "log10", NA)
pmeta_attr$dscale[which(pmeta_attr$meta_id %in% c("Size_Factor"))] <- "identity"


### Which meta data to show, and in what order ###
showcols_meta <- pmeta_attr$meta_id
names(showcols_meta) <- pmeta_attr$meta_name

bp_colorBy_choices <- showcols_meta[!pmeta_attr$is_numeric]

de_meta_options <- showcols_meta[!pmeta_attr$is_numeric]

numeric_palettes <- numeric_color_opt()
names(numeric_palettes) <- numeric_palettes

heatmap_palettes <- numeric_palettes[numeric_palettes %in% c("RdYlBu", "RdBu", "viridis", "magma", "plasma", "inferno")]

gene_symbol_choices <- rownames(fData(eset))
names(gene_symbol_choices) <- fData(eset)[[name_col]]

feature_options <- data.table(features = names(gene_symbol_choices))
max_pc_show <- 10

HMD_HumanPhenotype <- read.delim("data/HMD_HumanPhenotype.rpt", header=FALSE)



# Specifically modified for EHT

dataset_color<-c(
    "E9.5 Endo 1"="#B2DF8A",
    "E9.5 Endo 2"= "#99D8C9", 
    "E9.5 HE 1"="#1b7837",
    "E9.5 HE 2" ="#33A02C", 
    "E9.5 Entire Endothelium" = "#74c476",
    "E10.5 Endo 1"="#A6CEE3", 
    "E10.5 Endo 2"="#67A9CF",
    "E10.5 HE 1"="#1F78B4", 
    "E10.5 HE 2"="#1c9099",
    "E10.5 HE 3" = "#1d91c0",
    "E10.5 Entire Endothelium" = "#41b6c4",
    "E10.5 Cluster 1"="#B15928",
    "E10.5 Cluster 2" = "#d8b365",
    "E10.5 Cluster 3" = "#cab2d6",
    "E10.5 Cluster CD45+"="#6A3D9A", 
    "E10.5 Cluster CD45-"="#cc4c02", 
    "E11.5 Cluster 1"="#fa9fb5", 
    "E11.5 Cluster 2"="#e7298a",
    "E11.5 Cluster CD45+CD27+"="#E31A1C", 
    "E11.5 Cluster CD45+CD27-"="#FDBF6F", 
    "E11.5 FL-LMPP" = "#91003f",
    "E14.5 FL-HSC"="#FF7F00",
    "E9.5 YS-EMP" = "#003366",
    "E10.5 YS-Endo" = "#f1b6da",
    "E10.5 YS-HE" = "#9e9ac8",
    "E10.5 Runx1 +/+" = "#66c2a5",
    "E10.5 Runx1 +/-" = "#e6f598",
    "E10.5 Umbilical & Viteline Endo" = "#fee08b",
    "E10.5 Runx1 +/+ 2" = "#efedf5",
    "E10.5 Runx1 +/- 2" = "#bcbddc",
    "E10.5 AGM Endo" = "#990000",
    "E10.5 ATAC Paired Endothelium" = "#7fcdbb",
    "E10.5 ATAC Paired Endothelium 2" = "#8c96c6",
    "E10.5 Runx1-Cre+" = "#88419d"
)

combine_dataset_color<-c(
    "E9.5 E"="#B2DF8A",
    "E9.5 HE"="#1b7837",
    "E9.5 E+HE+IAC" = "#74c476",
    "E10.5 E"="#A6CEE3", 
    "E10.5 HE"="#1F78B4", 
    "E10.5 E+HE+IAC" = "#41b6c4",
    "E10.5 IAC" = "#cab2d6",
    "E10.5 CD45+ IAC"="#6A3D9A", 
    "E10.5 CD45- IAC"="#cc4c02", 
    "E11.5 IAC"="#fa9fb5", 
    "E11.5 CD45+CD27+ IAC"="#E31A1C", 
    "E11.5 CD45+CD27- IAC"="#FDBF6F", 
    "E11.5 FL-LMPP" = "#91003f",
    "E14.5 FL-HSC"="#FF7F00",
    "E9.5 YS-EMP" = "#003366",
    "E10.5 YS-Endo" = "#f1b6da",
    "E10.5 YS-HE" = "#9e9ac8",
    "E10.5 Runx1+/+" = "#c51b8a",
    "E10.5 Runx1+/-" = "#35978f",
    "E10.5 U+V E+HE+HC" = "#8c96c6",
    "E10.5 AGM E+HE+HC" = "#990000",
    "E10.5 Cre-Runx1" = "#88419d",
    #"E10.5 E+HE+IAC (scATAC paired)" = "#8c96c6",
    "E10.5 E+HE+IAC (scATAC paired)" = "#41b6c4"
)







