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
                           Drzava=="France"|
                           Drzava=="Italy"|
                           Drzava=="Latvia"|
                           Drzava=="Luxembourg"|
                           Drzava=="Slovenia"|
                           Drzava=="Finland"|
                           Drzava=="Bosnia and Herzegovina"|
                           Drzava=="Switzerland")
tabelastarosti <- tabelastarosti %>% arrange(Drzava)




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

totalociscenapotrosnjakupnamoc <- ociscenapotrosnjakupnamoc[(ociscenapotrosnjakupnamoc$podrocje=="Total"), ] 
totalociscenapotrosnjakupnamoc$podrocje <- NULL

sportociscenapotrosnjakupnamoc <- ociscenapotrosnjakupnamoc[(ociscenapotrosnjakupnamoc$podrocje=="Sports goods and services"), ] 
sportociscenapotrosnjakupnamoc$podrocje <- NULL

outdoorociscenapotrosnjakupnamoc <- ociscenapotrosnjakupnamoc[(ociscenapotrosnjakupnamoc$podrocje=="Major durables for outdoor recreation"), ] 
outdoorociscenapotrosnjakupnamoc$podrocje <- NULL

indoorociscenapotrosnjakupnamoc <- ociscenapotrosnjakupnamoc[(ociscenapotrosnjakupnamoc$podrocje=="Major durables for indoor recreation"), ] 
indoorociscenapotrosnjakupnamoc$podrocje <- NULL

opremaociscenapotrosnjakupnamoc <- ociscenapotrosnjakupnamoc[(ociscenapotrosnjakupnamoc$podrocje=="Equipment for sport, camping and open-air recreation"), ] 
opremaociscenapotrosnjakupnamoc$podrocje <- NULL






#funkcija, ki uvozi in prečisti tabelo bolezni

stolpci <- c("leto", "drzava", "kvantil", "starost", "spol", "enota", "vrednost", "prazno")
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
ociscenebolezni <- filter(ociscenebolezni, !is.na(vrednost)) %>% arrange(drzava, leto)
ociscenebolezni <- ociscenebolezni[c(2,1,3,4)]

totalociscenihbolezni <- ociscenebolezni[(ociscenebolezni$starost=="Total"), ] 
totalociscenihbolezni$starost <- NULL

mladiociscenebolezni <- ociscenebolezni[(ociscenebolezni$starost=="From 16 to 19 years"), ] 
mladiociscenebolezni$starost <- NULL

starejsiociscenebolezni <- ociscenebolezni[(ociscenebolezni$starost=="From 16 to 44 years"), ]
starejsiociscenebolezni$starost <- NULL





#funkcija, ki uvozi in prečisti tabelo deleža potrošnje

stolpci<-c("leto", "drzava", "enota", "področje", "delež", "prazno")
delezpotrosnje <- read_csv("podatki/delezpotrosnje.csv",
                           locale=locale(encoding="cp1250"),
                           col_names=stolpci,
                           skip=1,
                           n_max=1260,
                           na=c(":", "", " "))
podatki<-delezpotrosnje %>% fill(1:6) %>% drop_na(leto)
podatki$prazno<-NULL
podatki$leto<-parse_integer(podatki$leto)
ociscenadelezpotrosnje <-subset(podatki, enota=="Percentage of total" & področje!="Other major durables for recreation and culture")
ociscenadelezpotrosnje$enota <- NULL
ociscenadelezpotrosnje = ociscenadelezpotrosnje %>% arrange(drzava, leto)
ociscenadelezpotrosnje <- ociscenadelezpotrosnje[c(2,1,3,4)]

zdravjeociscenadelezpotrosnje <- ociscenadelezpotrosnje[(ociscenadelezpotrosnje$področje=="Health"), ]
zdravjeociscenadelezpotrosnje$področje <- NULL

rekreacijaociscenadelezpotrosnje <- ociscenadelezpotrosnje[(ociscenadelezpotrosnje$področje=="Recreation and culture"), ]
rekreacijaociscenadelezpotrosnje$področje <- NULL











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


#link <- "http://apps.who.int/gho/athena/data/GHO/NCD_PAC,NCD_PAA?profile=xtab&format=html&x-topaxis=GHO;SEX&x-sideaxis=COUNTRY;YEAR;AGEGROUP&x-title=table&filter=AGEGROUP:YEARS18-PLUS;COUNTRY:*;SEX:*;"
#json <- html_session(link) %>% read_html() %>% html_nodes(xpath="//script[not(@src)]") %>%3
#.[[1]] %>% html_text() %>% strapplyc("(\\{.*\\})") %>% unlist() %>% fromJSON() %>% .$Crosstable

#matrika <- json$Matrix %>% sapply(. %>% sapply(. %>% .[[1]] %>% .$disp)) %>% t()
#glava <- . %>% .$header %>% lapply(. %>% .[-1] %>% unlist() %>% { json$code[.+1] } %>%
#                                     sapply(. %>% .$disp))
#stolpci <- json$Vertical$layer %>% unlist() %>% { json$dimension[.+1] } %>% sapply(. %>% .$disp)
#
#matrika <- json$Matrix %>% sapply(. %>% sapply(. %>% .[[1]] %>% .$disp)) %>% t()
#glava <- . %>% .$header %>% lapply(. %>% .[-1] %>% unlist() %>% { json$code[.+1] } %>%
#                                     sapply(. %>% .$disp))
#stolpci <- json$Vertical$layer %>% unlist() %>% { json$dimension[.+1] } %>% sapply(. %>% .$disp)
#colnames(matrika) <- glava(json$Horizontal) %>% sapply(paste, collapse = ",")
#data <- glava(json$Vertical) %>% lapply(. %>% as.list() %>% setNames(stolpci)) %>%
#  bind_rows() %>% cbind(matrika) %>% melt(id.vars = 1:3) %>%
#  mutate(Country = factor(Country), Year = parse_number(Year),
#         value = parse_character(value, na = "No data"),
#variable = parse_character(variable)) %>% drop_na(value)%>%
#  mutate(Indicator = variable %>% strapplyc("^([^,]+)") %>% unlist() %>% factor(),
#         Sex = variable %>% strapplyc("([^,]+)$") %>% unlist() %>% factor(),
#         Value = value %>% strapplyc("^([0-9.]+)") %>% unlist(),
#         Lower = value %>% strapplyc("\\[([0-9.]+)") %>% unlist(),
#         Upper = value %>% strapplyc("([0-9.]+)\\]") %>% unlist()) %>%
#  select(-variable, -value) %>% melt(measure.vars = c("Value", "Lower", "Upper"),
#                                     variable.name = "Statistic",
#                                     value.name = "Value")



#data<-filter(data, Country=="Belgium"|
#             Country=="Bosnia and Herzegovina"|
##             Country=="Denmark"|
#             Country=="Finland"|
#             Country=="Germany"|
#             Country=="Greece"|
#             Country=="Italy"|
#             Country=="Latvia"|
#             Country=="Slovenia"|
#             Country=="France"|
#             Country=="Luxembourg"|
#             Country=="Bulgaria")
#data = data[data$Indicator=="Insufficiently active (crude estimate)",]
#data$Indicator <- NULL
#data$Year <- NULL
#data$`Age Group` <- NULL
#data = data %>% arrange(Country, Sex) 
#data = rename(data, c(Country="Drzava", Sex="Spol", variable="Vrednost", value="Stevilo"))
#data$Spol <- gsub("Both sexes", "Oba spola", data$Spol)
#data$Spol <- gsub("Female", "Zenske", data$Spol)
#data$Spol <- gsub("Male", "Moski", data$Spol)
#data$Vrednost <- gsub("Value", "Povprecje", data$Vrednost)
#data$Vrednost <- gsub("Upper", "Zgornja meja", data$Vrednost)
#data$Vrednost <- gsub("Lower", "Spodnja meja", data$Vrednost)
#data <- subset(data, data$Vrednost=="Povprecje")
#data$Vrednost <- NULL




#Funkcija, ki združi aktivnost državljanov in pričakovano starost (2010-2015) obeh spolov -> prikazan tudi graf
nova4 <- inner_join(data, tabelastarosti)


#Funkcija, ki zdruzi delez potrosnje drzavljanov za rekreacijo in stevilo resno obolelih
nova3 <- inner_join(sportociscenapotrosnjakupnamoc, totalociscenihbolezni)





# Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# fazah.
