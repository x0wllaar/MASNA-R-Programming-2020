library(data.table)
library(purrr)

#LAST CLASS!

#Some more info on R syntax

#Conditionals are for when you need to determine what code to run based on a
#value
test.num = 5
if (test.num %% 2 == 0){
  print("Even")
}else{
  print("Odd")
}

#We can use else if to test multiple conditions until one matches
grade <- 4
if(grade >= 8){
  print("A")
}else if (grade >= 6)  {
  print("B")
}else if (grade >= 4) {
  print("C")
}else if (grade >= 0){
  print("D")
} else {
  print("WHY?")
}

#We can also omit else and else if
test.num.2 <- -2
if(test.num.2 < 0){
  test.num.2 <- -1 * test.num.2
}
print(test.num.2)

#Functions. Functions allow us to package out code into distinct units that
#perform specific tasks. This means less boilerplate, more code reuse and easier
#maintainability.

#We can create functions using this syntax
minkowski.distance <- function(x, y = c(0,0), p = 2){
  vec.diff <- x - y
  abs.diff <- abs(vec.diff)
  pow.diff <- abs.diff ^ p
  tot.diff <- sum(pow.diff)
  tot.diff ^ (1/p)
}

minkowski.distance(c(0,0), c(1,1), 2)

#x, y and p are known as arguments or parameters. When we call the function, we
#give it the arguments, which are then bound to the names in the declaration

#Note that the variables declared inside functions are in local scope, we can't
#access them from the outside

#We can give arguments either by their order (and not care about their names),
#like this
minkowski.distance(c(0,0), c(1,1), 1)

#Or by their names (and in any order we want)
minkowski.distance(x = c(0,0), y = c(1,1), p = 1)
minkowski.distance(p = 1, x = c(0,0), y = c(1,1))

#Or we can combine
minkowski.distance(c(0,0), c(1,1), p = 3)

#In the declaration, y and p are given default values. This means that we can
#omit them when calling the function and the omitted arguments will use the
#default values
minkowski.distance(c(1,1))
minkowski.distance(c(1,1), p = 1)

#Functions in R implicitly return the result of the last expression. If you want
#to return earlier than the function ends or just to make it more explicit, you
#can use return(value). Note the parentheses

#Did you note how we assigned the function to a variable? Because it's a
#first-class value, just like all the other variables we worked with

#We can pass functions to functions (this will be useful later)
print(minkowski.distance) #Note that we are not calling the function here

#Functions can return other functions
lp.norm <- function(norm.p = 2){
  lp.norm.rf <- function(x){
    return(minkowski.distance(x, p = norm.p))
  }
  return(lp.norm.rf)
}

l2.norm <- lp.norm(2)
l2.norm(c(1,1))

#Functions can call other functions and themselves (also known as recursion)
fact <- function(x){
  if(x == 0){return(1)}
  x * fact(x - 1)
}
fact(5)

#Loops. Sometimes we need to do something over and over many times. We can use a
#loop for that

#R has 2 kinds of loops: a for loop and a while loop

#While loops run when a condition is met
rand.num.1 <- 0
while(rand.num.1 <= 0.7){
  rand.num.1 <- runif(1)
  print(rand.num.1)
}
#When a condition stops being met, the loop stops

#R also has 2 special keywords for control flow within loops: break and next
#break stops the loop; next stops the current iteration, but starts the next
#iteration (in other languages it's called continue)

rand.num.1 <- 0
while(rand.num.1 <= 0.7){
  rand.num.1 <- runif(1)
  if(rand.num.1 <= 0.5){
    next
  }
  print(rand.num.1)
}

#We can make an infinite loop with while(TRUE). However, R has a shorthand for
#that called repeat
repeat{
  rand.num.2 <- runif(1)
  if(rand.num.2 <= 0.5){
    next
  }
  print(rand.num.2)
  if(rand.num.2 > 0.7){
    break
  }
}

#For loops operate on elements of a sequence (like foreach in other languages)
test.seq.1 <- 1:10
for(e in test.seq.1){
  print(e)
}
#Note that this loop variable (e) exists in global scope
print(e)

#We don't always need loops to process many elements We can use functions!

#sapply takes a vector and a function, runs the function on each element and
#returns a vector of results
1:10 %>% sapply(., function(x){x*2})
#We can pass complex functions to sapply
1:10 %>% sapply(function(x){
  if(x %% 2 == 0) {
    return(x + 1)
  }
  if(x %% 3 == 0){
    return(x + 3)
  }
  x
})
#lapply will do the same to lists
#They might be also known to you as map

#apply is trickier to use, but will work on matrices and data frames and other
#objects
#apply takes an additional argument - margin, which tells the function over
#which dimension of the object to operate
matrix(rnorm(15), nrow = 5)

matrix(rnorm(15), nrow = 5) %>% apply(1, sum)
#Computes sums for dimension 1 (for every row)

matrix(rnorm(15), nrow = 5) %>% apply(2, function(x){
  print(x)
  print("***")
  sum(x)
})
#You can see here that the function is called on one row at a time

matrix(rnorm(15), nrow = 5) %>% apply(2, sum)
#Computes sums for dimension 2 (for every column)


#About combining hist and density
#First, note the use of freq=FALSE when calling hist, this is so it plots
#probablilities and the scales of the plots match

#Way 1: plot density first, add hist on top
#Hist takes an add parameter, that makes it draw on the previous plot
rand.vec.1 = rnorm(1000)
plot(density(rand.vec.1))
hist(rand.vec.1, freq=FALSE, add=TRUE)

#Way 2: plot hist first, then put density on top of it with lines
rand.vec.1 = rnorm(1000)
hist(rand.vec.1, freq=FALSE)
lines(density(rand.vec.1), lwd = 3, col = "mediumseagreen")

#Saving plots to files
#We can tell R to draw a plot to a file instead of the screen
#https://bookdown.org/rdpeng/exdata/graphics-devices.html

#Before plotting, open a device
pdf(file = "plot.pdf")
#Now, our plots will be saved to this file
rand.vec.1 = rnorm(1000)
hist(rand.vec.1, freq=FALSE)
lines(density(rand.vec.1), lwd = 3, col = "mediumseagreen")
#Finalize the creation of the plot and close the device
dev.off()

#We can also take an exiting plot and copy it to a device
rand.vec.1 = rnorm(1000)
hist(rand.vec.1, freq=FALSE)
lines(density(rand.vec.1), lwd = 3, col = "indianred")
dev.print(pdf, file = "plot2.pdf")

#There are many graphics devices available for R Of note are PDF (with this, we
#can make plots that are easy to include into latex, vector format), SVG (vector
#format, usable for web pages) and PNG (raster format, lossless and widely
#supported)
dev.print(png, filename = "raster_plot.png",
          width = 1000, height = 1000, res = 196)
dev.print(png, filename = "raster_plot_cairo.png", type = "cairo",
          width = 1000, height = 1000, res = 196)

#Making good reports on your results!
#This can be very important when writing reports and papers (some reviewers will
#go mad if you don't follow the template)
#Fortunately, there are libraries that will do this for you!
library(stargazer)
#This is a very flexible library that will make

#Make a good looking summary table
airquality %>% stargazer(type = "text")
airquality %>% na.omit %>% stargazer(type = "text")
#Unfortunately, does not report the number of missings without additional
#programming
#See https://stackoverflow.com/questions/15823207/is-it-possible-to-report-nas-in-stargazer-table

#Make a crosstable
car.table <- table(mtcars$cyl, mtcars$carb)
car.table %>% as.data.frame.matrix %>% stargazer(type = "text", summary = FALSE)
#Note the use of as.data.frame.matrix, does not work otherwise

#Make a correlation matrix
correlation.matrix <- cor(mtcars)
correlation.matrix %>% stargazer(type = "text")
#No significance level :(
#It may be possible to manually add significances to the table
#https://gist.github.com/anhqle/5855936

#Make a well-formatted regression output
cars.data <- mtcars %>% as.data.table()
summary(cars.model.1 <- lm("mpg ~ hp + wt", data = cars.data))
stargazer(cars.model.1, type = "text", dep.var.labels=c("mpg"))
#Looks good!

#Now, we can use this to compare multiple models
summary(cars.model.1 <- lm("mpg ~ hp + wt", data = cars.data))
summary(cars.model.2 <- lm("mpg ~ disp*cyl + wt + hp", data = cars.data))
stargazer(cars.model.1,cars.model.2, type = "text",
          dep.var.labels=c("Miles per gallon"))

#Give names to independent variables
stargazer(cars.model.1,cars.model.2, type = "text",
          dep.var.labels = c("Miles per gallon"),
          covariate.labels = c("Engine displacement", "Number of cylinders",
                               "Engine displacement*Number of cylinders",
                               "Weight", "Constant")
)

#Set table title
stargazer(cars.model.1,cars.model.2, type = "text",
          dep.var.labels = c("Miles per gallon"),
          covariate.labels = c("Engine displacement", "Number of cylinders",
                               "Engine displacement*Number of cylinders",
                               "Weight", "Constant"),
          title="Factors of fuel consumption"
)

#Let's say that we're satisfied with the table we have
#We can save the table to a file to use it in our paper

#If we use LaTeX
stargazer(cars.model.1,cars.model.2, type = "latex",
          dep.var.labels = c("Miles per gallon"),
          covariate.labels = c("Engine displacement", "Number of cylinders",
                               "Engine displacement*Number of cylinders",
                               "Weight", "Constant"),
          title="Factors of fuel consumption",
          out="cars_table.tex"
)

#If we use Word
stargazer(cars.model.1,cars.model.2, type = "html",
          dep.var.labels = c("Miles per gallon"),
          covariate.labels = c("Engine displacement", "Number of cylinders",
                               "Engine displacement*Number of cylinders",
                               "Weight", "Constant"),
          title="Factors of fuel consumption",
          out="cars_table.html"
)
#Word can open HTML files

#Stargazer is a huge package with a lot of options of how to use it
#Some useful links
#https://cran.r-project.org/web/packages/stargazer/vignettes/stargazer.pdf
#https://dss.princeton.edu/training/NiceOutputR.pdf