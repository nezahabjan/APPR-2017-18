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


#graf stevila premalo aktivnih po drzavah
bp<- ggplot(nova4, aes(x="", y=Stevilo, fill=Drzava))+
  geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) +
  labs(title="Delež neaktivnih po državah", fill="Država", x="", y="")
  

graf4 <- plot_ly(data=nova4, labels =~Drzava, values =~Stevilo, type="pie", 
                 textposition ="outside",
                 textinfo ="label+value") %>%
  layout(title="Delež neaktivnih po državah")

#graf neaktivnosti v povezavi z docakano starostjo
#grafnova4 <- ggplot(data=nova4, aes(x=Stevilo, y=Starost)) +
#  geom_jitter(aes(col=Drzava)) + geom_smooth(aes(col=Drzava), method="lm", se=F, lwd=4) + 
#  labs(col="Država", x="Število neaktivnih", title="Vpliv športne neaktivnosti na dočakano starost")

  
#Graf potrosnje za posamezna sportna podrocja po izbranih drzavah  
graf1 <- ggplot(data=subset(ociscenapotrosnjakupnamoc, Podrocje != "Total"), 
                aes(x=Drzava, y=Potrosnja, 
                    fill=factor(Podrocje, labels = c("Športna oprema",
                                                     "Vzdrževanje športnih objektov",
                                                     "Gradnja zunanjih objektov",
                                                     "Gradnja notranjih objektov",
                                                     "Rekreacijske storitve",
                                                     "športni pripomočki in storitve")))) +
   geom_bar(stat = "identity", position="stack") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  labs(fill = "Področje",
       title="Potrošnja za posamezna športna področja", y="Potrošnja", x="Država")


#graf gibanja deleza bolnih po izbranih drzavah
graf2 <- ggplot(data=subset(totalociscenihbolezni, Drzava %in% c("Finland", 
                                                                "Slovenia",
                                                                "Belgium",
                                                                "Greece",
                                                                "Bulgaria",
                                                                "Luxembourg",
                                                                "Latvia")),
                            aes(x=Leto, y=Vrednost, color=Drzava)) + geom_line(size=3) + 
  labs(color="Država", y="Delež obolelih", title="Delež obolelih po državah")


#graf deleza potrosnje za zdravje in rekreacijo, po drzavah
graf3 <- ggplot(data=ociscenadelezpotrosnje, aes(x=Leto, y=Delez, fill=Drzava)) + 
  geom_bar(stat="identity", position="stack") + facet_grid(.~ Podrocje) +
  labs(fill="Država", y="Delež", title="Deleža potrošnje za zdravje in rekreacijo")


#napoved stevila oblelih v Sloveniji, glede na preteklih 8 let
ociscena <- subset(totalociscenihbolezni, Drzava == "Slovenia")
fit <- lm(data = ociscena, Vrednost ~ Leto)
a <- data.frame(Leto=seq(2007, 2015, 0.25))
predict(fit, a)
napoved <- a %>% mutate(Vrednost=predict(fit, .))
graf5 <- ggplot(ociscena, aes(x=Leto, y=Vrednost)) +
  geom_smooth(method=lm, se=FALSE) +
  geom_point(data=napoved, aes(x=Leto, y=Vrednost), color="blue", size=3) +
  labs(title="Napoved števila obolelih za Slovenijo", y="Število obolelih")















