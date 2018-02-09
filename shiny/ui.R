library(shiny)

#shinyUI(fluidPage(
#  
#  titlePanel("Potrošnja po področjih"),
#  
#  tabsetPanel(
#      tabPanel("Velikost družine",
#               DT::dataTableOutput("druzine")),
#      
#      tabPanel("Število naselij",
#               sidebarPanel(
#                  uiOutput("pokrajine")
#                ),
#               mainPanel(plotOutput("naselja")))
#    )
#))

shinyUI(fluidPage(
  titlePanel("Potrošnja po področjih"),
  
  tabsetPanel(
    
    tabPanel("Potrošnja držav",
             sidebarPanel(
               uiOutput("drzava")),
    mainPanel(
      p("Graf prikazuje potrošnjo izbrane države glede na različna področja, kot so športni pripomočki in 
         oprema, storitve, gradnja in obnova zunanjih in notranjih športnih objektov v državi,... 
        Potrošnja je preračunana v splošno denarno valuto, glede na trenutne devizne tečaje." ),
      textOutput("selected_var"),
      plotOutput("drzavaPlot"))),
    
    
    
    
             
    tabPanel("Potrošnja in bolezni",
             sidebarPanel(
               sliderInput("year", "Izberite leto",
                                   min = 2007, 
                                   max = 2015,
                                   value = 2007)),
      
    mainPanel(
      textOutput("drsnik"),
      plotOutput("potrosnjaPlot")
    )),
    
    
    
    tabPanel("Aktivnost in starost",
             sidebarPanel(
               radioButtons("radio", "Izberite spol",
                            choices=c ("Oba spola", "Moski", "Zenske"), 
                            selected = "Oba spola")),
    mainPanel(
      textOutput("gumbi"),
      plotOutput("aktivnostPlot")
    )
             )
        
          
)))
