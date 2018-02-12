library(shiny)

shinyUI(fluidPage(
  titlePanel("Zdravstveno stanje državljanov v odvisnosti od rekreacije in potrošnje za šport"),
  
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
      p("Graf prikazuje odvisnost deleža resno obolelih državljanov od velikosti njihove potrošnje
        za šport in zdravje. Ta je v grafu izražena v univerzalni valuti, število obolelih pa je 
        izraženo v odstotkih od števila vseh prebivalcev v posamezni državi."),
      textOutput("drsnik"),
      plotOutput("potrosnjaPlot")
    )),
    
    
    
    tabPanel("Aktivnost in starost",
             sidebarPanel(
               radioButtons("radio", "Izberite spol",
                            choices=c ("Oba spola", "Moski", "Zenske"), 
                            selected = "Oba spola")),
    mainPanel(
      p("Graf prikazuje odvisnost deleža neaktivnih državljanov od povprečne starosti, ki jo ti
        dočakajo."),
      textOutput("gumbi"),
      plotOutput("aktivnostPlot")
    )
             )
        
          
)))
