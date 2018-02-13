# 4. faza: Analiza podatkov

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



