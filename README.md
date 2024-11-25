O Shiny App criado é útil para vizualização e sumarização de variáveis numéricas de um banco de dados. Com ele é possível ver estatísticas sumárias como número de observações, média, mediana, máximo, mínimo, etc.
Também pode ser utilizado para análise gráfica com boxplots, histogramas, gráficos de dispersão e matriz de correlação.

Para acessar o app, basta entrar em <https://ctheo.shinyapps.io/me918_t4/> e inserir a base de dados que deseja analisar no botão "Upload". Assim que processado, a tabela com as estatísticas das variáveis aparecerá na aba "Tabela" sendo possível fazer seu download com o nome "estatisticas.csv".
Para análisar os gráficos basta entrar na aba "Gráficos" e escolher o tipo no painel à esquerda (Boxplot, Histograma, Gráfico de pontos e Matriz de correlação). Cada gráfico possui sua especificação.
No boxplot é nessessário apenas escolher sua variável de interesse.
Quando é selecionado o histograma, é nessessário escolher a váriavel e a quantidade de barras de sua escolha.
No gráfico de pontos, um novo campo aparece para selecionar a segunda variável do seu gráfico de dispersão.
Na matriz de correlação há a opção de utilizar variáveis categóricas para separar as análises. Neste tipo de gráfico foi colocado um limite de até 10 variáveis numéricas, tendo em vista que a partir disso a vizualização é prejudicada e a geração da imagem é mais demorada.
