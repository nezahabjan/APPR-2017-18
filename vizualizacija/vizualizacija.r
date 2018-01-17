# 3. faza: Vizualizacija podatkov

# Uvozimo zemljevid.
zemljevid <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_countries.zip",
                             "ne_110m_admin_0_countries", encoding = "") %>% pretvori.zemljevid()
zemljevid <- zemljevid %>% filter (CONTINENT %in% c("Europe")| 
                                     NAME_LONG %in% c("Germany",
                                                      "Slovenia",
                                                      "Belgium",
                                                      "Bulgaria",
                                                      "Bosnia and Herzegovina",
                                                      "Denmark",
                                                      "Finland",
                                                      "Greece",
                                                      "Italy",
                                                      "Latvia",
                                                      "France",
                                                      "Luxembourg"))



#zemljevid, ki prikazuje stevilo premalo aktivnih državljanov izbranih držav po Evropi                                   
ggplot() + geom_polygon(data = left_join(zemljevid, datazemljevid, 
                                         by=c("NAME_LONG"="Drzava")), 
                        aes(x=long, y=lat, group = group, fill = Stevilo)) + 
  guides(legend)

#Zemljevid, ki prikazuje povprečno življenjsko dobo državljanov v posameznih evropskih državah
ggplot() + geom_polygon(data = left_join(zemljevid, tabelastarostizemljevid, 
                                         by=c("NAME_LONG"="Drzava")), 
                        aes(x=long, y=lat, group = group, fill = Starost)) + 
  guides(legend)





#graf vpliva aktivnosti na starost prebivalstva
grafnova4 <- ggplot(data=nova4, aes(x=Drzava, y=Spol, size=Stevilo, color=Starost)) + 
  geom_point() + 
  ggtitle("Vpliv športne aktivnosti na življenjsko starost")
  
#graf, ki povezuje stevilo obolelih z delezem potrosnje za rekreacijo
grafnova3 <- ggplot(data=nova3, aes(y=drzava, x=leto, col=potrosnja, size=vrednost)) + 
  geom_line() +
  ggtitle("Vpliv deleža potrošnje za šport na število bolezni")







