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
  guides(legend) + labs(title="Prikaz stevila premalo aktivnih drzavljanov v (%)") + 
  coord_cartesian(xlim = c(-25, 35), ylim = c(35, 70))

#Zemljevid, ki prikazuje povprečno življenjsko dobo državljanov v posameznih evropskih državah
ggplot() + geom_polygon(data = left_join(zemljevid, tabelastarostizemljevid, 
                                         by=c("NAME_LONG"="Drzava")), 
                        aes(x=long, y=lat, group = group, fill = Starost)) + 
  guides(legend) + ggtitle("Prikaz povprecne zivljenjske dobe") +
  coord_cartesian(xlim = c(-25, 35), ylim = c(35, 70))



  
#graf deleža neaktivnih ljudi po posameznih državah 
#graf4 <- plot_ly(data=nova4, labels =~Drzava, values =~Stevilo, type="pie", 
#                 textposition ="outside",
#                 textinfo ="label+value") %>%
#  layout(title="Delez neaktivnih po drzavah")


#Graf potrosnje za posamezna sportna podrocja po izbranih drzavah, v univerzalni denarni valuti  
graf1 <- ggplot(data=subset(ociscenapotrosnjakupnamoc, Podrocje != "Skupaj"), 
                aes(x=Drzava, y=Potrosnja, 
                    fill=factor(Podrocje, labels = c("Sportna oprema",
                                                     "Vzdrzevanje sportnih objektov",
                                                     "Gradnja zunanjih objektov",
                                                     "Gradnja notranjih objektov",
                                                     "Rekreacijske storitve",
                                                     "Sportni pripomocki in storitve")))) +
   geom_bar(stat = "identity", position="stack") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  labs(fill = "Podrocje",
       title="Potrosnja za posamezna sportna podrocja", y="Potrosnja v univerzalni valuti", x="Drzava")


#graf gibanja deleza bolnih po izbranih drzavah
graf2 <- ggplot(data=subset(totalociscenihbolezni, Drzava %in% c("Finland", 
                                                                "Slovenia",
                                                                "Belgium",
                                                                "Greece",
                                                                "Bulgaria",
                                                                "Luxembourg",
                                                                "Latvia")),
                            aes(x=Leto, y=Vrednost, color=Drzava)) + geom_line(size=3) + 
  labs(color="Drzava", y="Delez obolelih (v %)", title="Delez obolelih po drzavah")


#graf deleza potrosnje za zdravje in rekreacijo, po drzavah
graf3 <- ggplot(data=ociscenadelezpotrosnje, aes(x=Leto, y=Delez/12, fill="pink")) + 
  geom_bar(stat="identity", position="stack") + facet_grid(.~ Podrocje) +
  labs(y="Povprecni delez potrosnje (v %)", fill="Barva",
       title="Povprecna deleza potrosnje izbranih drzav za zdravje in sport") 
  

#napoved stevila obolelih v Sloveniji, glede na preteklih 8 let
ociscena <- subset(totalociscenihbolezni, Drzava == "Slovenia")
fit <- lm(data = ociscena, Vrednost ~ Leto)
a <- data.frame(Leto=seq(2007, 2015, 0.25))
predict(fit, a)
napoved <- a %>% mutate(Vrednost=predict(fit, .))
graf5 <- ggplot(ociscena, aes(x=Leto, y=Vrednost)) +
  geom_smooth(method=lm, se=FALSE) +
  geom_point(data=napoved, aes(x=Leto, y=Vrednost), color="blue", size=3) +
  labs(title="Napoved stevila obolelih za Slovenijo", y="Odstotek obolelih (v %)")















