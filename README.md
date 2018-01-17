# Analiza podatkov s programom R, 2017/18

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2017/18

# Analiza vpliva razpoložljivega dohodka na športno udejstvovanje in življenjsko dobo ljudi

Preučila bom vpliv višine mesečnega dohodka (realno ledano po kupni moči) državljana nekaterih izbranih evropskih držav, na njihovo udejstvovanje v športu in delež izdatkov za športne aktivnosti. S tem bom povezala zdravstveno stanje povprečnega državljana (daljše in resnejše bolezni ter življenjsko dobo). Moj cilj pri analizi podatkov je ugotoviti kako status oziroma finančna preskrbljenost posameznika vpliva na lastno skrb za zdravje, v smislu športnih aktivnosti in koliko se to dejanjsko pozna v celotni populaciji.

viri tabel:
- http://ec.europa.eu/eurostat/tgm/refreshTableAction.do?tab=table&plugin=1&pcode=sdg_10_10&language=en
- http://ec.europa.eu/eurostat/tgm/refreshTableAction.do?tab=table&plugin=1&pcode=tsdpc520&language=en
- http://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=sprt_pcs_hbs&lang=en
- http://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=hlth_silc_11&lang=en
- http://www.who.int/gho/ncd/risk_factors/physical_activity/en/
- http://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=demo_mlexpecedu&lang=en
- https://en.wikipedia.org/wiki/List_of_countries_by_life_expectancy#List_by_the_United_Nations,_for_2010%E2%80%932015

spremenljivke:
- leta
- države
- delež premalo aktivnega prebivalstva
- življenjska doba
- delež dohodka, ki ga posameznik nameni športnim aktivnostim
- delež prebivalstva z daljšimi, resnejšimi boleznimi

tabele po vrsti prikazujejo:
-povprečno življenjsko dobo državljanov izbranih držav v letih od 2010 do 2015
-delež potrošnje za športne aktivnosti, ločena na zunanje, notranje športne objekte, opremo za športne aktivnosti in športno udejstvovanje
-delež prebivalstva z resnejšimi boleznimi, v letu 2010, po izbranih državah
-delež potrošnje državljanov za zdravje in rekreacijo
-delež premalo aktivnih državljanov po državah, za leto 2010

Prva združena tabela vsebuje prikaz podatkov aktivnosti državljanov in pričakovane življenjske starosti.
Druga združena tabela predstavlja povezavo med deležem potrošnje za športne aktivnosti in številom resneje obolelih državljanov v posamezni državi.

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`. Ko ga prevedemo,
se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`. Podatkovni
viri so v mapi `podatki/`. Zemljevidi v obliki SHP, ki jih program pobere, se
shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `maptools` - za uvoz zemljevidov
* `sp` - za delo z zemljevidi
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `reshape2` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)
