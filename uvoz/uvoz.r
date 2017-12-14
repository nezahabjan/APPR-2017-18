# 2. faza: Uvoz podatkov
sl <- locale("sl", decimal_mark = ",", grouping_mark = ".")


#funkcija, ki uvozi in prečisti tabelo bolezni
library(readr)
library(dplyr)
library(tidyr)
stolpci <- c("leto", "država", "kvantil", "starost", "spol", "enota", "vrednost", "prazno")
bolezni <- read_csv("podatki/bolezni.csv", 
                    locale=locale(encoding="cp1250"), 
                    col_names=stolpci,
                    skip=1,
                    n_max=651,
                    na=c(":","", " "))


podatki <- bolezni %>% fill(1:5) %>% drop_na(leto)
podatki$kvantil<- NULL
podatki$enota<- NULL
podatki$prazno<- NULL
podatki$spol<-NULL
podatki$leto<-parse_integer(podatki$leto)
podatki %>% select(leto) %>% distinct()
podatki %>% group_by(leto)

ociscena<-subset(podatki, starost=="From 16 to 19 years" | starost=="Total" | starost=="From 16 to 44 years")
View(ociscena)


#funkcija, ki uvozi in prečisti tabelo deleža potrošnje
library(readr)
library(dplyr)
library(tidyr)
stolpci<-c("leto", "država", "enota", "področje", "delež", "prazno")
delezpotrosnje <- read_csv("podatki/delezpotrosnje.csv",
                           locale=locale(encoding="cp1250"),
                           col_names=stolpci,
                           skip=1,
                           n_max=1260,
                           na=c(":", "", " "))
podatki<-delezpotrosnje %>% fill(1:6) %>% drop_na(leto)
podatki$prazno<-NULL
podatki$leto<-parse_integer(podatki$leto)
ociscena <-subset(podatki, enota=="Percentage of total" | enota=="Current prices, million euro")
View(ociscena)


#funkcija, ki uvozi in prečisti tabelo kupne moči
library(readr)
library(dplyr)
library(tidyr)
stolpci<-c("leto", "država", "mera", "potrošnja", "vrednost", "prazno")
kupnamoc <- read_csv("podatki/kupnamoc.csv",
                     locale=locale(encoding="cp1250"),
                     col_names=stolpci,
                     skip=1,
                     n_max=13300,
                     na=c(":", "", " "))
podatki<-kupnamoc %>% fill(1:6) %>% drop_na(leto)
podatki$prazno<-NULL
podatki$potrošnja<-NULL #VSI NAJ ZAJAMEJO LE OSEBNO INDIVIDUALNO POTROŠNJO
podatki$leto<-parse_integer(podatki$leto)
ociscena<-subset(podatki, mera=="Price level indices (EU28=100)"
                 | mera=="Nominal expenditure as a percentage of GDP (GDP=100)")

View(ociscena)


#funkcija, ki uvozi in prečisti tabelo aktivnosti ljudi po državah
library(readr)
library(dplyr)
library(tidyr)
sl <- locale("sl", decimal_mark = ".", grouping_mark = ",")
stolpci<-c("država", "leto", "starost", "delež")
aktivnost <- read_csv("podatki/aktivnost.csv",
                      skip=1,
                      locale=locale(encoding="cp1250",
                                    decimal_mark = ".",
                                    grouping_mark = ","),
                      col_names=stolpci)
as.data.frame(aktivnost, row.names=NULL)

              
                      
View(aktivnost)


aktivnost <- read_csv("podatki/aktivnost.csv", sep=",")

aktivnost<-read.csv("podatki/aktivnost.csv", header = TRUE, sep = ",", quote = "\"",
         dec = ".", fill = TRUE, comment.char = "")











# Funkcija, ki uvozi tabelo pričakovane starosti iz Wikipedije
uvozi.starost <- function() {
  #link <- "https://en.wikipedia.org/wiki/List_of_countries_by_life_expectancy#List_by_the_United_Nations,_for_2010%E2%80%932015"
  link <- "http://apps.who.int/gho/athena/data/GHO/NCD_PAC,NCD_PAA?profile=xtab&format=html&x-topaxis=GHO;SEX&x-sideaxis=COUNTRY;YEAR;AGEGROUP&x-title=table&filter=AGEGROUP:YEARS18-PLUS;COUNTRY:*;SEX:*;"
  stran <- html_session(link) %>% read_html()
  json <- stran %>% html_nodes(xpath="//script") %>% .[[3]] %>% html_text() %>%
    strapplyc("(\\{.*\\})") %>% unlist() %>% fromJSON()
  tabela <- json$Crosstable$Matrix %>% sapply(. %>% sapply(. %>% .[[1]] %>% .$disp)) %>% t() %>% data.frame()
  colnames(tabela) <- c("mesto", "država", "skupaj", "moški", "ženske")
  
}

  return(tabela)


# Funkcija, ki uvozi podatke iz datoteke druzine.csv
uvozi.bolezni <- function(obcine) {
  data <- read_csv2("podatki/druzine.csv", col_names = c("obcina", 1:4),
                    locale = locale(encoding = "Windows-1250"))
  data$obcina <- data$obcina %>% strapplyc("^([^/]*)") %>% unlist() %>%
    strapplyc("([^ ]+)") %>% sapply(paste, collapse = " ") %>% unlist()
  data$obcina[data$obcina == "Sveti Jurij"] <- "Sveti Jurij ob Ščavnici"
  data <- data %>% melt(id.vars = "obcina", variable.name = "velikost.druzine",
                        value.name = "stevilo.druzin")
  data$velikost.druzine <- parse_number(data$velikost.druzine)
  data$obcina <- factor(data$obcina, levels = obcine)
  return(data)
}

# Zapišimo podatke v razpredelnico obcine
obcine <- uvozi.obcine()

# Zapišimo podatke v razpredelnico druzine.
druzine <- uvozi.druzine(levels(obcine$obcina))

# Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# fazah.
