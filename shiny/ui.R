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
      textOutput("selected_var"),
      plotOutput("drzavaPlot"))),
    
    
    
    
             
    tabPanel("Potrošnja in bolezni",
             sidebarPanel(
               sliderInput("year", "Izberi leto",
                                   min = 2007, 
                                   max = 2015,
                                   value = 2007)),
      
    mainPanel(
      textOutput("drsnik"),
      plotOutput("potrosnjaPlot")
    )),
    
    
    
    tabPanel("Aktivnost in starost",
             sidebarPanel(
               radioButtons("radio", "Izberi spol",
                            choices=c("Moski", "Zenske", "Oba spola"), 
                            selected = "Oba spola")),
    mainPanel(
      textOutput("gumbi"),
      plotOutput("aktivnostPlot")
    )
             )
        
          
)))
