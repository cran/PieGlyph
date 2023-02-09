## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- eval = TRUE, echo = F---------------------------------------------------
execute <- T
if(!all(c('maps', 'mapproj') %in% installed.packages())){
  execute <- F
  print("This vignetted requires the `maps` and `mapproj` packages to be installed for execution.")
}

## ----setup, warning=F, message=F, eval = execute------------------------------
library(PieGlyph)
library(ggplot2)
library(dplyr)

## ----create-boundaries, eval = execute----------------------------------------
states_boundaries <- map_data("state")

## ----boundaries, eval = execute-----------------------------------------------
head(states_boundaries)

## ----create-votes, eval = execute---------------------------------------------
set.seed(123)

# Get names of state names from map data
votes_data <- data.frame('State' = tolower(state.name))

# Simulate percentage of votes received in each state by the Democratic, Republic and other parties
votes_data <- votes_data %>% 
                mutate('Democratic' = round(runif(50, 1, 100)),
                       'Republic' = round(runif(50, 1, (100 - Democratic))),
                       'Other' = 100 - Democratic - Republic)

# Add the latitude and longitude of the geographical centers of the states to place the pies 
votes_data <- votes_data %>% 
                mutate('pie_lat' = state.center$y,
                       'pie_long' = state.center$x)

# Filter out any states that weren't present in the map_data
votes_data <- votes_data %>% filter(State %in% unique(states_boundaries$region))

## ----votes_data, eval = execute-----------------------------------------------
head(votes_data)

## ----map, warning = F, fig.align='center', fig.width=7, eval = execute--------
map <- ggplot(states_boundaries, aes(x = long, y = lat)) +
        # Add states and their borders
        geom_polygon(aes(group = group),
                     fill = 'darkseagreen', colour = 'black')+
        # Axis titles
        labs(x = 'Longitude', y ='Latitude')+
        # Blue background for the sea behind
        theme(panel.background = element_rect(fill = 'lightsteelblue2'))+
        # Coordinate system for maps
        coord_map()
map

## ----glyph-merc, warning = F, fig.align='center', fig.width=7, warning = F, eval = execute----
plot <- map + 
  # Add pie-charts for each state
  geom_pie_glyph(aes(y = pie_lat, x = pie_long),
                 data = votes_data, colour = 'black',
                 slices = c('Democratic','Republic','Other'))+
  # Colours of the pie sectors
  scale_fill_manual(values = c('#047db7','#c52d25', 'grey'), name = 'Party')+
  # Place legend on top of the plot
  theme(legend.position = 'top')
plot

## ----glyph-albers, warning = F, fig.align='center', fig.width=7, warning = F, message = F, eval = execute----
plot +
  # Different map projection
  coord_map('albers', lat0 = 45.5, lat1 = 29.5)

## ----glyph-gnomonic, warning = F, fig.align='center', fig.width=7, warning = F, message = F, eval = execute----
plot +
  # Different map projection
  coord_map('gnomonic')

