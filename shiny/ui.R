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
    
    tabPanel("Države",
             sidebarPanel(
               uiOutput("drzava")),
      
    mainPanel(
        textOutput("selected_var"),
        plotOutput("drzavaPlot")
          
)))))
