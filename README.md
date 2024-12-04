## Question 1.

This analysis aims to use reproducible methods to model the growth of an _Eschericia. coli_ population based on data acquired experimentally. We start off with a test tube containing 900$`\mu`$l of growth medium and 100$`\mu`$l of _E. coli_ isolate suspended in the same medium. The model will be used to estimate the population parameters of the growth equation so that the number of bacteria in the tube at any given time can be estimate. The required parameters are as follows:

**Starting Population Size ($`N_0`$)** - the number of bacteria in the tube when t=0

**Growth Rate ($`r`$)** - The rate at which the bacteria population will grow under optimal conditions in log phase

**Carrying Capacity ($`K`$)** - The maximum bacteria population size that can be maintained in the test tube due to limited resources

The data file is called 'experiment.csv' and was acquired from the Open Science Framework (https://osf.io/). The data contains information on the number of bacteria in the tube at intervals of 60 minutes, we can use this data to create a logistic growth model, which has an exponential phase of bacterial growth, followed by a plateau where the growth rate slows down as the population size approaches $`K`$. 

**Methods:**

N and t were plotted against each other with both linear and logarithmic scales of N to visualise the data, the log transformed plot helps to indicate the exponential phase, forming a straight line that can be used to calculate the growth rate $`r`$. 

```r
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
```

![growth_comparison_plot](https://github.com/user-attachments/assets/67dc87e4-240f-4d4c-b129-91c52fc916b5)

>**Fig. 1** Comparison of logistic growth with linear scale (top) and log scale (bottom), the duration of the exponential phase is more apparent with the log scale plot.

Finding $`r`$ and $`N_0`$:

We can see from the plot (Fig. 1) that at t=1500 the population is still in its exponential phase, increasing at a constant exponential rate, so we can use the gradient of the curve before this time to estimate the exponential growth rate $`r`$.

```r
data_subset1 <- growth_data %>% filter(t<1500) %>% mutate(N_log = log(N))
model1 <- lm(N_log ~ t, data_subset1)
summary(model1)
```

![image](https://github.com/user-attachments/assets/8eb42aff-c56d-49a9-adad-4dc8f1c344bb)

Using the summary function for this model provides an estimate for t at 0.01, which represents the growth rate. 

We can also calculate an estimate for $`N_0`$ by doing e to the power of the intercept estimate, $`e`$^6.894 = 986.3. This is necessary as it is the reverse of the ln transformation to make the log plot. We can see that the value is close to the value of N where t = 0 in the data frame (879).

Finding $`K`$:

The population stabilises (the stationary phase) after around t = 2000, so we can use the values of N over the time after this point to calculate the carrying capacity for the population.

```r
data_subset2 <- growth_data %>% filter(t>3000)
model2 <- lm(N ~ 1, data_subset2)
summary(model2)
```

![image](https://github.com/user-attachments/assets/a7b30f56-b357-4618-894e-746a636756ea)

We fit a constant linear model as we assume that the carrying capacity will remain stable, we are only interested in the intercept of the N variable which will give us the carrying capacity. 

Summarising this model gives an intercept estimate of 6e+10, which is K.

Estimates:

**$`N_0`$** = 879

**$`r`$** = 0.01

**$`K`$** = 6e+10

## Question 2.

#Full code can be found in the 'assignment_questions_code.R' file, click [HERE](https://github.com/emperormoth03/logistic_growth/blob/f8b02a03b1a78085666886507922675082c2c4f3/assignment_questions_code.R)

We can see how much the population size would differ under exponential growth by using our estimates for $`N_0`$ and $`r`$ in an exponential growth equation. 

T = 4980

$`N_0`$ = 879

$`r`$ = 0.01

Calculating the population size at t = 4980 assuming exponential growth:

```math
N(t) = N_0 e^{rt}
```
```r
879*exp(0.01*4980)
```
N = 3.73e+24

Calculating the population size at t = 4980 assuming logistic growth growth:

$`K`$ = 6e+10

```math
N(t) = \frac{K N_0 e^{rt}}{K-N_0+N_0 e^{rt}}
```
```r
(879*6.000e+10*exp(0.01*4980))/(6.000e+10-879+879*exp(0.01*4980))
```
N = 6e+10

Under logistic growth, at t = 4980, the bacteria population has reached its stationary phase, and is at its carrying capacity. 

![image](https://github.com/user-attachments/assets/8b6b7e08-0c90-4618-a569-e71b36451956)

We can see there is a considerable increase in population size at t = 4980 under exponential growth compared to the logistic model. If the population is not constrained by a carrying capacity, it will continue to grow exponentially. Biologically, there will always be a carrying capacity that limits population growth after a certain point, when available resources become depleted and waste products begin to accumulate. For example, if the population is aerobic, the oxygen levels may be brought down to level where exponential growth can no longer take place, the death rate will be equal to the division rate. Eventually, we would expect to see a decline phase, when waste products reach toxic levels the death rate exceeds the cell division rate, the population will begin to decline exponentially. This might have occurred if the experiment took place over several more days. Larger bacterial population sizes may also face greater intra and interspecific competition for resources, further limiting growth. Overall, there are many abiotic and biotic factors involved in constraining the potential population growth of bacterial populations, but it is interesting to consider just how fast bacteria can multiply under optimal conditions. We can utilise bacteria's growth potential for a range of applications, fermentation tanks can be set up to produce a range of products from medicines, hormones such as insulin, and food products. 

## Question 3.

#Full code can be found in the 'assignment_questions_code.R' file, click [HERE](https://github.com/emperormoth03/logistic_growth/blob/f8b02a03b1a78085666886507922675082c2c4f3/assignment_questions_code.R)

We can plot the logistic and exponential function together to see how they compare (Fig. 1). Initially, both curves increase at the same rate, the exponential phase where bacterial growth is unconstrained. However, as the logistic growth curve approaches K, it levels off, reaching a stable stationary phase at 6e+10. The exponential function continues to grow at a constant rate, as it isn't constrained by a carrying capacity that would otherwise limit expansion. 

![comparison_plot](https://github.com/user-attachments/assets/7154b376-735e-4a6b-94f3-bfcee3737f79)

>**Fig. 2 Comparison of Logistic and Exponential Growth**
