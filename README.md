# Analiza podatkov s programom R, 2017/18

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2017/18

## Tematika

Preučila bom vpliv višine mesečne plače državljana nekaterih izbranih evropskih držav, na njihovo udejstvovanje v športu. S tem bom povezala zdravstveno stanje povprečnega državljana (daljše in resnejše bolezni ter življenjsko dobo). Moj cilj pri analizi podatkov je ugotoviti kako status oziroma finančna preskrbljenost posameznika vpliva na lastno skrb za zdravje, v smislu športnih aktivnosti in koliko se to dejanjsko pozna v celotni populaciji.

viri tabel:
- http://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=hlth_silc_11&lang=en
- http://www.who.int/gho/ncd/risk_factors/physical_activity/en/
- http://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=demo_mlexpecedu&lang=en
- http://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=earn_gr_isco&lang=en

spremenljivke:
- leta (2010 - 2015)
- države (10 držav)
- delež premalo aktivnega prebivalstva
- življenjska doba
- letna plača
- delež prebivalstva z daljšimi, resnejšimi boleznimi
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
