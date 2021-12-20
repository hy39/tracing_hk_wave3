#This function plot the relationship between case number and proportion of traced cases with confirmation delay
install.packages("ggplot2")
library(ggplot2)
library(car)
install.packages("lme4")
library(lme4)
install.packages("truncreg")
require(truncreg)

# read dataset
df1 <- read.csv("dat/virus_hk_0901.csv",header=TRUE);
# create multiple linear model
df1.1 <- df1[-c(14:15), ] 
#Quasi-binomial Regression
lm_fit <- glm(cbind(LinkwithDelay, LinkwithoutDelay)~ TotalLocalAvg + I(TotalLocalAvg * Class), weight=LocalwithLink,  data=df1.1, family=quasibinomial())
summary(lm_fit)

newX <- data.frame(TotalLocalAvg = seq(0, 200*1, 1))
newX$Class <- seq(1,1,length.out=201)
project_df <- data.frame(pred = predict(lm_fit, newX, type="response", se.fit=TRUE))
newX$proj = project_df$pred.fit*100
newX$DailyDelay = project_df$pred.fit*100
newX$Delay = project_df$pred.fit*100
newX$proj.pred_lwr = (project_df$pred.fit - 1.96*project_df$pred.se.fit)
newX$proj.pred_upr = (project_df$pred.fit + 1.96*project_df$pred.se.fit)

newX2 <- data.frame(TotalLocalAvg = seq(0, 200*1, 1))
newX2$Class <- seq(0,0,length.out=201)
project_df <- data.frame(pred = predict(lm_fit, newX2, type="response", se.fit=TRUE))
newX2$proj = project_df$pred.fit*100;
newX2$DailyDelay = project_df$pred.fit*100
newX2$Delay = project_df$pred.fit*100
newX2$proj.pred_lwr = (project_df$pred.fit - 1.96*project_df$pred.se.fit)
newX2$proj.pred_upr = (project_df$pred.fit + 1.96*project_df$pred.se.fit)
newX2$proj.pred_upr [newX2$proj.pred_upr  > 1] <-1
                    
# Plot Figure 5A in the paper
  p <- ggplot(data = df1.1, aes(x = TotalLocalAvg, y = DailyDelay, color = factor(Class))) 
  p + geom_point(size = 4.2, alpha=0.8,) + 
    xlab('Daily number of local cases \n (7-day average)') +
    ylab('Percentage with confirmation delay') +
    scale_y_continuous(expand = expansion(), limits = c(35, 100)) +
    scale_x_continuous(expand = expansion(), limits = c(0, 150)) +
    theme(text = element_text(size = 18))  +  
    theme(legend.title = element_blank()) +
    scale_color_manual(labels=c("Before TT", "After TT"), values=c("blue", "red")) +
    geom_line(data = newX, aes(x = TotalLocalAvg, y = proj), linetype = "solid", size = 0.6) +
    geom_line(data = newX2, aes(x = TotalLocalAvg, y = proj), linetype = "solid", size = 0.6) +
    geom_ribbon(data = newX, aes(ymin=proj.pred_lwr*100, ymax=proj.pred_upr*100), alpha = 0.15, linetype = 0, size = 0.5) +
    geom_ribbon(data = newX2, aes(ymin=proj.pred_lwr*100, ymax=proj.pred_upr*100), alpha = 0.15, linetype = 0, size = 0.5) 
  
# Plot Figure 5B (Moving averaged) in the paper
  ggplot(data = df1.1, aes(x = TotalLocalAvg, y = Delay, color = factor(Class))) + 
    geom_point(size = 4.2, alpha=0.8,) + 
    xlab('Daily number of local cases \n (7-day average)') +
    ylab('Percentage with confirmation delay \n (5-day average)') +
    scale_y_continuous(expand = expansion(), limits = c(50, 100)) +
    scale_x_continuous(expand = expansion(), limits = c(0, 150)) +
    theme(text = element_text(size = 18))  +  
    theme(legend.title = element_blank()) +
    scale_color_manual(labels=c("Before TT", "After TT", "Transition"), values=c("blue", "red", "green")) +
    geom_line(data = newX, aes(x = TotalLocalAvg, y = proj), linetype = "dashed", size = 0.6) +
    geom_line(data = newX2, aes(x = TotalLocalAvg, y = proj), linetype = "dashed", size = 0.6)



