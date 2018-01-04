# 3. faza: Vizualizacija podatkov

# Uvozimo zemljevid.
zemljevid <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/OB.zip",
                             "OB/OB", encoding = "Windows-1250")
levels(zemljevid$OB_UIME) <- levels(zemljevid$OB_UIME) %>%
  { gsub("Slovenskih", "Slov.", .) } %>% { gsub("-", " - ", .) }
zemljevid$OB_UIME <- factor(zemljevid$OB_UIME, levels = levels(obcine$obcina))
zemljevid <- pretvori.zemljevid(zemljevid)

# Izračunamo povprečno velikost družine
povprecja <- druzine %>% group_by(obcina) %>%
  summarise(povprecje = sum(velikost.druzine * stevilo.druzin) / sum(stevilo.druzin))

grafnova3a <- ggplot(data=nova3, aes(x=drzava, y=Stevilo, col=Spol)) + geom_point()
grafnova3b <- ggplot(data=nova3, aes(x=drzava, y=potrosnja)) + geom_point()
grafnovejsa1 <- ggplot(data=novejsa1, aes(x=država, y=vrednost, col=leto.x)) + 
  geom_point() 
