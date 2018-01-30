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
  guides(legend) + ggtitle("Športna aktivnost državljanov") + 
  coord_cartesian(xlim = c(-25, 35), ylim = c(35, 70))

#Zemljevid, ki prikazuje povprečno življenjsko dobo državljanov v posameznih evropskih državah
ggplot() + geom_polygon(data = left_join(zemljevid, tabelastarostizemljevid, 
                                         by=c("NAME_LONG"="Drzava")), 
                        aes(x=long, y=lat, group = group, fill = Starost)) + 
  guides(legend) + ggtitle("Povprečna življenjska doba") +
  coord_cartesian(xlim = c(-25, 35), ylim = c(35, 70))





#graf vpliva aktivnosti na starost prebivalstva
grafnova4 <- ggplot(data=nova4, aes(x=Drzava, y=Spol, size=Stevilo, color=Starost ) ) + 
  geom_point() + 
  ggtitle("Vpliv športne aktivnosti na življenjsko starost") + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  guides(size=guide_legend("Premalo aktivnih"))
  

  
#Graf potrošnje za posamezna športna področja po izbranih državah  
graf1 <- ggplot(data=subset(ociscenapotrosnjakupnamoc, Podrocje != "Total"), 
                aes(x=Drzava, y=Potrosnja, fill=Podrocje)) +
   geom_bar(stat = "identity", position="stack") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  labs(title="Potrošnja za posamezna športna področja", y="Potrosnja", x="Drzava")


#graf gibanja deleza bolnih po izbranih drzavah
graf2 <- ggplot(data=subset(totalociscenihbolezni, Drzava %in% c("Finland", 
                                                                "Slovenia",
                                                                "Belgium",
                                                                "Greece",
                                                                "Bulgaria",
                                                                "Luxembourg",
                                                                "Latvia")),
                            aes(x=Leto, y=Vrednost, color=Drzava)) + geom_line(size=3) + 
  ggtitle("Delež bolnih po državah")


#graf deleza potrosnje za zdravje in rekreacijo, po drzavah
graf3 <- ggplot(data=ociscenadelezpotrosnje, aes(x=Leto, y=Delez, fill=Drzava)) + 
  geom_bar(stat="identity", position="stack") + facet_grid(.~ Podrocje) +
  labs(title="Deleža potrošnje za zdravje in rekreacijo")


