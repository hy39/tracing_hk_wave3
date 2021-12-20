#This function perform model comparison
library(car)
install.packages("lme4")
library(lme4)
install.packages("truncreg")
require(truncreg)
install.packages("lmtest")
library(lmtest)

#See https://cran.r-project.org/web/packages/bbmle/vignettes/quasi.pdf
library(bbmle)
dfun <- function(object) {
  with(object,sum((weights * residuals^2)[weights > 0])/df.residual)
}

# read dataset
df1 <- read.csv("dat/virus_hk_revision.csv",header=TRUE);
df1.1 <- df1[-c(14:15), ] # remove the points from 20 and 21 July (transition period)
#With TT: Starting from 22 July to 15 Aug

## create models
#Check bbmle at https://cran.r-project.org/web/packages/bbmle/vignettes/quasi.pdf
#Use binomial regression
lm_fit <- glm(cbind(LinkwithDelay, LinkwithoutDelay)~ TotalLocalAvg + I(TotalLocalAvg * Class), weight=LocalwithLink,  data=df1.1, family=binomial())
summary(lm_fit)
#Alternative model
lm_fit3 <- glm(cbind(LinkwithDelay, LinkwithoutDelay)~ TotalLocalAvg + DailyTest + I(TotalLocalAvg * Class), weight=LocalwithLink,  data=df1.1, family=binomial())
summary(lm_fit3)

#To obtain AICc for quasi models, use binomial distribution and set dispersion
#See https://cran.r-project.org/web/packages/bbmle/vignettes/quasi.pdf
qAICc(lm_fit,dispersion=dfun(lm_fit), nobs=nrow(df1.1)) # for original model
qAICc(lm_fit3,dispersion=dfun(lm_fit3), nobs=nrow(df1.1)) # for alternative model

  

