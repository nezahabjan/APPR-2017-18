# 2. faza: Uvoz podatkov
sl <- locale("sl", decimal_mark = ",", grouping_mark = ".")




#Funkcija, ki uvozi in precisti tabelo iz wikipedije pricakovane starosti

link <- "https://en.wikipedia.org/wiki/List_of_countries_by_life_expectancy"
tabelastarosti <- html_session(link) %>% read_html() %>%
  html_nodes(xpath="//table[@class='wikitable sortable']") %>% .[[2]] %>% html_table()
tabelastarosti$Rank <- NULL
tabelastarosti <- rename(tabelastarosti,
                         Drzava = `State/Territory`, `Both sexes` = Overall) %>%
  melt(id.vars = "Drzava", variable.name = "Spol", value.name = "Starost")

tabelastarosti <- subset(tabelastarosti,
                           Drzava=="Belgium"|
                           Drzava=="Bulgaria"|
                           Drzava=="Denmark"|
                           Drzava=="Germany"|
                           Drzava=="Greece"|
                           Drzava=="France (metropol.)"|
                           Drzava=="Italy"|
                           Drzava=="Latvia"|
                           Drzava=="Luxembourg"|
                           Drzava=="Slovenia"|
                           Drzava=="Finland"|
                           Drzava=="Bosnia and Herzegovina"|
                           Drzava=="Switzerland")
tabelastarosti <- tabelastarosti %>% arrange(Drzava)
tabelastarosti[c(16, 17, 18), "Drzava"] <- "France"
tabelastarosti$Spol <- gsub("Both sexes", "Oba spola", tabelastarosti$Spol)
tabelastarosti$Spol <- gsub("Male", "Moski", tabelastarosti$Spol)
tabelastarosti$Spol <- gsub("Female", "Zenske", tabelastarosti$Spol)


tabelastarostizemljevid <- tabelastarosti[(tabelastarosti$Spol=="Oba spola"), ]


#Funkcija, ki uvozi in precisti tabelo potrosnje za sportne aktivnosti

stolpci <- c("Podrocje", "Drzava" , "Mera", "Leto", "Potrosnja", "Prazno")
potrosnjakupnamoc <- read_csv("podatki/potrosnjakupnamoc.csv", 
                              locale=locale(encodin="cp1250"),
                              col_names=stolpci,
                              skip=1,
                              n_max=77,
                              na=c(":", "", " "))
podatki <- potrosnjakupnamoc %>% fill(1:6) %>% drop_na(Leto)
podatki$Mera <- NULL
podatki$Leto <- NULL
podatki$Prazno <- NULL
podatki = podatki[,c(2,1,3)]
ociscenapotrosnjakupnamoc <- podatki %>% arrange(Drzava)

totalociscenapotrosnjakupnamoc <- ociscenapotrosnjakupnamoc[(ociscenapotrosnjakupnamoc$Podrocje=="Total"), ] 
totalociscenapotrosnjakupnamoc$Podrocje <- NULL

ociscenapotrosnjakupnamoc$Podrocje <- gsub("Total", "Skupaj", ociscenapotrosnjakupnamoc$Podrocje) 
ociscenapotrosnjakupnamoc$Podrocje <- gsub("Sports goods and services", "Sportne storitve", ociscenapotrosnjakupnamoc$Podrocje) 
ociscenapotrosnjakupnamoc$Podrocje <- gsub("Major durables for outdoor recreation", "Gradnja zunanjih sportnih objektov", ociscenapotrosnjakupnamoc$Podrocje) 
ociscenapotrosnjakupnamoc$Podrocje <- gsub("Major durables for indoor recreation", "Gradnja notranjih sportnih objektov", ociscenapotrosnjakupnamoc$Podrocje) 
ociscenapotrosnjakupnamoc$Podrocje <- gsub("Maintenance and repair of other major durables for recreation and culture", "Vzdrževanje in obnova rekreacijskih objektov", ociscenapotrosnjakupnamoc$Podrocje) 
ociscenapotrosnjakupnamoc$Podrocje <- gsub("Equipment for sport, camping and open-air recreation", "Sportna oprema in pripomocki", ociscenapotrosnjakupnamoc$Podrocje) 
ociscenapotrosnjakupnamoc$Podrocje <- gsub("Recreational and sporting services", "Rekreacijske storitve", ociscenapotrosnjakupnamoc$Podrocje) 




#funkcija, ki uvozi in prečisti tabelo bolezni

stolpci <- c("Leto", "Drzava", "Kvantil", "Starost", "Spol", "Enota", "Vrednost", "Prazno")
bolezni <- read_csv("podatki/bolezni.csv", 
                    locale=locale(encoding="cp1250"), 
                    col_names=stolpci,
                    skip=1,
                    n_max=651,
                    na=c(":","", " "))


podatki <- bolezni %>% fill(1:5) %>% drop_na(Leto)
podatki$Kvantil<- NULL
podatki$Enota<- NULL
podatki$Prazno<- NULL
podatki$Spol<-NULL
podatki$Leto<-parse_integer(podatki$Leto)
podatki %>% select(Leto) %>% distinct()
podatki %>% group_by(Leto)

ociscenebolezni<-subset(podatki, Starost %in% c("From 16 to 19 years",
                                                "Total",
                                                "From 16 to 44 years"))
ociscenebolezni <- filter(ociscenebolezni, !is.na(Vrednost)) %>% arrange(Drzava, Leto)
ociscenebolezni <- ociscenebolezni[c(2,1,3,4)]
ociscenebolezni$Starost <- gsub("Total", "Skupaj", ociscenebolezni$Starost)
ociscenebolezni$Starost <- gsub("From 16 to 19 years", "16 do 19 let", ociscenebolezni$Starost)
ociscenebolezni$Starost <- gsub("From 16 to 44 years", "16 do 44 let", ociscenebolezni$Starost)

totalociscenihbolezni <- ociscenebolezni[(ociscenebolezni$Starost=="Skupaj"), ] 
totalociscenihbolezni$Starost <- NULL

mladiociscenebolezni <- ociscenebolezni[(ociscenebolezni$Starost=="16 do 19 let"), ] 
mladiociscenebolezni$Starost <- NULL

starejsiociscenebolezni <- ociscenebolezni[(ociscenebolezni$Starost=="16 do 44 let"), ]
starejsiociscenebolezni$Starost <- NULL





#funkcija, ki uvozi in prečisti tabelo deleža potrošnje

stolpci<-c("Leto", "Drzava", "Enota", "Podrocje", "Delez", "Prazno")
delezpotrosnje <- read_csv("podatki/delezpotrosnje.csv",
                           locale=locale(encoding="cp1250"),
                           col_names=stolpci,
                           skip=1,
                           n_max=1260,
                           na=c(":", "", " "))
podatki<-delezpotrosnje %>% fill(1:6) %>% drop_na(Leto)
podatki$Prazno<-NULL
podatki$Leto<-parse_integer(podatki$Leto)
ociscenadelezpotrosnje <-subset(podatki, Drzava !="Bosnia and Herzegovina" & Drzava !="Switzerland" &
                                Enota=="Percentage of total" & Podrocje!="Other major durables for recreation and culture")
ociscenadelezpotrosnje$Enota <- NULL
ociscenadelezpotrosnje = ociscenadelezpotrosnje %>% arrange(Drzava, Leto)
ociscenadelezpotrosnje <- ociscenadelezpotrosnje[c(2,1,3,4)]
ociscenadelezpotrosnje$Podrocje <- gsub("Health", "Zdravje", ociscenadelezpotrosnje$Podrocje)
ociscenadelezpotrosnje$Podrocje <- gsub("Recreation and culture", "Kultura in sport", ociscenadelezpotrosnje$Podrocje)

zdravjeociscenadelezpotrosnje <- ociscenadelezpotrosnje[(ociscenadelezpotrosnje$Podrocje=="Zdravje"), ]
zdravjeociscenadelezpotrosnje$Podrocje <- NULL

rekreacijaociscenadelezpotrosnje <- ociscenadelezpotrosnje[(ociscenadelezpotrosnje$Podrocje=="Kultura in sport"), ]
rekreacijaociscenadelezpotrosnje$Podrocje <- NULL











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
         variable = parse_character(variable)) %>% drop_na(value) %>%
  mutate(Spol = variable %>% strapplyc("([^,]+)$") %>% unlist() %>% factor(),
         Povprecje = value %>% strapplyc("^([0-9.]+)") %>% unlist(),
         `Spodnja meja` = value %>% strapplyc("\\[([0-9.]+)") %>% unlist(),
         `Zgornja meja` = value %>% strapplyc("([0-9.]+)\\]") %>% unlist()) %>%
  select(-variable, -value) %>% melt(measure.vars = c("Povprecje", "Spodnja meja", "Zgornja meja"),
                                     variable.name = "Vrednost",
                                     value.name = "Stevilo") %>%
  mutate(Stevilo = parse_number(Stevilo)) %>% rename(Drzava = Country) %>%
  filter(Vrednost == "Povprecje",
         Drzava %in% c("Belgium",
                       "Bosnia and Herzegovina",
                       "Denmark",
                       "Finland",
                       "Germany",
                       "Greece",
                       "Italy",
                       "Latvia",
                       "Slovenia",
                       "France",
                       "Luxembourg",
                       "Bulgaria")) %>% select(-Year, -`Age Group`, -Vrednost)

data = data %>% arrange(Drzava, Spol)
data <- data[c(TRUE,rep(FALSE,1)),]
data$Spol <- gsub("Both sexes", "Oba spola", data$Spol)
data$Spol <- gsub("Female", "Zenske", data$Spol)
data$Spol <- gsub("Male", "Moski", data$Spol)

datazemljevid <- data[(data$Spol=="Oba spola"), ]





#Funkcija, ki združi aktivnost državljanov in pričakovano starost (2010-2015) obeh spolov -> prikazan tudi graf
nova4 <- inner_join(data, tabelastarosti)


#Funkcija, ki zdruzi delez potrosnje drzavljanov za rekreacijo in stevilo resno obolelih
nova3 <- inner_join(sportociscenapotrosnjakupnamoc, totalociscenihbolezni)





# Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# fazah.
