## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, message =F, warning = F, fig.align='center', fig.width=7----------
library(PieGlyph)
library(ggplot2)
library(forcats)
library(dplyr)
library(tidyr)

## ----data---------------------------------------------------------------------
model_data <- data.frame('ID' = paste0('P', 1:20),
                         'A' = c(90, 60, 30, 75, 85, 
                                 30, 50, 70, 65, 65, 
                                 40, 115, 165, 40, 175, 
                                 200, 185, 250, 190, 175),
                         'B' = c(170, 180, 130, 325, 180,
                                 220, 335, 285, 85, 125,
                                 250, 190, 60, 205, 125, 
                                 90, 95, 25, 60, 20),
                         'C' = c(60, 35, 95, 50, 15, 
                                 190, 15, 80, 310, 280, 
                                 185, 115, 220, 190, 155, 
                                 135, 180, 120, 100, 140),
                         'D' = c(180, 225, 245, 50, 220, 
                                 60, 100, 65, 40, 30, 
                                 25, 80, 55, 65, 45,
                                 75, 30, 105, 150, 165),
                         'Disease' = factor(c(rep(c('Yes'), 10),
                                              rep(c('No'), 10))))

## ----data-subset, warn = F, fig.align='center', fig.width=7-------------------
head(model_data)

## ----model, warning = F, fig.align='center', fig.width=7----------------------
m1 <- glm(Disease ~ 0 + A + B + C + D,
          data = model_data,
          family = binomial(link = 'logit'))

## ----summary, warning = F, fig.align='center', fig.width=7--------------------
summary(m1)

## ----predictions, warning = F, fig.align='center', fig.width=7----------------
plot_data <- model_data %>%
  # Add predictions
  mutate('prediction' = predict(m1, type = 'response')) %>%
  # Sort in descending order of prediction
  arrange(desc(prediction)) %>% 
  # Relevel ID for plotting in descending order
  mutate(ID = fct_inorder(ID)) %>% 
  # Stack the four markers in one column
  pivot_longer(cols = c('A', 'B', 'C','D'), names_to = 'Marker',
               values_to = 'Proportion')

head(plot_data, 8)

## ----barplot, warn = F, fig.align='center', fig.width=7-----------------------
# Filtering the data as each prediction is replicated 4 times, once for each marker 
ggplot(data = filter(plot_data, Marker == 'A'))+
  geom_col(aes(x = ID, y = prediction))+
  # Add axis titles
  labs(y = 'Prob(Having Disease)', x = 'Patient')+
  theme_minimal()

## ----lollipop, warn = F, fig.align='center', fig.width=7----------------------
ggplot(data = plot_data, aes(x = ID, y = prediction, fill = Marker))+
  # Vertical line of lollipop
  geom_segment(aes(yend = 0, xend = ID))+
  # Pies-charts at the centre of the lollipop
  geom_pie_glyph(slices = 'Marker', values = 'Proportion',
                 radius = 0.3, colour = 'black')+
  # Axis titles
  labs(y = 'Prob(Having Disease)', x = 'Patient')+
  # Colours for sectors of the pie-chart
  scale_fill_manual(values = c('#56B4E9','#F0E442',
                               '#D55E00','#CC79A7'))+
  theme_minimal()

