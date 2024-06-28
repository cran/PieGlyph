## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----libs, warning=F, message=F-----------------------------------------------
library(dplyr)
library(tidyr)
library(ggplot2)
library(PieGlyph)
library(ggiraph)

## ----data---------------------------------------------------------------------
set.seed(123)
plot_data <- data.frame(response = rnorm(30, 100, 30),
                        system = 1:30,
                        group = sample(size = 30, x = c('G1', 'G2', 'G3'), replace = T),
                        A = round(runif(30, 3, 9), 2),
                        B = round(runif(30, 1, 5), 2),
                        C = round(runif(30, 3, 7), 2),
                        D = round(runif(30, 1, 9), 2))

## ----data_subset--------------------------------------------------------------
head(plot_data)

## ----basic, fig.align='center', fig.width=6, fig.height = 5-------------------
ggplot(data = plot_data, aes(x = system, y = response))+
  geom_pie_glyph(slices = c('A', 'B', 'C', 'D'))+
  theme_classic()

## ----border, fig.align='center', fig.width=6, fig.height = 5------------------
ggplot(data = plot_data, aes(x = system, y = response))+
  # Can also specify slices as column indices
  geom_pie_glyph(slices = 4:7, colour = 'black', radius = 0.5)+ 
  theme_classic()

## ----map, fig.align='center', fig.width=6, fig.height = 5---------------------
p <- ggplot(data = plot_data, aes(x = system, y = response))+
        geom_pie_glyph(aes(radius = group), 
                       slices = c('A', 'B', 'C', 'D'), 
                       colour = 'black')+
        theme_classic()
p

## ----radius, fig.align='center', fig.width=6, fig.height = 5------------------
p <- p + scale_radius_manual(values = c(0.25, 0.5, 0.75), unit = 'cm')
p

## ----labels, fig.align='center', fig.width=6, fig.height = 5------------------
p <- p + labs(x = 'System', y = 'Response', fill = 'Attributes', radius = 'Group')
p

## ----colours, fig.align='center', fig.width=6, fig.height = 5-----------------
p + scale_fill_manual(values = c('#56B4E9', '#CC79A7', '#F0E442', '#D55E00'))

## ----data_stacking------------------------------------------------------------
plot_data_stacked <- plot_data %>%
  pivot_longer(cols = c('A','B','C','D'), 
               names_to = 'Attributes', 
               values_to = 'values')
head(plot_data_stacked, 8)

## ----stacked, fig.align='center', fig.width=6, fig.height = 5-----------------
ggplot(data = plot_data_stacked, aes(x = system, y = response))+
  # Along with slices column, values column is also needed now
  geom_pie_glyph(slices = 'Attributes', values = 'values')+
  theme_classic()

## ----interactive, fig.align='center', fig.width=6, fig.height = 5-------------
plot_obj <- ggplot(data = plot_data)+
              geom_pie_interactive(aes(x = system, y = response,
                                       data_id = system),
                                   slices = c("A", "B", "C", "D"), 
                                   colour = "black")+
              theme_classic()

girafe(ggobj = plot_obj, height_svg = 5, width_svg = 6)

