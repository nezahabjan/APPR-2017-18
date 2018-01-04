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
ociscenebolezni <- filter(ociscenebolezni, !is.na(vrednost)) %>% arrange(država, leto)
ociscenebolezni <- ociscenebolezni[c(2,1,3,4)]

totalociscenihbolezni <- ociscenebolezni[(ociscenebolezni$starost=="Total"), ] 
totalociscenihbolezni$starost <- NULL

mladiociscenebolezni <- ociscenebolezni[(ociscenebolezni$starost=="From 16 to 19 years"), ] 
mladiociscenebolezni$starost <- NULL

starejsiociscenebolezni <- ociscenebolezni[(ociscenebolezni$starost=="From 16 to 44 years"), ]
starejsiociscenebolezni$starost <- NULL





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
ociscenadelezpotrosnje <-subset(podatki, enota=="Percentage of total" & področje!="Other major durables for recreation and culture")
ociscenadelezpotrosnje$enota <- NULL
ociscenadelezpotrosnje = ociscenadelezpotrosnje %>% arrange(država, leto)
ociscenadelezpotrosnje <- ociscenadelezpotrosnje[c(2,1,3,4)]

zdravjeociscenadelezpotrosnje <- ociscenadelezpotrosnje[(ociscenadelezpotrosnje$področje=="Health"), ]
zdravjeociscenadelezpotrosnje$področje <- NULL

rekreacijaociscenadelezpotrosnje <- ociscenadelezpotrosnje[(ociscenadelezpotrosnje$področje=="Recreation and culture"), ]
rekreacijaociscenadelezpotrosnje$področje <- NULL





#funkcija, ki uvozi in prečisti tabelo kupne moči

stolpci<-c("leto", "država", "mera", "potrošnja", "vrednost", "prazno")
kupnamoc <- read_csv("podatki/kupnamoc.csv", 
                     locale = locale(encoding="cp1250"),
                     col_names=stolpci,
                     skip=1,
                     n_max=13300,
                     na=c(":", "", " "))
podatki<-kupnamoc %>% fill(1:6) %>% drop_na(leto)
podatki$prazno<-NULL
podatki$leto<-parse_integer(podatki$leto)

ociscenakupnamoc <- subset(podatki, potrošnja=="Actual individual consumption")
naslednjakupnamoc <- subset(ociscenakupnamoc, mera=="Price level indices (EU28=100)"
                         | mera=="Nominal expenditure as a percentage of GDP (GDP=100)")
naslednjakupnamoc$potrošnja <- NULL
koncnakupnamoc <- subset(naslednjakupnamoc, država=="European Union (28 countries)"|
                         država=="Belgium"|
                         država=="Bulgaria"|
                         država=="Denmark"|
                         država=="Germany (until 1990 former territory of the FRG)"|
                         država=="Greece"|
                         država=="France"|
                         država=="Italy"|
                         država=="Latvia"|
                         država=="Luxembourg"|
                         država=="Slovenia"|
                         država=="Finland"|
                         država=="Bosnia and Herzegovina"|
                         država=="Switzerland")







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











<<<<<<< HEAD
# Funkcija, ki uvozi tabelo pričakovane starosti iz Wikipedije
uvozi.starost <- function() {
  #link <- "https://en.wikipedia.org/wiki/List_of_countries_by_life_expectancy#List_by_the_United_Nations,_for_2010%E2%80%932015"
  link <- "http://apps.who.int/gho/athena/data/GHO/NCD_PAC,NCD_PAA?profile=xtab&format=html&x-topaxis=GHO;SEX&x-sideaxis=COUNTRY;YEAR;AGEGROUP&x-title=table&filter=AGEGROUP:YEARS18-PLUS;COUNTRY:*;SEX:*;"
  stran <- html_session(link) %>% read_html()
  json <- stran %>% html_nodes(xpath="//script") %>% .[[3]] %>% html_text() %>%
    strapplyc("(\\{.*\\})") %>% unlist() %>% fromJSON()
  tabela <- json$Crosstable$Matrix %>% sapply(. %>% sapply(. %>% .[[1]] %>% .$disp)) %>% t() %>% data.frame()
  colnames(tabela) <- c("mesto", "država", "skupaj", "moški", "ženske")
=======




# Funkcija, ki uvozi tabelo umrljivosti iz Wikipedije
uvozi.smrtnost <- function() {
  link <- "https://en.wikipedia.org/wiki/List_of_sovereign_states_and_dependent_territories_by_mortality_rate"
  stran <- html_session(link) %>% read_html()
  tabela <- stran %>% html_nodes(xpath="//table[@class='sortable wikitable']") %>% 
    .[[1]] %>% html_table(dec=",", fill=TRUE)
  for (i in 1:ncol(tabela)) {
    if (is.character(tabela[[i]])) {
      Encoding(tabela[[i]]) <- "UTF-8"
    }
  }
tabela <- tabela[, c(1, 3)]

>>>>>>> 47b97175e6181178b705af3a13029a348985b899
  
}

  return(tabela)
  


#Funkcija, ki združi tabelo bolezni in deleža potrošnje za zdravje
nova1 <- inner_join(totalociscenihbolezni, zdravjeociscenadelezpotrosnje, 
                    by=("država"), 
                    copy=FALSE)
novejsa1 <- nova1[nova1$leto.x==nova1$leto.y, ]
novejsa1$leto.y <- NULL


#Funkcija, ki združi tabelo bolezni in deleža potrošnje za rekreacijo in kulturo
nova2 <- inner_join(totalociscenihbolezni, rekreacijaociscenadelezpotrosnje, 
                    by=("država"), 
                    copy=FALSE)
novejsa2 <- nova2[nova2$leto.x==nova2$leto.y, ]
novejsa2$leto.y <- NULL


#Funkcija, ki združi kupno moč in aktivnost državljanov v letu 2010
nova2 <- inner_join(ociscenapotrosnjakupnamoc, data, by=c("drzava"="Drzava"))
novejsa2 = nova2 %>% arrange(drzava, Spol, Vrednost, Stevilo, podrocje)
novejsa2 = novejsa2[c(1,4,5,6,2,3)]





# Zapišimo podatke v razpredelnico obcine
obcine <- uvozi.obcine()
# Zapišimo podatke v razpredelnico druzine.
druzine <- uvozi.druzine(levels(obcine$obcina))

# Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# fazah.
