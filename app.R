#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  fileInput("upload", NULL, accept = c(".csv", ".xlsx")),
  numericInput("n", "Rows", value = 5, min = 1, step = 1),
  tableOutput("head")
)

server <- function(input, output, session) {
  data <- reactive({
    req(input$upload)
    
    ext <- tools::file_ext(input$upload$name)
    switch(ext,
           csv = vroom::vroom(input$upload$datapath, delim = ","),
           excel = vroom::vroom(input$upload$datapath, delim = ";"),
           validate("Arquivo inválido, apenas .csv e .xlsx são aceitos")
    )
  })
  
  output$head <- renderTable({
    head(data(), input$n)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
