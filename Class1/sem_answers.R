                                        # Problem 1
## 2 varibles, x and y have some values in them
x <- 1
y <- 2
## Write a snippet of code that will swap their values
temp <- x
x <- y
y <- temp
x
y

                                        # Problem 2
## We have variables
a <- 4.5
b <- "3,145"
c <- 2.36
d <- TRUE

## What are their types
## a - numeric
## b - character
## c - numeric
## d - logical

## Convert variable d to an integer
d <- as.integer(d)

## Convert variable b to numeric (watch the comma)
b <- as.numeric(gsub(",", ".", b, fixed = TRUE))

## Convert variable a to a string (character)
a <- as.character(a)

## Convert variable c to integer
c <- round(c)
                                        # Problem 3
f <- "23456,89"
## Using all the necessary conversions and functions, save the natural
## log of the value to the variable l_f
l_f <- log(as.numeric(gsub(",", ".", f, fixed = TRUE)))

                                        #Problem 4
## We have a vector of values
v <- c(1, 0, 2, 3, 6, 8, 12, 15, 0, NA, NA, 9, 4, 16, 2, 0)

                                        # Problem 4a
## Show
## The fisrt element of v
v[1]

## The last element of v
v[length(v)]

## Elements of v form the 2nd to 6th inclusive
v[2:6]

## Elements of v that are bigger than 2
### Create a version of v with no NAs in it
v_nona <- v[!is.na(v)]
v_nona[v_nona > 2]

## Elements of v that are divisible by 3
v_nona[v_nona %% 3 == 0]

## Elements of v that are both divisible by 3 and greater than 2
v_nona[(v_nona %% 3 == 0) & (v_nona > 2)]

## Elements of v that are either less than 5 or greater then 10
v_nona[(v_nona < 5) | (v_nona > 10)]

                                        # Problem 4b
## Replace the second to last value of v with 10
## The code should work for vectors of all lengths
## Create a copy of v so we don't destroy it
v_copy <- v
v_copy[length(v_copy) - 1] <- 10

                                        # Problem 4c
## Show indices of NA's in v
which(is.na(v))

## Count NA's in v without using which
sum(is.na(v))

                                        # Problem 5
## We have a vector
v_2 <- c(15000, 22000, 25000, 190000, 64000, 1514)
## Convert this vector to a factor vector
## With value 1 if the value in v_2 is above
## and 0 if the value in v_2 is at or below average
## DO NOT USE THE mean FUNCTION
v_2_mean <- sum(v_2) / length(v_2)
v_2_bin <- v_2
v_2_bin <- replace(v_2_bin, v_2 > v_2_mean, 1)
v_2_bin <- replace(v_2_bin, v_2 <= v_2_mean, 0)
v_2_bin <- as.factor(v_2_bin)
v_2_bin
                                        # Problem 6
## FizzBuzz
## Write code that will print all numbers from 1 to 100, but
## 1) If the number is divisible by 3, it will print Fizz instead
## 2) If the number is divisible by 5, it will print Buzz instead
## 3) If the number is divisible by both 3 and 5, it will print FizzBuzz instead
v_fb <- 1:100
v_fb_o <- as.character(v_fb)
v_fb_o <- replace(v_fb_o, v_fb %% 3 == 0, "Fizz")
v_fb_o <- replace(v_fb_o, v_fb %% 5 == 0, "Buzz")
v_fb_o <- replace(v_fb_o, (v_fb %% 5 == 0) & (v_fb %% 3 == 0), "FizzBuzz")
v_fb_o
