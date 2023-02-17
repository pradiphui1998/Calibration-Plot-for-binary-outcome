#Calibration Plot
library(predtools)
library(magrittr)
library(dplyr)
library(ggplot2)

# What is calibration plot?
#   Calibration plot is a visual tool to assess the agreement between predictions and observations in different percentiles (mostly deciles) of the predicted values.
# 
# calibration_plot function constructs calibration plots based on provided predictions and observations columns of a given dataset. Among other options implemented in the function, one can evaluate prediction calibration according to a grouping factor (or even from multiple prediction models) in one calibration plot.


# A step-by-step guide.
# Imagine the variable y indicates risk of disease recurrence in a unit of time. We have a prediction model that quantifies this risk given a patient’s age, disease severity level, sex, and whether the patient has a comorbidity.
# 
# The package comes with two exemplary datasets. dev_data and val_data. We use the dev_data as the development sample and the val_data as the external validation sample.


data(dev_data)
data(val_data)



#We use the development data to fit a logistic regression model as our risk prediction model:
  
  
reg <- glm(y~sex+age+severity+comorbidity,data=dev_data,family=binomial(link="logit"))
summary(reg)


# Given this, our risk prediction model can be written as:
#   
#   logit(p)=−1.7289+0.5572∗sex+0.0052∗age−0.5573∗severity+1.0919∗comorbidity
# .
# 
# Now, we can create the calibration plot in development and validation datasets by using calibration_plot function.




dev_data$pred <- predict.glm(reg, type = 'response')
val_data$pred <- predict.glm(reg, newdata = val_data, type = 'response')

calibration_plot(data = dev_data, obs = "y", pred = "pred", title = "Calibration plot for development data")


calibration_plot(data = val_data, obs = "y", pred = "pred", y_lim = c(0, 0.6),
                 title = "Calibration plot for validation data", group = "sex")


