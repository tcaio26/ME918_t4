#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(vroom)
library(ggplot2)
library(readxl)
library(dplyr)

ui <- fluidPage(
  # Título da aplicação
  titlePanel("Análise de Dados"),
  
  # Área para fazer upload do arquivo
  sidebarLayout(
    sidebarPanel(
      fileInput("upload", "Escolha um arquivo CSV ou Excel", 
                accept = c(".csv", ".xlsx")),
      uiOutput("coluna_ui"),  # UI dinâmica para escolher a primeira coluna
      uiOutput("coluna2_ui"), # UI dinâmica para escolher a segunda coluna
      hr(),
      h3("Opções de Análise"),
      selectInput("tipo_grafico", "Escolha o gráfico", 
                  choices = c("Boxplot", "Histograma", "Gráfico de Pontos")),
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Tabela", tableOutput("head")),
        tabPanel("Gráficos", 
                 plotOutput("grafico")),
      )
    )
  )
)

server <- function(input, output, session) {
  
  # Leitura do arquivo e tratamento de dados
  data <- reactive({
    req(input$upload)
    ext <- tools::file_ext(input$upload$name)
    
    # Ler o arquivo conforme a extensão
    switch(ext,
           csv = vroom::vroom(input$upload$datapath, delim = ","),
           xlsx = read_excel(input$upload$datapath),
           validate("Arquivo inválido, apenas .csv e .xlsx são aceitos")
    )
  })
  
  # Mostrar os primeiros registros da base de dados
  output$head <- renderTable({
    head(data())
  })
  
  # Criar um menu dinâmico para seleção da primeira coluna
  output$coluna_ui <- renderUI({
    req(data())
    colnames_data <- colnames(data())  # Obter os nomes das colunas
    selectInput("coluna", "Escolha uma coluna para análise", choices = colnames_data)
  })
  
  # Criar um menu dinâmico para seleção da segunda coluna
  output$coluna2_ui <- renderUI({
    req(input$coluna)
    colnames_data <- setdiff(colnames(data()), input$coluna)  # Excluir a coluna já selecionada
    selectInput("coluna2", "Escolha a segunda coluna para análise", choices = colnames_data)
  })
  
  # Gerar o gráfico baseado na escolha do usuário
  output$grafico <- renderPlot({
    req(input$coluna)
    df <- data()
    coluna <- df[[input$coluna]]  # Extrair a coluna escolhida
    coluna2 <- df[[input$coluna2]]  # Extrair a segunda coluna escolhida, se disponível
    
    # Verificar se a coluna é numérica para Boxplot e Histograma
    if (input$tipo_grafico %in% c("Boxplot", "Histograma") && !is.numeric(coluna)) {
      return(NULL)  # Não faz sentido gerar gráficos para colunas não numéricas
    }
    
    # Gráficos
    if (input$tipo_grafico == "Boxplot") {
      ggplot(df, aes(y = !!sym(input$coluna))) +  # Use !!sym() para resolver o nome da coluna
        geom_boxplot() +
        labs(title = paste("Boxplot de", input$coluna))
      
    } else if (input$tipo_grafico == "Histograma") {
      ggplot(df, aes(x = !!sym(input$coluna))) +  # Use !!sym() para resolver o nome da coluna
        geom_histogram(binwidth = 1, fill = "blue", color = "black", alpha = 0.7) +
        labs(title = paste("Histograma de", input$coluna))
      
    } else if (input$tipo_grafico == "Gráfico de Pontos") {
      # Verifica se ambas as colunas selecionadas são numéricas
      if (!is.numeric(coluna) | !is.numeric(coluna2)) {
        return(NULL)  # Não faz sentido gerar gráficos de pontos para colunas não numéricas
      }
      
      ggplot(df, aes(x = !!sym(input$coluna), y = !!sym(input$coluna2))) +
        geom_point(color = "blue") +
        labs(title = paste("Gráfico de Pontos: ", input$coluna, "vs", input$coluna2))
    }
  })
}

# Rodar a aplicação
shinyApp(ui = ui, server = server)
