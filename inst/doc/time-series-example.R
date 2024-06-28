## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, warning=F, message=F----------------------------------------------
library(PieGlyph)
library(ggplot2)

## ----simulate-data------------------------------------------------------------
Seatbelts <- data.frame(Seatbelts, time = time(Seatbelts))
head(Seatbelts)

## ----show-data----------------------------------------------------------------
plot_data <- Seatbelts[133:192, ]
head(plot_data)

## ----scatterpie, fig.align='center', fig.width=7, eval = F--------------------
#  p <- ggplot(plot_data, aes(x = time, y = kms))+
#          geom_line(linewidth = 1)+
#          geom_scatterpie(aes(x = time, y = kms),
#                          colour = 'black',
#                          data = plot_data,
#                          cols = c('drivers','front', 'rear'))+
#          theme_minimal()

## ----scatterpie-figure, fig.align='center', out.width = '95%', eval = T, echo = F----
knitr::include_graphics("../man/figures/scatterpie-1.png")

## ----scatterpie-fixed, fig.align='center', fig.width=7, eval = F--------------
#  p + coord_fixed()

## ----scatterpie-fixed-figure, fig.align='center', out.width = '95%', eval = T, echo = F----
knitr::include_graphics("../man/figures/scatterpie-fixed-1.png")

## ----Pie-glyph-plot, fig.align='center', fig.width = 7, fig.height=5, warning = F----
pl <- ggplot(plot_data, aes(x = time, y = kms))+
        # Add the lines joining the pie-charts
        geom_line(linewidth = 1)+
        # Add pie-chart showing proportion of people injured
        geom_pie_glyph(colour = 'black',
                       slices = c('drivers', 'front', 'rear'))+
        # Change theme of plot
        theme_minimal()
pl    

## ----pie-borders, fig.align='center', fig.width=7, fig.height=5, warning = F----
pl <- ggplot(plot_data, aes(x = time, y = kms))+
        # Add the lines joining the pie-charts
        geom_line(linewidth = 1)+
        # Add pie-chart showing proportion of people injured
        # Also map the pie-borders to show whether seatbelt law was present
        geom_pie_glyph(aes(linetype = as.factor(law)),
                       colour = 'black',
                       slices = c('drivers', 'front', 'rear'))+
        # Adjust the style of borders
        scale_linetype_manual(values = c(0, 1),
                              labels = c('No', 'Yes'))+
        # Plot theme
        theme_minimal()
pl    


## ----aesthetics, fig.align='center', fig.width=7, fig.height=5, warning = F----
pl + 
  # Colours of the pie-sectors
  scale_fill_manual(values = c('#56B4E9','#F0E442','#CC79A7'))+
  # Axis and legend titles
  labs(x = 'Year', y = 'Km driven',
       fill = 'People Injured', linetype = 'Law in Effect?')

