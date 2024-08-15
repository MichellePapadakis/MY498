################################################################################
### 2. Text cleaning and corpus and DFM creation
################################################################################
########## 2.1 Text cleaning

text <- tolower(speeches$text)
text <- str_replace_all(text, "\\bhttps?:\\/\\/[^\\s]+\\b", "") #delete urls
text <- str_replace_all(text, "\\b\\d+(\\.\\d+)?\\b", "") #delete numbers including decimals
text <- str_replace_all(text, "\\b\\d{4}-\\d{4}\\b", "") #delete years in the format yyyy-yyyy
#Remove specific words, including self-references or general references to mexico, the name of the report, etc.
text <- str_replace_all(text, "\\b(méxic\\w*|felipe\\w*|calderón\\w*|hinojosa\\w*|enrique\\w*|peña\\w*|nieto\\w*|andrés\\w*|manuel\\w*|lópez\\w*|obrador\\w*|modera\\w*|señor\\w*|enero\\w*|febrero\\w*|marzo\\w*|abril\\w*|mayo\\w*|junio\\w*|julio\\w*|agosto\\w*|septiembre\\w*|octubre\\w*|noviembre\\w*|diciembre\\w*|la\\w*|las\\w*|esta\\w*|presidente\\w*|primer\\w*|segund\\w*|tercer\\w*|cuart\\w*|quint\\w*|sext\\w*|artícul\\w*|mil\\w*|pesos\\w*|ciento\\w*|país\\w*|gobierno\\w*|repúblic\\w*|hoy\\w*|año\\w*|ahora\\w*|día\\w*|ceremonia\\w*|público\\w*|dos\\w*|tres\\w*|manera\\w*|pvm\\w*|pt\\w*|no| tu| mr|ico\\w*)\\b", "")

text <- str_replace_all(text, "-\\s*\n\\s*", "") #delete hyphen at the end of the line
text <- str_replace_all(text, "(\\w+)-\n(\\w+)", "\\1\\2") # join words separated by hyphen
text <- str_replace_all(text, "[^\\w\\s]", "") #delete punctuation
text <- str_replace_all(text, "\\s+", " ") #delete extra spaces
text <- str_replace_all(text, "(\\w+)-\\s*\n\\s*(\\w+)", "\\1\\2") #join words separated by hyphen
###############################################################################

################################################################################
########## 2.2 Create the corpus 
corpus <- corpus(text, docvars = speeches[, c("year", "president")]) 
#clean the corpus by removing spanish stopwords
my_stopwords <- c(
  # Personal pronouns
  "yo", "tu", "ti", "contigo", "el", "ella", "ello", "nosotros", "nosotras",
  "vosotros", "vosotras", "ellos", "ellas", "usted", "ustedes",
  # Possessive pronouns
  "mi", "mis", "tu", "tus", "su", "sus", "nuestro", "nuestra", "nuestros", "nuestras",
  "vuestro", "vuestra", "vuestros", "vuestras",
  # Demonstrative pronouns
  "este", "esta", "estos", "estas", "ese", "esa", "esos", "esas",
  "aquel", "aquella", "aquellos", "aquellas",
  # Relative pronouns and other common pronouns
  "que", "quien", "quienes", "cual", "cuales", "donde",
  "cuanto", "cuanta", "cuantos", "cuantas",
  # Reflexive pronouns
  "me", "te",  "los", "en", "es", "más", "por", "mexicanos", "una", "del", "lo", "hijos")
text <- text %>%
  str_remove_all("\\b(\\w*\\d+\\w*)\\b") %>% # Delete words with numbers
  str_remove_all("\\b[A-Z]{2,}\\b") %>% # Delete acronyms
  str_remove_all(paste(my_stopwords, collapse = "|")) %>% 
  str_remove_all("\\b\\w{1,2}\\b") %>% # Delete words with 1 or 2 characters
  str_remove_all("\\b\\d{4}-\\d{4}\\b") %>% # Delete ranges of years
  str_remove_all("\\b\\d{4}\\b") %>% # Delete years
  str_remove_all("\\b\\d+\\b") %>% # Delete numbers
  str_remove_all("\\b\\d+\\S*\\b") %>% 
  str_replace_all("\\b\\d{4}(-\\d{4})?\\b", "")  

################################################################################
########### 2.3 Tokenize the corpus

corpus_clean <- tokens(corpus) %>%
  tokens_remove(pattern = "\\p{P}", valuetype = "regex") %>% #remove punctuation
  tokens_remove(pattern = "\\p{N}", valuetype = "regex") %>% #remove numbers
  tokens_remove(pattern = "\\s+", valuetype = "regex") %>% #remove extra spaces
  tokens_remove(pattern = my_stopwords, padding = TRUE) %>%
  tokens_remove(pattern = stopwords("es"), padding = TRUE) #remove spanish stopwords

corpus_clean <- tokens(corpus, 
                       remove_punct = TRUE,  #remove punctuation
                       remove_numbers = TRUE,  #remove numbers
                       remove_symbols = TRUE,  #remove symbols
                       remove_separators = TRUE) #remove separators

#Creation of a list of words irrelevant to the analysis to remove
corpus_clean <- corpus_clean %>% tokens_remove(pattern = c("los", "un", "al", "hemos", "mucho","en", "es", "más", "por", "mexicanos", "una", "del", "lo", "hijos", "ha", "como","también", "todos", "han", "ya", "eso", "nos", "este", "estamos", "están","está", "sólo", "solo", "nacional", "mejorar", "mejor", "mi", "vivir", "todo","sin", "entre", "uno", "hasta", "administración", "porque", "partir", "federal","pero", "decir", "tienen", "ni", "vamos", "esto", "sido", "sé", "hay", "queremos", "2020-2024", "2019-2024", "2019-2020", "pvem", "2020-2021", "hom-", "panal", "2016-2050", "covid-", "bres", "bid-birf", "traba", "sspc", "parametros", "inpi", "blica", "cg-", "cnch", "centro-", "ía", "2011p", "cop16", "n.s", "ualdad", "fonaes", "procampo", "2009p", "fam-", "muje-" , "s.r.e", "pri-pvem", "#gsc", "o", "pitex", "o", "morena", "2010p", "sjpa", "odile",  "mado", "finfra", "cfc", "pan-prd", "pri-pvem-panal",  "pdho", "hgz","ptp",  "ppam","ɣ","tpp", "omes",  "duis",        "-agosto", "ecex","fem" ,"uba",  "fobesii", "cti", "pnpsvd", "ipl", "tecnm","edn", "bidbirf", "hommujetotal", "pripvem", "pripvempanal", "aprendices", "prd", "oblación", "cg", "o",  "pgcm",  "asm", "lgv" , "tco2e", "altex", "pmg",  "mdl" , "pdl" , "mido", "fiupea", "siedo", "fomes", "seg", "pan", "morenapes", "tab", "der", "om", "ss", "er", "cp", "em", "pazap", "smng", "zm", "mc", "com", "ara" , "cipsvd", "pes", "res", "о", "ros", "ns", "pv", "chbo", "or", "ceav", "cns","ey", "rr","pfp", "panprd", "programa", "i,", "total", "e", "n", "x", "total", "cifras", "desarrollo","acciones", "porcentaje", "periodo","acciones", "sistema", "d", "así", "sistema", "servicios", "través", "sobre", "recursos", "durante", "personas", "siguientes", "i" , "proyectos", "entregar", "informe", "congreso", "unión" ,"honorable", "mexicanas", "cumplimiento", "dispuesto", "bles", "dores", "generadora" , "unio","pri" ,"adores", "aca", "xi", "os", "as", "to-", "ii", "org", "alias", "ig", "unemes", "cecadesu", "1o", "us", "ife", "e-", "xi", "observado", "mes", "llave", "oics           cessa", "cimares", "subsemun", "entidad", "entidades", "federativa", "información", "pública", "población", "secretaría", "sector","p", "miles", "presupuesto", "respecto", "c", "presupuestaria", "fuera", "producción", "fuente", "otros", "directo", "control", "atención", "para", "constitución", "política", "unidos", "apertura", "sesiones", "donde",  "partido",  "reportar", "distrit", "general", "coincidir",  "disposiciones","redondeo", "nama", "idóneos", "objetivoindicador","100x100","2012e", "materia", "objetivo", "mismo", "cinco", "nuevo", "naturales", "cual","cuales","refiere", "incluye", "unidad", "debido", "suma", "puede", "anual", "baja", "periodicidad", "operación", "parte", "marco", "fondos","nivel", "cabo", "marco", "superior", "baja", "tuni", "tenta"), padding = TRUE)
corpus_clean <- tokens_remove(corpus_clean, pattern = "\\b\\w{1,3}\\b", valuetype = "regex")


################################################################################
############ 2.4 Create the document-feature matrix 
dfm <- dfm(corpus_clean) 
dfm <- corpus_clean %>% 
  tokens(remove_punct = TRUE, remove_numbers = TRUE, remove_symbols = TRUE, #remove stopwords
         remove_url = TRUE) %>% #remove urls
  
  dfm() %>%
  dfm_trim(min_termfreq = 150) #remove terms that appear less than 150 times
docnames(dfm) <- paste(docnames(dfm), docvars(corpus)$year, docvars(corpus)$president, sep = "")




################################################################################
speeches$word_count <- str_count(speeches$text, "\\w+")
speeches$year <- as.numeric(as.character(speeches$year))

# #add party to the presidents in speeches (FCH = PAN, AMLO = MORENA, EPN = PRI)
speeches$party <- ifelse(speeches$president == "FCH", "PAN", 
                         ifelse(speeches$president == "AMLO", "MORENA", "PRI"))

metadata <- speeches[, c("year", 
                         "president", 
                         "anual.mean", 
                         "unemployment_rate", 
                         "female_labour_participation_rate", 
                         "gdp_per_capita_growth", 
                         "women_parliament_seats", 
                         "Expenditure Gender Annex, 2023 prices (millions)", 
                         "% of gender expenditure over total expenditure", 
                         "Budget Share for Economic Development (%)", 
                         "Budget Share for Social Development (%)", 
                         "budget share for heath (%)",
                         "word_count",
                         "party")]

metadata$year <- as.numeric(metadata$year) #convert year to numeric
metadata$president <- as.factor(metadata$president) #convert president to factor
names(metadata) <- make.names(names(metadata)) #rename the columns to avoid errors
docvars(dfm) <- metadata

docvars(dfm)