################################################################################
### 1. Obtaining the data
#### 1.1 Obtaining the text data from the web
################################################################################

# PART 1. of text retrieval  ###################################################
#This chunk of code is to extract the speech of the last 3 presidents of Mexico.
#Given the restictions on access, the code is divided in two parts. 
#The first part is to extract the text from the pages of the last 2 presidents 
#of Mexico, AMLO and EPN. The second part is to extract the first 5 pdf files of
#the president Calderon obtained from the archives of the Metropolitan Autonomous 
#University of Mexico (UAM). The last speech  of Calderon is obtained from the
#archive of one of the official newspaper in Mexico, "El Universal".

################################################################################

# rD <- rsDriver(browser = "firefox", port = free_port(random = TRUE), chromever = NULL)
# remDr <- rD$client
# base_url <- "https://www.gob.mx/presidencia/articulos/version-estenografica-del-primer-informe-de-gobierno?idiom=es"
# remDr$navigate(base_url)
#
#
################################################################################
#
########## Pages for president EPN
#
# link_epn <- c("https://www.gob.mx/epn/prensa/mensaje-del-presidente-de-los-estados-unidos-mexicanos-licenciado-enrique-pena-nieto-con-motivo-de-su-primer-informe-de-gobierno", 
#               "https://www.gob.mx/epn/prensa/mensaje-del-presidente-de-los-estados-unidos-mexicanos-licenciado-enrique-pena-nieto-con-motivo-de-su-segundo-informe-de-gobierno",
#               "https://www.gob.mx/epn/prensa/mensaje-del-licenciado-enrique-pena-nieto-presidente-de-los-estados-unidos-mexicanos", 
#               "https://www.gob.mx/epn/articulos/4to-informe-de-gobierno-62351", 
#               "https://www.gob.mx/epn/prensa/palabras-del-presidente-de-los-estados-unidos-mexicanos-licenciado-enrique-pena-nieto-durante-su-quinto-informe-de-gobierno",
#               "https://www.gob.mx/epn/prensa/palabras-del-presidente-de-los-estados-unidos-mexicanos-licenciado-enrique-pena-nieto-con-motivo-de-su-sexto-informe-de-gobierno")
# 
########## Pages for president AMLO 
# links_amlo <- c("https://www.gob.mx/presidencia/articulos/version-estenografica-del-primer-informe-de-gobierno?idiom=es", 
#            "https://www.gob.mx/presidencia/prensa/discurso-del-presidente-andres-manuel-lopez-obrador-en-su-segundo-informe-de-gobierno-2020?idiom=es",
#            "https://www.gob.mx/presidencia/articulos/version-estenografica-tercer-informe-2020-2021?idiom=es",
#            "https://www.gob.mx/presidencia/articulos/version-estenografica-4-informe-de-gobierno?idiom=es", 
#            "https://www.gob.mx/presidencia/es/articulos/version-estenografica-5-informe-de-gobierno?idiom=es/")
#
################################################################################
########## Function to extract text from the page 

# extract_text<- function(url){
#   remDr$navigate(url)
#   text <- remDr$findElement(using = 'css selector', value = 'div.article-body')$getElementText()
#   return(text)
# }
########## Applying the function to the links

# texts_epn <- lapply(link_epn, extract_text)
# texts_amlo <- lapply(links_amlo, extract_text)
# 
########## close the browser and the driver
# remDr$close()
# rD$server$stop()
# 
########## Extracting the text from the list
# texts_epn <- unlist(texts_epn)
# texts_amlo <- unlist(texts_amlo)
# 
#
########## Create a data frame with the text, the name and the year of the president
#
# epn <- data.frame(text = texts_epn, president = "EPN", year = c(2013, 2014, 2015, 2016, 2017, 2018))
# amlo <- data.frame(text = texts_amlo, president = "AMLO", year = c(2019, 2020, 2021, 2022, 2023))
# 
# 
########## Pages for president FCH (1 to 5)
# links_fch <- c("https://cede.izt.uam.mx/wp-content/uploads/2023/02/2007-FCH-1o-informe.pdf",
#                "https://cede.izt.uam.mx/wp-content/uploads/2023/02/2008-FCH-2o-informe.pdf",
#                "https://cede.izt.uam.mx/wp-content/uploads/2023/02/2009-FCH-3o-informe.pdf",
#                "https://cede.izt.uam.mx/wp-content/uploads/2023/02/2010-FCH-4o-informe.pdf", 
#                "https://cede.izt.uam.mx/wp-content/uploads/2023/02/2011-FCH-5o-informe.pdf")
# 
# db_fch <- data.frame(text = character(5), president = "FCH", year = c(2007, 2008, 2009, 2010, 2011), stringsAsFactors = FALSE)
########### Extracting the text from the pdfs 
#
# for (i in seq_along(links_fch)) {
#   #Generate a temporary file
#   temp_file <- tempfile(fileext = ".pdf") #download the pdf
#   GET(links_fch[i], write_disk(temp_file, overwrite = TRUE)) #using the pdftools package to extract the text
#   text <- paste(pdf_text(temp_file), collapse = " ") #concatenate the text
#   db_fch$text[i] <- text   #save the text in the data frame
#   unlink(temp_file) #delete the temporary file
# }
# 
########### Get the last speech of FCH from a webpage of a national newspaper 
# url <- "https://archivo.eluniversal.com.mx/notas/868097.html"
# webpage_6to <- read_html(url)
# text_6to <- webpage_6to %>% 
#   html_nodes("body") %>% 
#   html_text() %>% 
#   paste(collapse = " ") %>% 
#   str_replace_all("[\r\n\t]", " ") %>% 
#   str_replace_all(" +", " ") %>% 
#   str_replace_all("Â|Ã³", "ó") %>% 
#   str_replace_all("Ã©", "é") %>% 
#   str_replace_all("Ã±", "ñ") %>% 
#   str_replace_all("Ã¡", "á") %>% 
#   str_replace_all("Ã­", "í") %>% 
#   str_replace_all("Ãº", "ú") %>% 
#   str_replace_all("Ã", "í")
# 
# start <- str_locate(text_6to, "Ministro Juan Silva Meza, Presidente d")[1]  # Initial position
# end <- str_locate(text_6to, "Muchas gracias a todos y qué viva México.")[2]  # Final position
# text_6th <- substr(text_6to, start, end) #extract the text from the initial to the final position
# fch <- rbind(db_fch, data.frame(text = text_6th, president = "FCH", year = 2012)) #add the last speech to the data frame
# 
################################################################################
########## Consolidate the data frames
#
# speeches <- rbind(amlo, epn, fch) #a data frame with all the speeches
# speeches <- speeches[order(speeches$year),]#order the data frame by year
#
#
#
################################################################################
################################################################################
# PART 2. of text retrieval#####################################################
#
# This subsection is to extract the full text of the reports of the presidents 
# and add them to the data frame speeches to expand the corpus for better analysis. 
#
########### Pages for president FCH
#
# links_report_fch <- c("https://felipe.mx/wp-content/uploads/2023/informes/Primer_Informe_de%20Gobierno_sep2007.pdf?_t=1673542974",
#                       "https://felipe.mx/wp-content/uploads/2023/informes/Segundo_Informe_de_Gobierno_sep2008.pdf?_t=1673542974",
#                       "https://felipe.mx/wp-content/uploads/2023/informes/Tercer_Informe_de_Gobierno_sep2009.pdf?_t=1673542974",
#                       "https://felipe.mx/wp-content/uploads/2023/informes/Cuarto_Informe_de_Gobierno_sep2010.pdf?_t=1710181802",
#                       "https://felipe.mx/wp-content/uploads/2023/informes/Quinto_Informe_de_Gobierno_sep2011.pdf?_t=1673542974",
#                       "https://felipe.mx/wp-content/uploads/2023/informes/Sexto_Informe_de_Gobierno_sep2012.pdf?_t=1673542975")
#
# ########## Pages for president EPN
# links_report_epn <- c("https://upload.wikimedia.org/wikipedia/commons/6/6d/Primer_informe_de_gobierno_Enrique_Pe%C3%B1a_Nieto.pdf",
#                       "https://cede.izt.uam.mx/wp-content/uploads/2023/02/2014-EPN-2%C2%B0-informe.pdf",
#                       "https://cede.izt.uam.mx/wp-content/uploads/2023/02/2015-EPN-3%C2%B0-informe.pdf",
#                       "https://cede.izt.uam.mx/wp-content/uploads/2023/02/2016-EPN-4%C2%B0-informe.pdf",
#                       "https://cede.izt.uam.mx/wp-content/uploads/2023/02/2017-EPN-5%C2%B0-informe.pdf",
#                       "https://cede.izt.uam.mx/wp-content/uploads/2023/02/2018-EPN-6%C2%B0-informe.pdf")
# 
# ########## Pages for president AMLO
#
# links_report_amlo <- c("https://cede.izt.uam.mx/wp-content/uploads/2023/02/2019-AMLO-1%C2%B0-informe.pdf",
#                       "https://cede.izt.uam.mx/wp-content/uploads/2023/02/2020-AMLO-2%C2%B0-informe.pdf",
#                       "https://cede.izt.uam.mx/wp-content/uploads/2023/02/2021-AMLO-3%C2%B0-informe.pdf",
#                       "https://cede.izt.uam.mx/wp-content/uploads/2023/02/2022-AMLO-4%C2%B0-informe.pdf",
#                       "https://cede.izt.uam.mx/wp-content/uploads/2023/09/2023-AMLO-5%C2%B0-informe.pdf")
# 
########## Extract the text from the pdfs of the reports for each president
#
# for (i in seq_along(links_report_fch)){
#   temp_file <- tempfile(fileext = ".pdf") 
#   GET(links_report_fch[i], write_disk(temp_file, overwrite = TRUE)) 
#   text <- paste(pdf_text(temp_file), collapse = " ") 
#   speeches[speeches$president == "FCH" & speeches$year == 2007 + i - 1, "text"] <- 
#     paste(speeches[speeches$president == "FCH" & speeches$year == 2007 + i - 1, "text"], text, sep = " ")
#   unlink(temp_file) 
# }
# 
# for (i in seq_along(links_report_epn)){
#   temp_file <- tempfile(fileext = ".pdf")
#   GET(links_report_epn[i], write_disk(temp_file, overwrite = TRUE))
#   text <- paste(pdf_text(temp_file), collapse = " ")
#   speeches[speeches$president == "EPN" & speeches$year == 2013 + i - 1, "text"] <- 
#     paste(speeches[speeches$president == "EPN" & speeches$year == 2013 + i - 1, "text"], text, sep = " ")
#   unlink(temp_file)
# }
# 
# for (i in seq_along(links_report_amlo)){
#   temp_file <- tempfile(fileext = ".pdf")
#   GET(links_report_amlo[i], write_disk(temp_file, overwrite = TRUE))
#   text <- paste(pdf_text(temp_file), collapse = " ")
#   speeches[speeches$president == "AMLO" & speeches$year == 2019 + i - 1, "text"] <- 
#     paste(speeches[speeches$president == "AMLO" & speeches$year == 2019 + i - 1, "text"], text, sep = " ")
#   unlink(temp_file)
# }

################################################################################
#### 1.2 Obtaining economic data
################################################################################
########## Adding macroeconomic data to the speeches data frame

########## 1. From the Central Bank of Mexico (Banco de México) we will use the annual exchange rate data
# exchange_rate <- read.csv("Consulta_FIX.csv", skip = 17, stringsAsFactors = FALSE)#columns start at row 18
# exchange_rate <- exchange_rate[, -c(1, 2)] #delete the first two columns  to just keep the year and the anual mean exchange rate
# exchange_rate <- exchange_rate[complete.cases(exchange_rate),] #delete na rows
# speeches <- merge(speeches, exchange_rate, by.x = "year", by.y = "year", all.x = TRUE) #merge the data frames by year
# 
# ################################################################################
########## 2. From the World Bank API we will use  unemployment, female labour participation rate, GDP per capita growth, and share of women in parliament
# # Define the indicators and their corresponding new column names
# indicators <- list(
#   unemployment_rate = "SL.UEM.TOTL.ZS",
#   female_labour_participation_rate = "SL.TLF.CACT.FE.ZS",
#   gdp_per_capita_growth = "NY.GDP.PCAP.KD.ZG",
#   women_parliament_seats = "SG.GEN.PARL.ZS"
# )
# 
# # Loop over the indicators and merge them with speeches dataframe
# for (col_name in names(indicators)) {
#   indicator_code <- indicators[[col_name]]
#   df <- wb(country = "MX", indicator = indicator_code, startdate = 2007, enddate = 2023) %>%
#     select(date, value) %>%
#     rename(year = date, !!col_name := value)  # Using !! to force evaluation of col_name
#   speeches <- merge(speeches, df, by = "year", all.x = TRUE)
# }
# 
# ################################################################################
########## 3. From the Ministry of Finance  we will use the budget data for the gender annex, the share of the budget for health, economic development and social development. 
# 
# budget <- read_excel("PP_anexo13.xlsx", sheet = "consolidate")
# #extract the last two columns and merge them into the speeches data frame by year
# budget <- budget[, c(1, 7, 8, 10, 12, 14)]
# #round data from the budget to two decimal places
# budget <- budget %>% mutate(across(where(is.numeric), ~round(., 2)))
# 
# # Merge the data frames
# speeches <- merge(speeches, budget, by.x = "year", by.y = "year", all.x = TRUE)
# 
# #add the party of the president
# speeches$party <- ifelse(speeches$president == "FCH", "PAN", ifelse(speeches$president == "EPN", "PRI", "MORENA"))
# speeches$party <- as.factor(speeches$party)
# speeches$president <- as.factor(speeches$president)
# 
# ################################################################################
# 
# #save the data frame
# save(speeches, file = "speeches_consolidate.RData") 

#Given the extensive time it takes to obtain the data, we will load the data frame from the file speeches_consolidate.RData
load("speeches_consolidate.RData")
