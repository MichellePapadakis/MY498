
#Loading all libraries used in the exercise
packages <- c ("rvest", "dplyr", "xml2", "stringr", "RSelenium", "tidyverse", 
               "httr", "ggplot2", "scales", "httr", "pdftools", "quanteda",
               "wbstats", "readr", "readxl","stm", "quanteda.textstats", 
               "quanteda.textplots", "stopwords", "LDAvis", "corrplot", 
               "networkD3", "webshot2", "servr", "kableExtra", "knitr", "servr",
               "formatR", "chromote"
)

installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}
invisible(lapply(packages, library, character.only = TRUE))