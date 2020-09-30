library(data.table)
library(purrr)

dt_1 <- as.data.table(airquality)
View(dt_1)

##(Beginning to) work with missing data
##One of the important tasks when working with data is finding what data is
##missing and how the missing data is structured

##Get a vector of what observations are without NAs (complete)
dt1_compl <- complete.cases(dt_1)
dt1_compl

##How many cases are complete
sum(dt1_compl)
sum(dt1_compl) / nrow(dt_1)

##View incomplete cases
View(dt_1[!complete.cases(dt_1), ])

##We can use mice and VIM packages to make nice plots
##This will show proportions of missing values per variable, as well as
##combinations in which they appear in the data
library(VIM)
aggr(dt_1)

##We can also plot all of our cases and look how the data is structured this way
matrixplot(dt_1)

##We can easily remove missing data
dt_1_c <- na.omit(dt_1)
matrixplot(dt_1_c)
nrow(dt_1_c) == sum(complete.cases(dt_1_c))

                                        #Starting to work with data
##Using data.table
##We can select individual varibles from the data
dt_1_c$Ozone
##This will return a plain R vector

##We can also select multiple variables using the data.table syntax
dt_1_c[,.(Ozone, Month, Day)]
dt_1_c[,c("Ozone", "Month", "Day")]
##This will return a data.table with all observations and only the variables we
##need

##We can also get observations by their number
dt_1_c[10]
dt_1_c[10:15]
#This return a data table with all the variables and the selected observations

##We can combine these operations
dt_1_c[10:15, c("Ozone", "Month", "Day")]

##We can use the data.table syntax for easy and fast subsetting
mean_ozone <- mean(dt_1_c$Ozone)
mean_ozone
dt_1_c[Ozone > mean_ozone]
##We can use logical operations
dt_1_c[(Ozone > mean_ozone) & (Month == 9)]

##We can combine this with variable selection
dt_1_cs <- dt_1_c[(Ozone > mean_ozone) & (Month == 9), .(Ozone, Month, Day)]

##We can add new variables to the data
dt_1_c$CharO3 <- as.character(dt_1_c$Ozone)
##Or in the data.table syntax
dt_1_c[,CharO3DT := as.character(Ozone)]
dt_1_c

##We can transform data with this
dt_1_c$O3Dist <- (dt_1_c$Ozone - mean_ozone) ^ 2
##In the data.table syntax
dt_1_c[,O3DistDT := (Ozone - mean_ozone) ^ 2]
dt_1_c
#Which way is better is fot you to decide, but the d$var <- vec is more
#compatible, especially if you do complex operations

##Removing variables from data
dt_1_c[, CharO3 := NULL]
dt_1_c[, CharO3DT := NULL]
dt_1_c

##Sorting data by a variable
##By default, the order is ascending
dt_1_c[order(Ozone)]
##We can reverse it by multiplying by -1
dt_1_c[order(-1 * Ozone)]
##View 5 days with the most ozone

##We can use data.table to summarize our data
##For example, we can compute means and medians of the variables
dt_1_c[,
       .(MeanO3 = mean(Ozone),
           MedianO3 = median(Ozone),
           MeanRad = mean(Solar.R),
         MedianRad = median(Solar.R))
       ]
##This will give us means/medians over the whole data table

##We can also group/aggregate values
dt_1_c[, .N, by = Month]
##.N just counts values, so it's not that useful by itself
##However, we can combine this with the summaries from above!
dt_1_c[,
       .(  MeanO3 = mean(Ozone),
           MedianO3 = median(Ozone),
           MeanRad = mean(Solar.R),
           MedianRad = median(Solar.R),
           Count = .N
         ),
       by = Month]
##To get aggregate statistics per month
##This can be very useful!

                                        #Simple plots
##We can count values with table
table(dt_1_c$Month)
##We can visualize the counts with barplot
table(dt_1_c$Month) %>% barplot()
##main = title of the plot
##We can give other arguments to barplot to make it more appealing
table(dt_1_c$Month) %>%
  barplot(main = "Complete observations per month",
          col = "indianred",
          ylab = "N Observations",
          xlab = "Month",
          axes = FALSE)
##We can add our own custom axes
axis(2, at = seq(from = 0, to = 30, by = 3))

##We can also do the same, but with percentages
percent_table <- table(dt_1_c$Month) * 100 / sum(table(dt_1_c$Month))
percent_table %>%
  barplot(main = "Complete observations per month",
          col = "indianred",
          ylab = "% Observations",
          xlab = "Month")
##We can also add text
percent_table %>%
  barplot(main = "Complete observations per month",
          col = "indianred",
          ylab = "% Observations",
          xlab = "Month") %>%
  text(x = ., y = percent_table + 1, labels = paste(round(percent_table, 2), "%"))

##Now, we can also use R to make a pie chart
##Remember, with great power comes great responsibility
pie(percent_table)
##We can also use the same arguments
pie(percent_table, main = "Observations by month")
##I don't like pie charts

##For data on a ratio (or interval) scale, we can make other types of plots
##Histograms
hist(dt_1_c$Solar.R)
##Or with some eye candy
hist(dt_1_c$Solar.R,
     col = "darkorchid1",
     main = "Solar Radiation Level",
     xlab = "Radiation Level",
     ylab = "Frequency",
     breaks=20)
##Breaks sets the number of bars on the histogram

##Density plots
plot(density(dt_1_c$Solar.R))
hist(dt_1_c$Solar.R)
line(density(dt_1_c$Solar.R))
##Or with some eye candy
plot(density(dt_1_c$Solar.R),
     main = "Solar Radiation Level",
     xlab = "Radiation level",
     lwd = 3,
     col = "green")

##Boxplot
boxplot(dt_1_c$Solar.R)
boxplot(dt_1_c$Solar.R, col = "lightgreen")

##With an external package, we can create violin plots
##Which are a combination of density and boxplot
library(vioplot)
vioplot(dt_1_c$Solar.R, col = "lightgreen")

##Tesing for normality
##First, let's compute the mean and SD of our variable
mean_SR <- mean(dt_1_c$Solar.R)
sd_SR <- sd(dt_1_c$Solar.R)
##Plot the density of our variable
plot(density(dt_1_c$Solar.R),
     main = "Solar Radiation Level",
     xlab = "Radiation level",
     lwd = 3,
     col = "green")
##Plot the normal distribution with the same mean and SD
##For this, we can use the function lines
curve(dnorm(x, mean = mean_SR, sd = sd_SR),
      ##Note that we use this argument x that is undefined
      ##This is beacause function curve will use this internally
      ##To call dnorm with the correct values of x
      ##It will take them from the plot we have made earlier
      col = "red",
      lwd = 3,
      add = TRUE,
      ##add = TRUE tells the function to add the curve to a plot
      ##that already exists
      )

##Looking at pictures is good, but we can use a more rigorous approach and
##utilize statistical tests to test for normality
##There are many tests to test for normality (I guess Polina will show some of
##them to you). Here, I will use the Anderson-Darling test for demonstration
##purposes.
##A lot of those tests are contained in the nortest package
library(nortest)
ad.test(dt_1_c$Solar.R)
##H0 is that the data is normally distributed
##We can reject that here :)

##For data that IS almost normally distributed
toy_normal_data <- rnorm(100) + runif(100, min = 0.02, max = 0.03)
plot(density(toy_normal_data))
curve(dnorm, col = "red", add = TRUE)
ad.test(toy_normal_data)

##Some people like to look at skewness and kurtosis of their data
##package moments has functions for these
library(moments)
skewness(dt_1_c$Solar.R)
kurtosis(dt_1_c$Solar.R)
skewness(toy_normal_data)
kurtosis(toy_normal_data)

##Another way to test for normality is to look at a quantile plot
##There's a good funtion for it in the package car
library(car)
qqPlot(dt_1_c$Solar.R)
qqPlot(toy_normal_data)
##I'm not going to bore you with this any further, you are going to see
##plenty more of those in ALM-1

##We can also use R to look at how variables interact with each other

##Let's start with crosstabs
dt_mtcars <- as.data.table(mtcars)
print(mtcars_table <- table(dt_mtcars$carb, dt_mtcars$cyl))
##We can visualize this with a mosaic plot
##With the package vcd
vcd::mosaic(carb ~ cyl, data = dt_mtcars)
##This is not the best example, but this is just for reference, you will see A
##LOT more of those in your data mining course

##We can also do a chi-square test on our table
chisq.test(mtcars_table)
##There's some association, who would've known!
##Again, refer to Dr. Zaytsev, Dr. Kuskova and Polina for more information

##For interval scales and up, we can do more!
##The easiest thing is a scatterplot
##Very easy to do with base R
plot(x = dt_mtcars$hp, y = dt_mtcars$qsec)

##Or with eye candy
plot(x = dt_mtcars$hp, y = dt_mtcars$qsec,
     main = "Horsepower to 1/4 mile time",
     xlab = "Horsepower",
     ylab = "1/4 mile time",
     pch = 19)
##For values of PCH see
##http://www.sthda.com/english/wiki/r-plot-pch-symbols-the-different-point-shapes-available-in-r

#We can visualize a 3rd variable with color
cyl_colors <- dt_mtcars$cyl %>%
  as.character %>%
  replace(., . == "4", "green") %>%
  replace(., . == "6", "blue") %>%
  replace(., . == "8", "red")
plot(x = dt_mtcars$hp, y = dt_mtcars$qsec,
     main = "Horsepower to 1/4 mile time",
     xlab = "Horsepower",
     ylab = "1/4 mile time",
     pch = 19,
     col = cyl_colors)

##With the help of the car package, we make a lot of such plots with a single
##function call
scatterplotMatrix(dt_mtcars[,-c("cyl", "carb", "vs", "am", "gear")])
##removing variables with few values (can be thought of as factor variables)

##We can also look at correlations between variables
##Here, we will use Pearson correlation
##The cor function, however, supports kendall and spearman with the method
##argument
print(cor_mat <- cor(dt_mtcars[,-c("cyl", "carb", "vs", "am", "gear")], 
                     method = "kendall"))

##It looks boring :(
##The corrplot package gives us the tools to visualize it
library(corrplot)
##Viridis provides a very good color palette
library(viridis)
corrplot(cor_mat,
         method = "color",
         type = "lower",
         addCoef.col = "black",
         col = viridis(1000))
##corrplot as a lot of options, please see help for this package

##We can also estimate densities of 2 variables
##We can visualize them as a heatmap
##Package MASS will help with that
library(MASS)
##First, estimate their 2D density
mtc_2d_den <- MASS::kde2d(dt_mtcars$hp, dt_mtcars$qsec)
filled.contour(mtc_2d_den, color.palette = viridis)
contour(mtc_2d_den, add = TRUE)

##We can also think of the density as of the 3rd dimension of our data
library(plot3D)
library(plot3Drgl)
library(rgl)
persp3Drgl(x = mtc_2d_den$x,
           y = mtc_2d_den$y,
           z = mtc_2d_den$z,
           axes = TRUE,
           contour = TRUE)
