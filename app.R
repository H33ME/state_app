## app that
## updates the county as the state changes  
## changes the county label for 
## Alaska and  Louisiana to
## Borough and Parish respectively
## displays the table of the selected county

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
    observeEvent(input$state, {
        label<- if(input$state=="Louisiana") {
            paste("Parish")
        } else if(input$state=="Alaska") {
            paste("Borough")
        } else {
            paste("County")
        }
        updateActionButton(inputId = "county",label=label)
    })
    
    output$table<- renderTable({
        names_of_county()[names_of_county()$name== input$county,]
    })
}

shinyApp(ui, server)

