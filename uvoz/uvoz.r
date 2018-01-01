# 2. faza: Uvoz podatkov
sl <- locale("sl", decimal_mark = ",", grouping_mark = ".")

#Funkcija, ki uvozi in precisti tabelo potrosnje za sportne aktivnosti

stolpci <- c("podrocje", "drzava" , "mera", "leto", "potrosnja", "prazno")
potrosnjakupnamoc <- read_csv("podatki/potrosnjakupnamoc.csv", 
                              locale=locale(encodin="cp1250"),
                              col_names=stolpci,
                              skip=1,
                              n_max=77,
                              na=c(":", "", " "))
podatki <- potrosnjakupnamoc %>% fill(1:6) %>% drop_na(leto)
podatki$mera <- NULL
podatki$leto <- NULL
podatki$prazno <- NULL
podatki = podatki[,c(2,1,3)]
ociscenapotrosnjakupnamoc <- podatki %>% arrange(drzava)




#funkcija, ki uvozi in prečisti tabelo bolezni

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

ociscenebolezni<-subset(podatki, starost=="From 16 to 19 years" | starost=="Total" | starost=="From 16 to 44 years")



#funkcija, ki uvozi in prečisti tabelo deleža potrošnje

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
ociscenadelezpotrosnje <-subset(podatki, enota=="Percentage of total" | enota=="Current prices, million euro")



#funkcija, ki uvozi in prečisti tabelo kupne moči

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
ociscenakupnamoc<-subset(podatki, mera=="Price level indices (EU28=100)"
                 | mera=="Nominal expenditure as a percentage of GDP (GDP=100)")




#Funkcija, ki uvozi in precisti tabelo aktivnosti posameznikov (aktivnost.csv)


link <- "http://apps.who.int/gho/athena/data/GHO/NCD_PAC,NCD_PAA?profile=xtab&format=html&x-topaxis=GHO;SEX&x-sideaxis=COUNTRY;YEAR;AGEGROUP&x-title=table&filter=AGEGROUP:YEARS18-PLUS;COUNTRY:*;SEX:*;"
json <- html_session(link) %>% read_html() %>% html_nodes(xpath="//script[not(@src)]") %>%
  .[[1]] %>% html_text() %>% strapplyc("(\\{.*\\})") %>% unlist() %>% fromJSON() %>% .$Crosstable
matrika <- json$Matrix %>% sapply(. %>% sapply(. %>% .[[1]] %>% .$disp)) %>% t()
glava <- . %>% .$header %>% lapply(. %>% .[-1] %>% unlist() %>% { json$code[.+1] } %>%
                                     sapply(. %>% .$disp))
stolpci <- json$Vertical$layer %>% unlist() %>% { json$dimension[.+1] } %>% sapply(. %>% .$disp)
colnames(matrika) <- glava(json$Horizontal) %>% sapply(paste, collapse = ",")
data <- glava(json$Vertical) %>% lapply(. %>% as.list() %>% setNames(stolpci)) %>%
  bind_rows() %>% cbind(matrika) %>% melt(id.vars = 1:3) %>%
  mutate(Country = factor(Country), Year = parse_number(Year),
         value = parse_character(value, na = "No data"),
         variable = parse_character(variable)) %>% drop_na(value)%>%
  mutate(Indicator = variable %>% strapplyc("^([^,]+)") %>% unlist() %>% factor(),
         Sex = variable %>% strapplyc("([^,]+)$") %>% unlist() %>% factor(),
         Value = value %>% strapplyc("^([0-9.]+)") %>% unlist(),
         Lower = value %>% strapplyc("\\[([0-9.]+)") %>% unlist(),
         Upper = value %>% strapplyc("([0-9.]+)\\]") %>% unlist()) %>%
  select(-variable, -value) %>% melt(measure.vars = c("Value", "Lower", "Upper"),
                                     variable.name = "Statistic",
                                     value.name = "Value")

data<-filter(data, Country=="Belgium"|
             Country=="Bosnia and Herzegovina"|
             Country=="Denmark"|
             Country=="Finland"|
             Country=="Germany"|
             Country=="Greece"|
             Country=="Italy"|
             Country=="Latvia"|
             Country=="Slovenia"|
             Country=="France"|
             Country=="Luxembourg"|
             Country=="Bulgaria")

data = data[data$Indicator=="Insufficiently active (crude estimate)",]
data$Indicator <- NULL
data$Year <- NULL
data$`Age Group` <- NULL

data = data %>% arrange(Country, Sex) 
data = rename(data, c(Country="Drzava", Sex="Spol", variable="Vrednost", value="Stevilo"))
data$Spol <- gsub("Both sexes", "Oba spola", data$Spol)
data$Spol <- gsub("Female", "Zenske", data$Spol)
data$Spol <- gsub("Male", "Moski", data$Spol)
data$Vrednost <- gsub("Value", "Povprecje", data$Vrednost)
data$Vrednost <- gsub("Upper", "Zgornja meja", data$Vrednost)
data$Vrednost <- gsub("Lower", "Spodnja meja", data$Vrednost)















# Funkcija, ki uvozi tabelo pričakovane starosti iz Wikipedije
uvozi.starost <- function() {
  link <- "https://en.wikipedia.org/wiki/List_of_countries_by_life_expectancy#List_by_the_United_Nations,_for_2010%E2%80%932015"
  stran <- html_session(link) %>% read_html()
  tabela <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
    .[[1]] %>% html_table(dec = ",")
  for (i in 1:ncol(tabela)) {
    if (is.character(tabela[[i]])) {
      Encoding(tabela[[i]]) <- "UTF-8"
    }
  }
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
