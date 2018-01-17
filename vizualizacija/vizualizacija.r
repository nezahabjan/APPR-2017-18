# 3. faza: Vizualizacija podatkov

# Uvozimo zemljevid.
zemljevid <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_countries.zip",
                             "ne_110m_admin_0_countries", encoding = "") %>% pretvori.zemljevid()
zemljevid <- zemljevid %>% filter (CONTINENT %in% c("Europe")| NAME_LONG %in% c("Turkey", "Cyprus", "Northern Cyprus"),
                                   NAME_LONG != "Russian Federation")

#zemljevid <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/OB.zip",
#                            "OB/OB", encoding = "Windows-1250")
#levels(zemljevid$OB_UIME) <- levels(zemljevid$OB_UIME) %>%
#  { gsub("Slovenskih", "Slov.", .) } %>% { gsub("-", " - ", .) }
#zemljevid$OB_UIME <- factor(zemljevid$OB_UIME, levels = levels(obcine$obcina))
#zemljevid <- pretvori.zemljevid(zemljevid)




#graf vpliva aktivnosti na starost prebivalstva
grafnova4 <- ggplot(data=nova4, aes(x=Drzava, y=Spol, size=Stevilo, color=Starost)) + 
  geom_point() + 
  ggtitle("Vpliv športne aktivnosti na življenjsko starost")
  
#graf, ki povezuje stevilo obolelih z delezem potrosnje za rekreacijo
grafnova3 <- ggplot(data=nova3, aes(y=drzava, x=leto, col=potrosnja, size=delež)) + 
  geom_line() +
  ggtitle("Vpliv deleža potrošnje za šport na število bolezni")







