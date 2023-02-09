## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- eval = TRUE, echo = F---------------------------------------------------
execute <- T
if(!('ranger' %in% installed.packages())){
  execute <- F
  print("This vignetted requires the `ranger` package to be installed for execution.")
}

## ----setup, warning = F, message = FALSE, eval = execute----------------------
# install.packages('ranger')
library(ranger)
library(ggplot2)
library(PieGlyph)
library(dplyr)

## ----data,warning = F, message = FALSE, eval = execute------------------------
head(iris)

## ----model, warning = F, eval = execute---------------------------------------
rf <- ranger(Species ~ Petal.Length + Petal.Width + 
                        Sepal.Length + Sepal.Width, 
             data=iris, probability=TRUE)

## ----predictions, warning = F, eval = execute---------------------------------
preds <- as.data.frame(predict(rf, iris)$predictions)
head(preds)

## ----plot_data, warning = F, eval = execute-----------------------------------
plot_data <- cbind(iris, preds)
head(plot_data)

## ---- eval = execute----------------------------------------------------------
plot_data <- plot_data %>% 
    # Do operations on a row basis              
    rowwise() %>% 
    # Select the species with the highest predicted probability as the classified species
    mutate(Predicted = colnames(.)[5 + which.max(c(setosa, versicolor, virginica))]) %>% 
    # Compare whether the selected species is same as the original
    mutate('Classification' = ifelse(Species == Predicted, 'Correct', 'Incorrect')) %>% 
    ungroup()

## ----prob-plot, warning = F, fig.align='center', fig.height = 5, fig.width=7, eval = execute----
ggplot(data=plot_data,
   aes(x=Sepal.Length, y=Sepal.Width))+
   # Pies-charts showing predicted probabilities of the different species
   # Using the pie-border to highlight if the same was classified correctly
   geom_pie_glyph(aes(linetype = Classification,  colour = Classification), 
                  slices = names(preds)) +
   # Colours for sectors of the pie-chart
   scale_fill_manual(values = c('#56B4E9', '#D55E00','#CC79A7'))+
   # Labels for axes and legend
   labs(y = 'Sepal Width', x = 'Sepal Length', fill = 'Prob (Species)')+
   # Adjusting the borders colours and linetypes 
   scale_linetype_manual(values = c(1, 3))+
   scale_colour_manual(values = c('black', 'white'))+
   # Theme of the plot
   theme_minimal()+
   theme(panel.grid = element_line(colour = 'darkgrey'),
         plot.background = element_rect(fill = 'grey', colour = NA))

