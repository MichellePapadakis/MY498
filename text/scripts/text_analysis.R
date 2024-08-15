
############ 6.1.1 Create a dictionary with words related to gender in Mexico. 
gender <- c(
  # General gender terms
  "(?i)g[eé]ner*",                # gender, genres, generosity, generalize
  "(?i)rol(e?s?) de g[eé]nero",   # gender roles, role of gender
  "(?i)perspectiva de g[eé]nero", # gender perspective
  "(?i)identidad de g[eé]nero",   # gender identity
  "(?i)expresi[oó]n de g[eé]nero",# gender expression
  "(?i)teor[ií]a de g[eé]nero",   # gender theory
  
  # Terms specific to women
  "(?i)mujer(es|citas?)?",        # woman, women, little woman, little women
  "(?i)femin[a-z]*",              # feminism, feminist, feminists, feminization
  "(?i)sororidad",                # sorority
  "(?i)matriarcal(es)?",          # matriarchal, matriarchy
  "(?i)maternidad(es)?",          # maternity, maternities
  "(?i)femineidad(es)?",          # femininity, femininities
  "(?i)cuidado(s|ras?)?",         # care, cares, caregiver, caregivers
  "(?i)brecha salarial",          # wage gap
  "(?i)trabajo de cuidado",       # care work
  "(?i)empoderamiento femenino",  # female empowerment
  
  # Movements and rights
  "(?i)derechos de las mujeres",  # women's rights
  "(?i)igualdad de g[eé]nero",    # gender equality
  "(?i)equidad de g[eé]nero",     # gender equity
  "(?i)paridad de g[eé]nero",     # gender parity
  "(?i)sufragio femenino",        # women's suffrage
  "(?i)movimiento feminista",     # feminist movement
  "(?i)igualdad salarial",        # equal pay
  "(?i)violencia contra las mujeres", # violence against women
  "(?i)acoso sexual",             # sexual harassment
  "(?i)discriminaci[oó]n de g[eé]nero", # gender discrimination
  "(?i)acceso al aborto",         # access to abortion
  "(?i)derechos reproductivos",   # reproductive rights
  "(?i)salud femenina",           # women's health
  "(?i)salud menstrual",          # menstrual health
  "(?i)menstruaci[oó]n(es)?",     # menstruation, menstruations, menstrual
  "(?i)anticoncepci[oó]n(es)?",   # contraception, contraceptives
  
  # Violence and abuse
  "(?i)violencia de g[eé]nero",   # gender violence
  "(?i)violencia dom[eé]stica",   # domestic violence
  "(?i)violencia sexual",         # sexual violence
  "(?i)feminicidio",              # femicide
  "(?i)misogini(a|o|os|as)?",     # misogyny, misogynist, misogynists, misogynistic
  "(?i)abuso de poder",           # abuse of power
  "(?i)maltrato(s|da|das)?",      # abuse, abuses, abused
  
  # Stereotypes and traditional roles
  "(?i)estereotipo(s|c[oó]s)?",   # stereotype, stereotypes, stereotypical
  "(?i)roles tradicionales",      # traditional roles
  "(?i)mach(o|ismo|ista|istas)?", # macho, machismo, machista, machistas
  "(?i)sexismo",                  # sexism
  "(?i)sexista(s)?",              # sexist, sexists
  "(?i)patriarc(o|ado|ales)?",    # patriarchy, patriarchal
  "(?i)expectativas de g[eé]nero" # gender expectations
)

women_dictionary <- dictionary(list(gender = gender))

#Frequency of words related gender across time in the dfm
women_freq<- dfm_lookup(dfm, dictionary = women_dictionary, valuetype = "regex", case_insensitive = TRUE)
women_freq <- convert(women_freq, to = "data.frame")
women_freq$gender <- as.numeric(women_freq$gender)

#Plot the frequency of words related to gender in the dfm (no weighted by the number of words in the speech)
year <- 2007:2023
genderdic_dfm <- (ggplot(women_freq, aes(x = year, y = gender)) +
                    geom_point() +
                    geom_smooth(method = "lm") +
                    labs(
                      x = "Year",
                      y = "Frequency of 'gender' related words",
                      title = "Frequency of Words Related to Women in Presidential Speeches and Reports"
                    ) +
                    theme_minimal())

#Total frequency per president
#FCH_women <- sum(women_freq$gender[1:6])
#EPN_women <- sum(women_freq$gender[7:12])
#AMLO_women <- sum(women_freq$gender[13:17])


################################################################################
speeches_tfidf <- dfm_tfidf(dfm)
############  6.1.2 Frequency of words related gender across time in the tf -idf speeches_tfidf
women_freq_tfidf <- dfm_lookup(speeches_tfidf, dictionary = women_dictionary, valuetype = "regex", case_insensitive = TRUE)
women_freq_tfidf <- convert(women_freq_tfidf, to = "data.frame")
women_freq_tfidf$year <- 2007:2023
women_freq_tfidf$gender <- as.numeric(women_freq_tfidf$gender)
#Plot the frequency of words related to gender in the tf-idf speeches_tfidf
genderdic_dfm

gender_dic_tfidf <- (ggplot(women_freq_tfidf, aes(x = year, y = gender)) +               ##################################################### to print  gender_dic_tfidf
                       geom_point() +
                       geom_smooth(method = "lm") +
                       labs(
                         x = "Year", 
                         y = "Frequency of 'gender' related words (tf-idf)",
                         title = "Frequency of Words Related to Gender "
                       ) +
                       theme_minimal())

gender_dic_tfidf

################################################################################
############ 6.1.3 Frequency of words related to care-work across time in the tf-idf speeches_tfidf
care <- c(
  # General care terms
  "(?i)cuidado(s)?",                   # care, cares
  "(?i)cuidar",                        # to care for
  "(?i)cuidando",                      # caring
  "(?i)cuidado personal",              # personal care
  
  # Caregivers and caregiving roles
  "(?i)cuidador(a|es)?",               # caregiver, caregivers
  "(?i)cuidadores informales",         # informal caregivers
  "(?i)cuidadores profesionales",      # professional caregivers
  "(?i)asistente(s)? de cuidado",      # care assistant, care assistants
  "(?i)trabajador(a|es)? de cuidado",  # care worker, care workers
  "(?i)trabajador(a|es)? social(es)?", # social worker, social workers
  "(?i)enfermer(o|a|os|as)",           # nurse, nurses
  "(?i)auxiliar(es)? de enfermería",   # nursing assistant, nursing assistants
  "(?i)g[eé]riatra(s)?",               # geriatrician, geriatricians
  "(?i)asistencia domiciliaria",       # home care
  "(?i)servicio(s)? de asistencia",    # assistance services
  "(?i)asistencia personal",           # personal assistance
  
  # Recipients of care
  "(?i)dependiente(s)?",               # dependent, dependents
  "(?i)personas dependientes",         # dependent persons
  "(?i)personas mayores",              # elderly, older people
  "(?i)anciano(s|a|as)?",              # old man, old woman, elderly
  "(?i)paciente(s)?",                  # patient, patients
  "(?i)niño(s|a|as)?",                 # child, children
  "(?i)infante(s)?",                   # infant, infants
  "(?i)menor(es)?",                    # minor, minors
  "(?i)hijo(s|a|as)?",                 # son, sons, daughter, daughters
  "(?i)persona(s)? con discapacidad(es)?", # person with disability, persons with disabilities
  "(?i)discapacitad(o|a|os|as)",       # disabled, disabled people
  "(?i)persona(s)? enferma(s)?",       # sick person, sick people
  "(?i)adulto(s|a|as) mayor(es)?",     # elderly, senior citizens, older adults
  
  # Types and contexts of care
  "(?i)cuidado infantil",              # childcare
  "(?i)cuidado de ancianos",           # elderly care
  "(?i)cuidado paliativo",             # palliative care
  "(?i)cuidado de la salud",           # health care
  "(?i)cuidado integral",              # comprehensive care
  "(?i)cuidado continuo",              # continuous care
  "(?i)cuidado en el hogar",           # home care
  "(?i)cuidado institucional",         # institutional care
  "(?i)residencia(s)? de ancianos",    # nursing home(s)
  "(?i)centro(s)? de d[ií]a",          # day center(s)
  "(?i)atenci[oó]n domiciliaria",      # home care
  "(?i)atenci[oó]n m[eé]dica",         # medical care
  "(?i)atenci[oó]n especializada",     # specialized care
  
  # Emotional and psychological aspects
  "(?i)apoyo emocional",               # emotional support
  "(?i)fatiga del cuidador",           # caregiver fatigue
  "(?i)estr[eé]s del cuidador",        # caregiver stress
  "(?i)burnout",                       # burnout
  "(?i)sobre carga emocional",         # emotional overload
  "(?i)salud mental",                  # mental health
  "(?i)apoyo psicol[oó]gico",          # psychological support
  
  # Policies and rights
  "(?i)pol[ií]ticas de cuidado",       # care policies
  "(?i)derechos de los cuidadores",    # caregivers' rights
  "(?i)licencia por cuidado",          # caregiving leave
  "(?i)conciliaci[oó]n laboral y familiar", # work-life balance
  "(?i)sistema de cuidados",           # care system
  "(?i)beneficio(s)? por cuidado",     # care benefits
  "(?i)seguro de cuidado",             # care insurance
  
  # Community and social aspects
  "(?i)red(es)? de apoyo",             # support network(s)
  "(?i)servicio(s)? comunitario(s)?",  # community service(s)
  "(?i)voluntariado en cuidado",       # care volunteering
  "(?i)grupo(s)? de apoyo",            # support group(s)
  "(?i)servicio(s)? de respiro",       # respite service(s)
  "(?i)programa(s)? de apoyo",         # support program(s)
  "(?i)asistencia social",             # social assistance
  "(?i)trabajo social",                # social work
  "(?i)recursos de cuidado",           # care resources
  "(?i)calidad del cuidado",           # quality of care
  "(?i)asistencia a largo plazo",      # long-term care
  "(?i)cuidado preventivo",            # preventive care
  "(?i)cuidado urgente",               # urgent care
  "(?i)emergencia(s)? m[eé]dica(s)?",  # medical emergencies
  "(?i)gesti[oó]n de casos",           # case management
  "(?i)coordinaci[oó]n de cuidado",    # care coordination
  "(?i)cuidado de enfermos",           # care of the sick
  "(?i)reintegro a la comunidad"       # community reintegration
)

dic_care <- dictionary(list(care = care))
frecuencias_cuidados <- dfm_lookup(dfm, dictionary = dic_care, valuetype = "regex", case_insensitive = TRUE)
freq_care_tfidf <- dfm_lookup(speeches_tfidf, dictionary = dic_care, valuetype = "regex", case_insensitive = TRUE)

freq_care_tfidf <- convert(freq_care_tfidf, to = "data.frame")

freq_care_tfidf$care <- as.numeric(freq_care_tfidf$care)


año <- 2007:2023
care_dic_tfidf <- (ggplot(freq_care_tfidf, aes(x = año, y = care)) +            ##################################################### to print  care_dic_tfidf
                     geom_point() +
                     geom_smooth(method = "lm") +
                     labs(x = "Year", y = "Frequency of 'care-work' related words", title = "Frequency of Words Related to Care-Work") +
                     theme_minimal())
care_dic_tfidf


