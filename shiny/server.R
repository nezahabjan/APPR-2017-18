library(shiny)

#shinyServer(function(input, output) {
#  output$druzine <- DT::renderDataTable({
#    dcast(druzine, obcina ~ velikost.druzine, value.var = "stevilo.druzin") %>%
#      rename(`Občina` = obcina)
#  })
#  
#  output$pokrajine <- renderUI(
#    selectInput("pokrajina", label="Izberi pokrajino",
#                choices=c("Vse", levels(obcine$pokrajina)))
#  )
#  output$naselja <- renderPlot({
#    main <- "Pogostost števila naselij"
#    if (!is.null(input$pokrajina) && input$pokrajina %in% levels(obcine$pokrajina)) {
#      t <- obcine %>% filter(pokrajina == input$pokrajina)
#      main <- paste(main, "v regiji", input$pokrajina)
#    } else {
#      t <- obcine
#    }
#    ggplot(t, aes(x = naselja)) + geom_histogram() +
#      ggtitle(main) + xlab("Število naselij") + ylab("Število občin")
#  })
#})


shinyServer(function(input, output){
  output$selected_var <- renderText({ 
    paste("Izbrana država je", input$var, "!")
    })
  
  output$drzava <- renderUI(
    selectInput("var", label = "Izberite državo",
                choices = c("Slovenia",
                "Latvia",
                "Bulgaria",
                "Belgium",
                "France",
                "Finland",
                "Luxembourg",
                "Greece",
                "Germany",
                "Denmark",
                "Italy")))
  
  output$potrosnjaPlot <- renderPlot({
    d <- nova3 %>% filter(Leto == input$year)
    ggplot(d, aes(x=Potrosnja, y=Vrednost, color = Drzava)) + geom_jitter(size=6) +
      labs(title="Število obolelih v odvisnosti od potrošnje za šport in zdravje", 
           x="Potrošnja", y="Delež bolnih (v %)", color = "Država")
  })

  
  output$drzavaPlot <- renderPlot({
      t <- ociscenapotrosnjakupnamoc %>% filter(Drzava == input$var) %>% filter(Podrocje != "Skupaj")
    ggplot(t, aes(x=Podrocje, y=Potrosnja)) +
      geom_bar(stat="identity", position="dodge", fill="skyblue") +
      theme(axis.text.x = element_text(angle = 60, vjust = 1, hjust = 1)) +
      labs(title="Prikaz potrošnje izbrane države po področjih", x="Področje", y="Potrošnja")
  })
      
  output$drsnik <- renderText({
    paste("Izbrali ste leto", input$year, "!")
  })
  
  output$gumbi <- renderText ({
    paste("Izbran spol je :", input$radio, "!")
  })
  
  output$aktivnostPlot <- renderPlot({
    h <- nova4 %>% filter(Spol==input$radio)
    ggplot(h, aes(x=Starost, y=Stevilo, color = Drzava)) + geom_jitter(size = 5) +
      labs(title="Prikaz povezave med povprečno dočakano starostjo in številom neaktivni", 
           x="Povprečna življenjska doba", y="Delež neaktivnih državljanov (v %)", color="Država")
  })

    
   
  })
    
  

