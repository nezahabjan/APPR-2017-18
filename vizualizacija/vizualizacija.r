# 3. faza: Vizualizacija podatkov

# Uvozimo zemljevid.
zemljevid <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/OB.zip",
                             "OB/OB", encoding = "Windows-1250")
levels(zemljevid$OB_UIME) <- levels(zemljevid$OB_UIME) %>%
  { gsub("Slovenskih", "Slov.", .) } %>% { gsub("-", " - ", .) }
zemljevid$OB_UIME <- factor(zemljevid$OB_UIME, levels = levels(obcine$obcina))
zemljevid <- pretvori.zemljevid(zemljevid)


grafnovejsa1 <- ggplot(data=novejsa1, aes(x=država, y=vrednost, color=leto.x, size=delež)) + 
  geom_point() + scale_size(range=c(1,6))
#graf vpliva aktivnosti na starost prebivalstva
grafnova4 <- ggplot(data=nova4, aes(x=Drzava, y=Stevilo, size=Skupaj)) + geom_point()
  
#graf vpliva kupne moči na aktivnost državljanov
grafnova3 <- ggplot(data=nova3, aes(x=drzava, y=Spol, color=potrosnja, size=Stevilo)) +
  geom_point() + scale_size_manual(values=c(12:43,0.3))

