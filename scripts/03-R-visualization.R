## Code obtained from Data Carpentry Ecology Lesson
####  http://www.datacarpentry.org/R-ecology-lesson/04-visualization-ggplot2.html

# plotting package
library(tidyverse)

################## Load data ###################################################
surveys_complete <- read_csv('data/complete_surveys.csv')

## Plotting numerical data 
#Basic graph elements

# the simplest ggplot: data, aesthetic mappings, and geometry
ggplot(data = surveys_complete, 
       aes(x = weight, 
           y = hindfoot_length)) + 
  geom_point()

# Break it down into component parts

# Step 1: Initialize the plot
  #- specify data
  #- creates a blank plot

ggplot(data = surveys_complete)

# Step 2: specify variales on each axis
  #- specify the "aesthetic mappings"
  #- start with the aes function
  #-opens a plot window and draws axes

ggplot(data = surveys_complete, 
       mapping = aes(x = weight, 
                     y = hindfoot_length))

# Step 3: specify the geometry 
  #- use a geom function to specify how the data should be plotted
  # "add" aesthetics to the ggplot function with + operator
  # whitespace matters here 
  # adds data points to the plot

ggplot(data = surveys_complete, 
       mapping = aes(x = weight, 
                     y = hindfoot_length)) + 
  geom_point()

# Adding arguments to the geom to change appearance:

# Add transparency with the alpha argument to geom_pont
ggplot(surveys_complete, 
       aes(x = weight, 
           y = hindfoot_length)) +
       geom_point(alpha = 0.1)

# Add color with the color argument to geom_point
ggplot(surveys_complete, 
       aes(x = weight, 
           y = hindfoot_length)) +
       geom_point(alpha = 0.1, 
                  color = "blue")

# Add color by species with color argument to aes
ggplot(surveys_complete, 
       aes(x = weight, 
           y = hindfoot_length)) +
       geom_point(alpha = 0.1, 
                  aes(color=species_id))
#aes in geom_point specifies only for the point

# aes argument to ggplot specifies for the whole graph, 
ggplot(surveys_complete, 
       aes(x = weight,
           y = hindfoot_length,
           color=species_id)) +
       geom_point(alpha = 0.1)

################## Exercise 1 #################################################
#Use the previous example as a starting point.

#Add color to the data points according to the plot from which the sample was 
#taken (plot_id).

#Hint: Check the class for plot_id. Consider changing the class of plot_id from 
#integer to factor. Why does this change how R makes the graph?

#creates a color gradient because plot_id is a number, not character
ggplot(surveys_complete, 
       aes(x = weight,
           y = hindfoot_length,
           color=plot_id)) +
  geom_point(alpha = 0.1)

#you can tell ggplot to read it as a character rather than a number
# using as.character
ggplot(surveys_complete, 
       aes(x = weight,
           y = hindfoot_length,
           color=as.character(plot_id))) +
  geom_point(alpha = 0.1)
###############################################################################

## plotting categorical variables

ggplot(surveys_complete, 
       aes(x = species_id,         # factor variable
           y = hindfoot_length)) + # numeric variable
  geom_point()

# try a new geom: geom_jitter()
ggplot(surveys_complete, 
       aes(x = species_id,         # factor variable
           y = hindfoot_length)) + # numeric variable
  geom_jitter(alpha = 0.1)


# Make a boxplot 
ggplot(surveys_complete, 
       aes(x = species_id,         # factor variable
           y = hindfoot_length)) + # numeric variable
       geom_boxplot()

# Overlay points on a boxplot
ggplot(surveys_complete, 
       aes(x = species_id, 
           y = hindfoot_length)) +
       geom_boxplot() +
       geom_jitter(alpha = 0.1, 
                   color = "tomato")

#order is important
ggplot(surveys_complete, 
       aes(x = species_id, 
           y = hindfoot_length)) +
  geom_jitter(alpha = 0.1, 
              color = "tomato")+
  geom_boxplot() 

################### Exercise 2 ############################################
# Plot the same data as in the previous example, but as a Violin plot
# Hint: see geom_violin().

# What information does this give you about the data that a box plot does?

ggplot(data = surveys_complete, 
       aes(x = species_id, 
           y = hindfoot_length)) +
  geom_violin() 

###########################################################################

## Time series data 
#reshape the data
yearly_counts <- surveys_complete %>%
  count(year, species_id)


# Output: a data frame with year, species_id and n, where n is the number
#         of observations of a species in a given year

#Plot n vs. year
ggplot(data = yearly_counts, 
       aes(x = year, # year on the x axis
           y = n)) + # n on the y axis
       geom_line()
#Combines number of all species into one line

#One line for each species
ggplot(yearly_counts, 
       aes(x = year, 
           y = n, 
           group = species_id)) +  # make a new line for each species id
       geom_line()

# add color by species
ggplot(yearly_counts, 
       aes(x = year, 
           y = n,
           color = species_id)) + # add color to create legend
       geom_line()

# Save your plot to a variable
lineplot<- ggplot(data = yearly_counts, 
                  aes(x = year, 
                      y = n))+
  geom_line(aes(color = species_id))

lineplot

#################### Exercise 3 #########################################
#Use what you just learned to create a plot that depicts how the average 
#weight of each species changes through the years.

yearly_weights<-surveys_complete%>%
  group_by(species_id, year)%>%
  summarize(mean_wt = mean(weight))

mean_weight_sp<-ggplot(yearly_weights, 
                       aes(x = year, 
                           y = mean_wt))+ 
  geom_line(aes(color = species_id))

##########################################################################

# Making publication quality plots

##  Using pre-made themes 

#Apply a theme
lineplot_bw <- lineplot +
       theme_bw()          # see ?theme_bw for this and other themes

lineplot_bw
## Customizing themes 

#Change axis labels and titles
line_bw_lab<-lineplot_bw +
  labs(title = 'Species count over time',
       x = 'Year of observation',
       y = 'Count') 

line_bw_lab

#Change font size
line_bw_lab_font<-line_bw_lab + 
       theme(text=element_text(size=16, 
                               family="Arial"))

line_bw_lab_font

#If you get warnings here, you may need to use the extrafont 
#library to install fonts. (Win 10)

#From: https://www.r-bloggers.com/using-arial-in-r-figures-destined-for-plos-one/

#install.packages("extrafont")
#library(extrafont)

#font_import() #import your Windows system fonts into R
#fonts() #check what's installed

windowsFonts("Arial" = windowsFont("Arial"))
# Save a customized theme 
arial_theme <- theme_bw() + 
  theme(text=element_text(size=16, 
                          family="TT Arial"))

#Apply saved theme
box_arial<-ggplot(surveys_complete, 
                  aes(x = species_id, y = hindfoot_length)) +
  geom_boxplot() +
  arial_theme

box_arial

# Arrange plots

library(gridExtra)

grid.arrange(line_bw_lab_font, 
             box_arial,
             ncol = 2, 
             widths = c(4, 6))


# Save your plot 

ggsave( filename = "name.png",
        plot = line_bw_lab_font,        #last plot by default
        device = "png",                  #default
        units = "in",                    #default 
        width = 15, 
        height = 10)

# same as 
ggsave("name.png", 
       line_bw_lab_font, 
       width=15, 
       height=10)

#Bonus: Facets!

#Make a plot for each species_id
ggplot(data = yearly_counts,
       aes(x = year, y = n)) +
  geom_line() +
  facet_wrap(~species_id)

#add the sex variable to the table
yearly_sex_counts <- surveys_complete %>%
  count(year, species_id, sex)

#color by sex
ggplot(data = yearly_sex_counts, 
       mapping = aes(x = year, 
                     y = n, 
                     color = sex)) +
  geom_line() +
  facet_wrap(~ species_id)

# One column, facet by rows
yearly_sex_weight <- surveys_complete %>%
  group_by(year, sex, species_id) %>%
  summarize(avg_weight = mean(weight))


ggplot(data = yearly_sex_weight, 
       mapping = aes(x = year, 
                     y = avg_weight, 
                     color = species_id)) +
  geom_line() +
  facet_grid(sex ~ .)

#reverse orientation
ggplot(data = yearly_sex_weight, 
       mapping = aes(x = year, 
                     y = avg_weight, 
                     color = species_id)) +
  geom_line() +
  facet_grid(. ~ sex)

#use both facets
ggplot(data = yearly_sex_weight,
       aes(x = year, y = avg_weight)) +
  geom_line() +
  facet_grid(sex~species_id)

# Faceting exercise
#Using facets and themes, create a plot that depicts 
#how the average weight of each species changes through 
#the years.

