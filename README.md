O Shiny App criado é útil para vizualização e sumarização de variáveis numéricas de um banco de dados. Com ele é possível ver estatísticas sumárias como número de observações, média, mediana, máximo, mínimo, etc.
Também pode ser utilizado para análise gráfica com boxplots, histogramas, gráficos de dispersão e matriz de correlação.

O app pode ser acessado na internet via o link <https://ctheo.shinyapps.io/me918_t4/>

No painel à esquerda, faça o upload do seu banco de dados clicando em *browse*. Os dados devem estar no formato .csv ou .xlsx. O app é focado na análise de variáveis numéricas, portanto bancos sem variáveis desse tipo não serão interessantes.

Após o processamento, dois tipos de análise estão disponíveis: Estatísticas descritivas e gráficos.

As estatísticas descritivas encontram-se na aba "tabela", sendo elas: 
- n: número de obs.
- mean: média
- sd: desvio padrão
- median: mediana
- trimmed: média arredondada
- mad: desvio absoluto da mediana
- min: mínimo
- max: máximo
- range: amplitude
- skew e kurtosis: medidas de assimetria
- se: erro padrão

Estas estatísticas se encontram disponíveis para cada variável numérica no banco.

É possível fazer o download da tabela clicando no botão abaixo dela.

Também é possível gerar 4 tipos de gráficos. Para acessá-los, clique na aba "Gráficos" e escolha o tipo de gráfico desejado no painel à esquerda. Os tipos disponíveis são:
**Boxplot**
No painel à esquerda, selecione a variável numérica que deseja para o boxplot.

**Histograma**
No painel à esquerda, selecione a variável numérica e o número de colunas desejado.

**Gráfico de pontos/dispersão**
No painel à esquerda, selecione as duas variáveis desejadas, começando pela variável do eixo X.

**Matriz de correlação**
Matriz com gráficos de dispersão, densidade, e correlação para todas as variáveis ou par de variáveis numéricas. Só será gerado para um banco com 10 ou menos variáveis numéricas. No painel à esquerda, selecione uma variável categórica para destacar no gráfico, ou deixe em vazio.
