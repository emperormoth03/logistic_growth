#Question 1 
#Plotting growth against time with linear and log scale

growth_data <- read.csv("experiment.csv")  #Load data, assign new data frame to not override original data
#install.packages("ggplot2")  #Install and load relevant packages
#install.packages("gridExtra")
library(ggplot2)
library(gridExtra)

plot1 = ggplot(aes(t,N), data = growth_data) +  #Plot logistic growth curve with linear scale 
  geom_point() +
  geom_line(color = "red", size = 1) +  #Set colour to red for extra differentiation 
  xlab("t") +
  ylab("N") +
  theme_bw()
  
plot2 = ggplot(aes(t,N), data = growth_data) +  #Plot logistic growth curve with log scale 
  geom_point() +
  geom_line(color = "blue", size = 1) +
  xlab("t") +
  ylab("N") +
  scale_y_continuous(trans='log10')

grid.arrange(plot1, plot2)

#Save the plot with a fixed size to ensure reproducibility 
ggsave("growth_comparison_plot.png", plot = growth_comparison_plot, width = 8, height = 6, dpi = 600)




#Question 2 
#Code to calculate population size under logistic and exponential growth

#Population parameters
T = 4980
N0 = 879
r = 0.01
K = 6e+10

#Logistic Growth Function 
##  N <- (N0*K*exp(r*t))/(K-N0+N0*exp(r*t)) ##

N_logistic <- (879*6.000e+10*exp(0.01*4980))/(6.000e+10 - 879 + 879*exp(0.01*4980))
N_logistic

#Exponential Growth Function 
## N <- N0*exp(r*t) ##

N_exponential <- 879*exp(0.01*4980)
N_exponential


comparison_table <- data.frame(
  Model = c("Logistic Growth", "Exponential Growth"),
  Population_Size = c(N_logistic, N_exponential))
comparison_table





#Question 3
#Generate a plot comparing exponential and logistic growth

growth_data <- read.csv("experiment.csv")  

#install.packages("ggplot2")
library(ggplot2)

# Parameters from analysis
N0 <- 879       # Initial population size
r <- 0.01       # Growth rate
K <- 6e+10      # Carrying capacity

# Define logistic growth function
logistic_fun <- function(t) {
  N <- (N0*K*exp(r*t))/(K - N0 + N0*exp(r*t))
  return(N)
}

# Define exponential growth function
exponential_fun <- function(t) {
  N <- N0*exp(r*t)
  return(N)
}

#Creating the plot to compare logistic and exponential functions
comparison_plot <- ggplot(aes(x = t, y = N), data = growth_data) +
  geom_function(aes(color = "Logistic Growth"), fun = logistic_fun, linetype = "solid", linewidth = 1.5) +  #Logistic growth curve
  geom_function(aes(color = "Exponential Growth"), fun = exponential_fun, linetype = "dashed", linewidth = 1.5) +  #Exponential growth curve
  scale_y_log10() +
  scale_color_manual(
    name = "Growth Models",  #Legend title
    values = c("Logistic Growth" = "red", "Exponential Growth" = "blue")) +  #Red and blue is a colour blind friendly combination, dashed and solid line help to differentitate curves further
  xlab("Time (minutes)") +
  ylab("Population size (N)") +
  ggtitle("Comparison of Exponential and Logistic Growth") +
  theme_bw() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 20, face = "bold"),
    axis.title = element_text(size = 18),  #Increase axis label size
    axis.text = element_text(size = 15),   #Increase axis tick label size
    legend.title = element_text(size = 18),
    legend.text = element_text(size = 15),
    legend.position = "bottom")  #Position the legend below the plot

comparison_plot


#Save the plot with a fixed size to ensure reproducibility 
ggsave("comparison_plot.png", plot = comparison_plot, width = 8, height = 6, dpi = 300)
