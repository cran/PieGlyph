## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, warning = F, message=F--------------------------------------------
library(PieGlyph)
library(ggplot2)
library(dplyr)
library(tidyr)

## -----------------------------------------------------------------------------
plot_data <- data.frame(x = 1:4, 
                        y = c(3,1,4,2),
                        A = c(5, 2, NA, 3),
                        B = c(NA, 2, 3, NA),
                        C = c(7, NA, NA, 3))
plot_data

## ----fig.align='center', fig.width=7------------------------------------------
ggplot()+
  geom_pie_glyph(aes(x = x, y = y),
                 slices = c('A','B','C'),
                 data = plot_data,
                 radius = 1)+
  theme_minimal()+
  xlim(0.5,4.5)+
  ylim(0.5,4.5)

## -----------------------------------------------------------------------------
plot_data <- data.frame(x = 1:4, 
                        y = c(3,1,4,2),
                        A = c(5, 2, NA, 1),
                        B = c(2, 2, NA, 5),
                        C = c(7, 3, NA, 3))
head(plot_data)

## ----fig.align='center', fig.width=7------------------------------------------
ggplot(data = plot_data)+
  geom_pie_glyph(aes(x = x, y = y),
                 slices = c('A','B','C'),
                 radius = 1)+
  theme_minimal()+
  xlim(0.5,4.5)+
  ylim(0.5,4.5)

## -----------------------------------------------------------------------------
plot_data <- data.frame(x = 1:4, 
                        y = c(3,1,4,2),
                        A = c(5, 2, 0, 1),
                        B = c(2, 2, 0, 5),
                        C = c(7, 3, 0, 3))
head(plot_data)

## ----fig.align='center', fig.width=7------------------------------------------
ggplot(data = plot_data)+
  geom_pie_glyph(aes(x = x, y = y),
                 slices = c('A','B','C'),
                 radius = 1)+
  theme_minimal()+
  xlim(0.5,4.5)+
  ylim(0.5,4.5)

## -----------------------------------------------------------------------------
plot_data <- data.frame(x = 1:4, 
                        y = c(3,1,4,2),
                        A = c(5, -2, 3, 3),
                        B = c(2, 2, 0, 0),
                        C = c(-7, 1, 3, -3))
plot_data

## ----warning = F, error = T, fig.align='center', fig.width=7------------------
ggplot()+
  geom_pie_glyph(aes(x = x, y = y),
                 slices = c('A','B','C'),
                 data = plot_data)

## -----------------------------------------------------------------------------
dummy_data <- data.frame(system = rep(paste0('S', 1:3), each = 3),
                         x = c(1,1,1,1,1,1,2,2,2),
                         y = c(2,2,2,2,2,2,4,4,4),
                         attribute = rep(c('A','B','C'), times = 3),
                         value = c(30,20,10, 20,50,50, 10,10,10))
dummy_data

## ----fig.align='center', fig.width=7------------------------------------------
ggplot(data = dummy_data[4:9,])+
  geom_pie_glyph(aes(x = x, y = y),
                 slices = 'attribute', values = 'value',
                 radius = 1)+
  theme_minimal()+
  xlim(0.5, 2.5)+
  ylim(1.5, 4.5)+
  labs(title = 'Expected Plot')


## ----warning = F, fig.align='center', fig.width=7-----------------------------
ggplot(data = dummy_data)+
  geom_pie_glyph(aes(x = x, y = y),
                 slices = 'attribute', values = 'value',
                 radius = 1)+
  theme_minimal()+
  xlim(0.5, 2.5)+
  ylim(1.5, 4.5)+
  labs(title = 'Generated Plot')

## ----fig.align='center', fig.width=7------------------------------------------
ggplot(data = dummy_data)+
  geom_pie_glyph(aes(x = x, y = y),
                 slices = 'attribute', values = 'value',
                 radius = 1)+
  xlim(0.5, 2.5)+
  ylim(1.5, 4.5)+
  theme_minimal()

## ----fig.align='center', fig.width=7------------------------------------------
ggplot(data = dummy_data)+
  geom_pie_glyph(aes(x = x, y = y, pie_group = system),
                 slices = 'attribute', values = 'value',
                 radius = 1)+
  xlim(0.5, 2.5)+
  ylim(1.5, 4.5)+
  theme_minimal()

## ----fig.align='center', fig.width=7------------------------------------------
dummy_data_wide <- dummy_data %>% 
  pivot_wider(names_from = 'attribute', values_from = 'value')

head(dummy_data_wide)

ggplot(data = dummy_data_wide)+
  geom_pie_glyph(aes(x = x, y = y),
                 slices = c('A','B','C'),
                 radius = 1)+
  xlim(0.5, 2.5)+
  ylim(1.5, 4.5)+
  theme_minimal()

## ----fig.align='center', fig.width=7------------------------------------------
ggplot(data = dummy_data_wide)+
  geom_pie_glyph(aes(x = x, y = y),
                 slices = c('A','B','C'),
                 radius = 1, 
                 position = position_jitter(seed = 333))+
  ylim(1.4, 5)+
  xlim(0.6, 2.2)+
  theme_minimal()

