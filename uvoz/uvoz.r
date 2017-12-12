# 2. faza: Uvoz podatkov

sl <- locale("sl", decimal_mark = ",", grouping_mark = ".")

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

preciscene_bolezni <- function(){
  stolpci <- c("leto","država", "kvantil", "starost", "spol", "mera", "vrednost", "zastava")
  bolezni <- read.csv("hlth_silc_11_1_Data.csv", locale=locale(encoding="cp1250"),
                      col_names = stolpci, skip=1, na=c(":", ""," ", "-"))
bolezni$zastava<- NULL
bolezni$kvantil<- NULL
bolezni$mera<- NULL
bolezni$starost<- NULL
bolezni <- bolezni[c(2,1,3,4)]
}

bolezni <- preciscene_bolezni()


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
