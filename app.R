## app that
## updates the county as the state changes  
## changes the county label for 
## Alaska and  Louisiana to
## Borough and Parish respectively

library(shiny)
library(dplyr)
library(openintro,warn.conflicts = FALSE)
states<- unique(county$state)

ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(
            selectInput("state","State",choices = states),
            selectInput("county","County",choices = NULL),
            actionButton("label","Label")
        ),
        mainPanel(
            tableOutput("table")
        )
    )
)

server <- function(input, output, session) {
    names_of_county<- reactive({
        req(input$state)
        county %>% filter(state==input$state)
    })
    observeEvent(names_of_county(),{
        
        choices<- unique(names_of_county()$name)
        updateSelectInput(inputId = "county",choices = choices )
    })
    observeEvent(input$state,{
        label<- if(input$state=="Louisiana")
            paste("Parish")
        else if(input$state=="Alaska")
            paste("Borough")
        else("County")
        updateActionButton(inputId = "county",label=label)
    })
    
    output$table<- renderTable({
        head(names_of_county())
    })
}

shinyApp(ui, server)
