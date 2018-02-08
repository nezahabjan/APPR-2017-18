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
      p("raf prikazuje potrošnjo izbrane države lede na različna področja, kot so športni pripomočki in 
         oprema, storitve, radnja in obnova zunanji in notranji športni objektov v državi,... 
        Potrošnja je preračunana v splošno denarno valuto, lede na trenutne devizne tečaje." ),
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
