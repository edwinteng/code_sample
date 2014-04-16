
# read datasets
interact=read.table("userFollowerInteractTopN.txt",sep="\t",head=T)
interactDetail = read.table("userFollowerInteractDetail.txt",sep="\t",head=T)

# merge dataset
all = merge(interact,interactDetail,by=c("user","follower"))

# generate some variables from the dataset
all$diff = all$jaccard_after_topN - all$jaccard_prev_topN
all$num_day = (all$endTime-all$beginTime)/86400

#examine mean, median, variance of data
summary(all)

# plot distribution of data
multi.hist(all)

# build a linear regression model to examine the difference between users and their followers based on (a) how many days they interact, how many comments users give, how many posts users wrote, how many favourite posts users click, and the jaccard coefficient of shared followers (i.e. overlap of followers)
model<-lm(all$diff~all$num_day+log(all$comment+1)+log(all$wrote+1)+log(all$favourite+1)+all$jaccard_self_topN)
# examine R^2, coefficients, p-values, significance, residuals, and standard errors
summary(model)


# examine multi-collinearity
# examine variance inflation factors
vif(model)

#assessing residuals with QQ plot
qqPlot(model,main="QQ Plot")

# examine residual plots
#check residuals
plot(fitted(model), residuals(model),xlab = "Fitted Values", ylab = "Residuals")
abline(h=0, lty=2)
