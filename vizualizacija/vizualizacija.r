# 3. faza: Vizualizacija podatkov

# Uvozimo zemljevid.
zemljevid <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/OB.zip",
                             "OB/OB", encoding = "Windows-1250")
levels(zemljevid$OB_UIME) <- levels(zemljevid$OB_UIME) %>%
  { gsub("Slovenskih", "Slov.", .) } %>% { gsub("-", " - ", .) }
zemljevid$OB_UIME <- factor(zemljevid$OB_UIME, levels = levels(obcine$obcina))
zemljevid <- pretvori.zemljevid(zemljevid)


grafnova3a <- ggplot(data=nova3, aes(x=drzava, y=Stevilo, col=Spol)) + geom_point()
grafnova3b <- ggplot(data=nova3, aes(x=drzava, y=potrosnja)) + geom_point()
grafnovejsa1 <- ggplot(data=novejsa1, aes(x=država, y=vrednost, col=leto.x)) + 
  geom_point() 
grafnova4 <- ggplot(data=nova4, aes(x=Drzava, y=(0:100), col=Skupaj)) + geom_line() 

  geom_line(aes(y=Stevilo, color="Stevilo")) + 
  geom_line(aes(y=Skupaj, color="Skupaj"))
grafnova4 <- melt(nova4, id = "Drzava", measure = c("Stevilo", "Skupaj"))
ggplot(grafnova4, aes(Drzava, value, colour = variable)) + geom_line()
