#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

if (!require("pacman")) install.packages("pacman")
p_load(shiny, tidyverse, vroom, ggplot2, readxl, dplyr, GGally, psych)

ui = fluidPage(
  # Título da aplicação
  titlePanel("Análise de Dados"),
  
  # Área para fazer upload do arquivo
  sidebarLayout(
    sidebarPanel(
      fileInput("upload", "Escolha um arquivo CSV ou Excel", 
                accept = c(".csv", ".xlsx")),
      h3("Opções de Análise"),
      selectInput("tipo_grafico", "Escolha o gráfico", 
                  choices = c("Boxplot", "Histograma", "Gráfico de Pontos", "Matriz de Correlação")),
      uiOutput("coluna_ui"),  # UI dinâmica para escolher a primeira coluna
      uiOutput("slider_hist"),
      uiOutput("coluna2_ui"), # UI dinâmica para escolher a segunda coluna
      uiOutput("coluna_cor"),
      hr(),
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Tabela", tableOutput("summary"), uiOutput('baixar')),
        tabPanel("Gráficos", 
                 plotOutput("grafico")),
      )
    )
  )
)

server = function(input, output, session) {
  
  theme_set(theme_bw())
  # Leitura do arquivo e tratamento de dados
  data = reactive({
    req(input$upload)
    ext = tools::file_ext(input$upload$name)
    
    # Ler o arquivo conforme a extensão
    switch(ext,
           csv = vroom::vroom(input$upload$datapath, delim = ","),
           xlsx = read_excel(input$upload$datapath),
           validate("Arquivo inválido, apenas .csv e .xlsx são aceitos")
    )
  })
  
  # Mostrar os primeiros registros da base de dados
  output$summary = renderTable({
    df = data()
    df_numerico = df[,sapply(df, is.numeric)] %>% drop_na()
    tab = as.data.frame(describe(df_numerico))
    cbind(variavel = colnames(df_numerico), tab[,-1])
  })
  
  # Criar um menu dinâmico para seleção da primeira coluna
  output$coluna_ui = renderUI({
    if(req(input$tipo_grafico)!='Matriz de Correlação'){
    colnames_data = colnames(data())  # Obter os nomes das colunas
    selectInput("coluna", "Escolha uma coluna para análise", choices = colnames_data)
  }})
  
  output$slider_hist = renderUI({
    if(req(input$tipo_grafico)=='Histograma'){
      sliderInput("bins","Número de colunas",1,100,30)
    }
  })
  
  # Criar um menu dinâmico para seleção da segunda coluna
  output$coluna2_ui = renderUI({
    if(req(input$tipo_grafico)=='Gráfico de Pontos'){
    colnames_data = setdiff(colnames(data()), input$coluna)  # Excluir a coluna já selecionada
    selectInput("coluna2", "Escolha a segunda coluna para análise", choices = colnames_data)
  }})
  
  output$coluna_cor = renderUI({
    if(req(input$tipo_grafico)=='Matriz de Correlação'){
      df = data()
      colnames_naonum = colnames(df[,!sapply(df, is.numeric)])
      selectInput('var_cor', "Escolha uma variável para a cor do gráfico (opcional)", 
                  choices = c('Nenhuma', colnames_naonum))
    }
  })
  
  output$baixar = renderUI({
    req(data())
    downloadButton("tabela")
  })
  
  # Gerar o gráfico baseado na escolha do usuário
  output$grafico = renderPlot({
    req(input$coluna)
    df = data()
    df_numerico = df[,sapply(df,is.numeric)]
    if(req(input$tipo_grafico)!='Matriz de Correlação')coluna = df[[input$coluna]]  # Extrair a coluna escolhida
    if(req(input$tipo_grafico)=='Gráfico de Pontos')coluna2 = df[[input$coluna2]]  # Extrair a segunda coluna escolhida, se disponível
    
    # Verificar se a coluna é numérica para Boxplot e Histograma
    if (input$tipo_grafico %in% c("Boxplot", "Histograma") && !is.numeric(coluna)) {
      return(NULL)  # Não faz sentido gerar gráficos para colunas não numéricas
    }
    
    # Gráficos
    if (input$tipo_grafico == "Boxplot") {
      ggplot(df, aes(y = !!sym(input$coluna))) +  # Use !!sym() para resolver o nome da coluna
        geom_boxplot(color = 'darkred', width = 0.3) +
        labs(title = paste("Boxplot de", input$coluna))+
        scale_x_continuous(limits = c(-1,1))+
        theme(axis.text.x = element_blank(), plot.title = element_text(hjust = 0.5))
      
    } else if (input$tipo_grafico == "Histograma") {
      ggplot(df, aes(x = !!sym(input$coluna))) +  # Use !!sym() para resolver o nome da coluna
        geom_histogram(bins = input$bins, color = 'antiquewhite', fill = 'darkred') +
        labs(title = paste("Histograma de", input$coluna))+
        theme(plot.title = element_text(hjust = 0.5))
      
    } else if (input$tipo_grafico == "Gráfico de Pontos") {
      # Verifica se ambas as colunas selecionadas são numéricas
      if (!is.numeric(coluna) | !is.numeric(coluna2)) {
        return(NULL)  # Não faz sentido gerar gráficos de pontos para colunas não numéricas
      }
      
      ggplot(df, aes(x = !!sym(input$coluna), y = !!sym(input$coluna2))) +
        geom_point(color = "darkred") +
        labs(title = paste("Gráfico de Pontos: ", input$coluna, "vs", input$coluna2))
    } else if (input$tipo_grafico == 'Matriz de Correlação'){
      n = ncol(df_numerico)
      validate(need(n<=10, "Limite máximo de 10 colunas numéricas"))
      if(input$var_cor=="Nenhuma")ggpairs(df, columns = which(sapply(df, is.numeric)))
      else ggpairs(df, columns = which(sapply(df, is.numeric)), aes(color = !!sym(input$var_cor)))
    }
  })
  
  output$tabela = downloadHandler(filename = "estatisticas.csv",
                                    content = function(file){
                                      df = data()
                                      df_numerico = df[,sapply(df, is.numeric)] %>% drop_na()
                                      tab = as.data.frame(describe(df_numerico))
                                      tab = as.data.frame(cbind(variavel = colnames(df_numerico), tab[,-1]))
                                      write_csv(tab, file)
                                    })
}

# Rodar a aplicação
shinyApp(ui = ui, server = server)
