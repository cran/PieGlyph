## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup, warning = FALSE, message = FALSE----------------------------------
library(PieGlyph)
library(ggplot2)
library(ggiraph)
library(dplyr)
library(cowplot)

## -----------------------------------------------------------------------------
set.seed(737)
plot_data <- data.frame(response = rnorm(15, 100, 30),
                        system = 1:15,
                        group = sample(size = 15, x = c('G1', 'G2', 'G3'), replace = T),
                        A = round(runif(15, 3, 9), 2),
                        B = round(runif(15, 1, 5), 2),
                        C = round(runif(15, 3, 7), 2),
                        D = round(runif(15, 1, 9), 2))

## ----data_subset--------------------------------------------------------------
head(plot_data)

## ----basic_plot, fig.align='center', fig.width=6, fig.height=5----------------
# Same ggplot call as the static version
gg_obj <- ggplot(data = plot_data, aes(x = system, y = response)) + 
  # geom_pie_interactive instead of geom_pie_glyph
  geom_pie_interactive(slices = c("A", "B", "C", "D"),
                       colour = "black") +
  scale_fill_brewer(palette = "Dark2") + 
  theme_classic(base_size = 16)
  
# Pass the ggplot object to the girafe function to create the interactive plot
girafe(ggobj = gg_obj)

## ----custom_tooltip, fig.align='center', fig.width=6, fig.height=5------------
gg_obj <- ggplot(data = plot_data, aes(x = system, y = response)) + 
  # specify tooltip aesthetic
  # wrapped in paste0 to add more descriptive text to the tooltip
  geom_pie_interactive(aes(tooltip = paste0("Group: ", group)),
                       slices = c("A", "B", "C", "D"),
                       colour = "black") +
  scale_fill_brewer(palette = "Dark2") + 
  theme_classic(base_size = 16)
  
# Pass the ggplot object to the girafe function to create the interactive plot
girafe(ggobj = gg_obj)

## ----onclick, fig.align='center', fig.width=6, fig.height=5-------------------
gg_obj <- ggplot(data = plot_data, aes(x = system, y = response)) + 
  # specify onclick aesthetic
  geom_pie_interactive(aes(
                       onclick = "alert(\"This observation belongs to group \" + 
                                  this.getAttribute(\"data-id\"))"),
                       slices = c("A", "B", "C", "D"),
                       colour = "black") +
  scale_fill_brewer(palette = "Dark2") + 
  theme_classic(base_size = 16)

# Pass the ggplot object to the girafe function to create the interactive plot
girafe(ggobj = gg_obj)

## ----data_id, fig.align='center', fig.width=6, fig.height=5-------------------
gg_obj <- ggplot(data = plot_data, aes(x = system, y = response)) + 
  # specify data_id aesthetic
  geom_pie_interactive(aes(data_id = group),
                       slices = c("A", "B", "C", "D"),
                       colour = "black") +
  scale_fill_brewer(palette = "Dark2") + 
  theme_classic(base_size = 16)
  
# Pass the ggplot object to the girafe function to create the interactive plot
girafe(ggobj = gg_obj)

## ----customisation, fig.align='center', fig.width=6, fig.height=5-------------
# Reuse the previous gg_obj
girafe(ggobj = gg_obj,
       options = list(
         # Options for formatting the appearance of the tooltip
         # The tooltip will have a blue background with white text
         opts_tooltip = opts_tooltip(css = "background-color:blue;color:white;padding:5px"),
         # Options for changing animation of observations which are hovered
         # Hovered pie-glyph will be highlighted yellow with dark grey border
         opts_hover(css = "fill:yellow;stroke:darkgrey;"),
         # Options for changing properties of the pie-glyphs not selected
         # Make non-selected pie-glyphs fade into background
         opts_hover_inv(css = "opacity:0.25;"),
         # Options for panning and zooming
         # Set max to a number greater than 1 and tooltip will appear on 
         # top right giving options for panning and zooming across the plot
         opts_zoom(max = 3)
       ))

## ----single-selection, fig.align='center', fig.width=6, fig.height=5----------
# Add a unique identifier for each observertion
plot_data$id <- 1:nrow(plot_data)

gg_obj <- ggplot(data = plot_data, aes(x = system, y = response)) + 
  # specify data_id as a unique identifier for each observation
  geom_pie_interactive(aes(data_id = id),
                       slices = c("A", "B", "C", "D"),
                       colour = "black") +
  scale_fill_brewer(palette = "Dark2") + 
  theme_classic(base_size = 16)

girafe(ggobj = gg_obj,
       options = list(
         # Options for selecting observations
         # only_shiny = FALSE is needed to see selections in page
         opts_selection(type = "multiple", 
                        only_shiny = FALSE),
         # Panning and zooming
         opts_zoom(max = 3)
       ))

## ----multi-selection, fig.align='center', fig.width=9, fig.height=5-----------
# Lets first add two more variables to our data
set.seed(373)
plot_data <- plot_data %>% 
  mutate(response2 = round(rnorm(15, 100, 30), 2),
         system2 = round(runif(15, 5, 20), 2))

gg_obj1 <- ggplot(data = plot_data, aes(x = system, y = response)) + 
  # specify data_id as a unique identifier for each observation
  geom_pie_interactive(aes(data_id = id),
                       slices = c("A", "B", "C", "D"),
                       colour = "black") +
  scale_fill_brewer(palette = "Dark2") + 
  theme_classic(base_size = 16) +
  theme(legend.position = "top")


gg_obj2 <- ggplot(data = plot_data, aes(x = system2, y = response2)) + 
  # specify data_id as a unique identifier for each observation
  geom_pie_interactive(aes(data_id = id),
                       slices = c("A", "B", "C", "D"),
                       colour = "black") +
  scale_fill_brewer(palette = "Dark2") + 
  labs(x = "Another system", y = "Another response") +
  theme_classic(base_size = 16) +
  theme(legend.position = "top")

girafe(ggobj = cowplot::plot_grid(gg_obj1, gg_obj2, 
                                  nrow = 1),
       options = list(
         # Options for selecting observations
         # only_shiny = FALSE is needed to see selections in page
         opts_selection(type = "multiple", 
                        only_shiny = FALSE)
       ))

## ----interactive-geoms, fig.align='center', fig.width=8, fig.height=5---------
gg_obj <- ggplot(data = plot_data, aes(x = system, y = response)) + 
  # Simple theme for plot
  theme_classic(base_size = 16) +
  # Title for plot
  labs(title = "This is a plot with each component being interactive") +
  # Interactive pie-glyphs
  geom_pie_interactive(aes(data_id = id),
                       slices = c("A", "B", "C", "D"),
                       colour = "black") +
  # Interactive version of facet_wrap.
  # Use labeller_interactive for the interactive strips
  facet_wrap_interactive(vars(group), nrow = 1,
                         labeller = labeller_interactive(
                           aes(tooltip = paste0("Group: ", group), 
                               data_id = group)
                           )
                         ) + 
  # Interactive version of scale_fill_manual
  # Specify he tooltip and data_id attributes for the legend keys
  # Use labeller_interactive for making legend title interactive
  scale_fill_manual_interactive(values = c("#1B9E77", "#D95F02",
                                           "#7570B3", "#E7298A"),
                                name = label_interactive(
                                  "Attributes", 
                                  tooltip = "Interactive legend title", 
                                  data_id =   "legend.title",
                                  onclick = "alert(\"You clicked the legend title.\")"
                                  ),
                                tooltip = function(x) paste0("Attribute: ", x),
                                data_id = function(x) x) + 
  # Interactive elements in the theme
  # Use element_text_interactive for the axis title, axis text and plot title
  theme(legend.position = "top",
        axis.title = element_text_interactive(
          data_id = "axis.title",
          tooltip = "Axis title",
          onclick = "alert(\"You clicked the axis title.\")",
          hover_css = "fill:red;stroke:none;"
        ),
        axis.text = element_text_interactive(
          data_id = "axis.text",
          tooltip = "Axis text",
          onclick = "alert(\"You clicked the axis text\")",
          hover_css = "fill:red;stroke:none;"
        ),
        plot.title = element_text_interactive(
          data_id = "plot.title",
          tooltip = "Plot title",
          onclick = "alert(\"You clicked the plot title\")",
          hover_css = "fill:blue;stroke:black;"
        )) 

girafe(ggobj = gg_obj)

