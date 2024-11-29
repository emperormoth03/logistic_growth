Reproducible analysis of logistic growth


Question 1:
This analysis aims to model the population growth of E. coli based on data acquired experimentally, the model will be used to estimate a range of population parameters:

**Starting Population Size (N0)** - the number of bacteria in the tube when t=0

**Growth Rate (r)** - The rate at which the bacteria population will grow under optimal conditions in log phase

**Carrying Capacity (K)** - The maximum bacteria population size that can be maintained in the test tube due to limited resources

The data file is called 'experiment.csv' and was acquired from the Open Science Framework (https://osf.io/) contains information on the number of bacteria in the tube at intervals of 60 seconds, we can use this data to create a logistic growth model, which has an exponential phase of bacterial growth, and a lag phase where the growth rate slows down as the population size approaches K.

Methods:
N and t were plotted against each other with both linear and logarithmic scales for N to visualise the data, the log transformed plot helps to indicate the exponential phase, forming a straight line that can be used to calculate the growth rate 'r'

R and N0:
We can see from the plot that t=1000 the population is still in its exponential phase, so we can use the line to estimate the exponential growth rate 'r'

data_subset1 <- growth_data %>% filter(t<1000) %>% mutate(N_log = log(N))
model1 <- lm(N_log ~ t, data_subset1)
summary(model1)

![image](https://github.com/user-attachments/assets/8eb42aff-c56d-49a9-adad-4dc8f1c344bb)

Summarising this model provides an estimate for t at 0.01, which represents a growth rate

We can also calculate an estimate for N0 by doing e to the power of the intercept estimate, e^6.894 = 986.3. This value is close to the value of N where t = 0 in the data frame (879)

K:
We can see that the population stabilises (the stationary phase) after around t = 2000, so we can use a time after this to calculate the carrying capacity for the population

data_subset2 <- growth_data %>% filter(t>3000)
model2 <- lm(N ~ 1, data_subset2)
summary(model2)

![image](https://github.com/user-attachments/assets/a7b30f56-b357-4618-894e-746a636756ea)

We fit a constant linear model as we assume that the carrying capacity will remain stable, we are only interested in the intercept of the N variable which will give us the carrying capacity. 

Summarising this model gives an intercept estimate of 6e+10, which is K

Estimates:

**N0** = 879

**R** = 0.01

**K** = 6e+10

#################################################################################

Question 2:

#FULL CODE CAN BE FOUND IN THE 'assignment_questions_code.R' file

We can compare the growth of the population under exponential growth based on our parameters to the population size under logistic growth. 

To do this we can enter our parameters into the logistic and exponential growth formulas 

T = 4980

N0 = 879

R = 0.01

K = 6e+10

N <- (N0*K*exp(r*t))/(K-N0+N0*exp(r*t))

(879*6.000e+10*exp(0.01*4980))/(6.000e+10-879+879*exp(0.01*4980))

Putting the values into the formula, we get 6e+10, which is what we expect as the population has already reached its carrying capacity, but what if the population continued to grow exponentially?

N <- N0*exp(r*t)

(879*exp(0.01*4980)

N = 3.73e+24

This time the population is drastically larger, continuing its exponential growth

![image](https://github.com/user-attachments/assets/8b6b7e08-0c90-4618-a569-e71b36451956)

#######################################################################################

Question 3:

#FULL CODE CAN BE FOUND IN THE 'assignment_questions_code.R' file

We can plot the logistic and exponential function together to see how they compare 

![comparison_plot](https://github.com/user-attachments/assets/7154b376-735e-4a6b-94f3-bfcee3737f79)

