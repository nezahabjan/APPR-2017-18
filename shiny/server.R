library(shiny)

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
    ggplot(d, aes(x=Potrosnja, y=Vrednost, color = Drzava)) + geom_point(size=7) +
      geom_smooth(method=lm, fullrange=TRUE, color="black") +  
      geom_point(data = d, shape = 21, fill = NA, color = "black", alpha = 0.25) +
      labs(title="Število obolelih v odvisnosti od potrošnje za šport in zdravje", 
           x="Potrošnja v univerzalni valuti", y="Delež bolnih (v %)", color = "Država")
  })

  
  output$drzavaPlot <- renderPlot({
      t <- ociscenapotrosnjakupnamoc %>% filter(Drzava == input$var) %>% filter(Podrocje != "Skupaj")
    ggplot(t, aes(x=Podrocje, y=Potrosnja)) + 
      geom_bar(stat="identity", position="dodge", fill="skyblue") +
      theme(axis.text.x = element_text(angle = 60, vjust = 1, hjust = 1)) +
      labs(title="Prikaz potrošnje izbrane države po področjih", x="Področje", y="Potrošnja v univerzalni valuti")
  })
      
  output$drsnik <- renderText({
    paste("Izbrali ste leto", input$year, "!")
  })
  
  output$gumbi <- renderText ({
    paste("Izbran spol je :", input$radio, "!")
  })
  
  output$aktivnostPlot <- renderPlot({
    h <- nova4 %>% filter(Spol==input$radio)
    ggplot(h, aes(x=Starost, y=Stevilo)) + geom_jitter(size = 5) +
      geom_point() + 
      geom_smooth(method=lm, fullrange=TRUE, color="black") +  
      geom_point(data = h, shape = 21, fill = NA, color = "black", alpha = 0.25) +
      labs(title="Prikaz povezave med povprečno dočakano starostjo in številom neaktivnih", 
           x="Povprečna življenjska doba", y="Delež neaktivnih državljanov (v %)", color="Država")
  })

    
   
  })
    
  

