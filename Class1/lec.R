                                        # R as a calculator
## We can use R as a calculator
## that can do basic arithmetic:
12 + 18
5 * 3
2 ^ 3
sqrt(16)
16 ^ (1 / 4)

## rounding:
round(4 / 3)
round(4 / 3, 2)

## as well as other mathematical operations:
pi
exp(1)
exp(2)
log(exp(1))
log10(100)
log(4, base = 2)

## R has a very good built-in help system
## to find more math fucntions in base library

help.search(keyword = "math", package = c("base"))

## to show help for some function
help("abs")

                                        # Installing and using libraries
## Most of the time, we will be wokrning with functions that are not part
## of the standard library of R.
## Fortunately, R has a large repository if external libraries
## To install libraries from it, there's a function
install.packages(c("data.table", "purrr", "openxlsx"))
## This will install packages that we will be using in this course
## There are many, many more
## Most of the time, you can find them using Google or via your
## instructor

## To load a library, there's a function
library(purrr)
## That will load the purrr library

                                        # Variables
## R (like many other imperative programming languages) has variables
## Their names can contain letters, numbers, dots and underscores
## but cannot begin with a number

var_1 <- 1
var_1

var_2 = 2
var_2

## Both <- and = can be used for variable assignments, although <-
## although <- is considered more idiomatic
## !!!PLEASE, DO NOT USE = FOR ASSIGNMENTS IN R!!!

## In R, variables are muatble (we can change their) value
var_1 <- var_1 + 2
var_1

## Types of variables in R:
## Numeric (floating-point number)
## Integer (whole number)
## Character (text, same as string in other languages)
## Logical (true or false, same as bool[ean] in other languages)

num_1 <- 2.718281828459045
is.numeric(num_1)
is.integer(num_1)
is.character(num_1)
is.logical(num_1)

## We can use a function to find the type of a variable
var_3 <- "this is a piece of text"
class(var_3)

## We can do type conversions

## character to numeric:
as.numeric("3.1415926")
## of course, not all character variables can be converted to numeric
as.numeric("HAHA") ## BOOM!

## logical to numeric (integer)
as.numeric(T)
as.numeric(F)

## numeric (integer) to character
as.character(3)
as.character(1.61803398875)

## If that's not obvious, we can use variables in place of values
## in code
num_2 <- 3
num_3 <- 5
num_4 <- num_2 + num_3
num_4

## Logical expressions and operators
## Logical expressions:
num_2 == num_3 #TRUE if values are equal
num_2 != num_3 #TRUE if values are not equal
num_3 > num_2 #Strictly more
num_2 < num_3 #Strictly less
num_2 <= num_3 #Less than or equal

## Logical operators
## Combine logical values
log_1 = TRUE
log_2 = FALSE

log_1 && log_2 #Logical AND
log_1 || log_2 #Logical OR
!log_2 #Logical not
xor(log_1, log_2) #Exclusive OR (exactly one is TRUE)


                                        # Working with text
## This is a very small introduction using base R
## you may need it to JUST MAKE IT WORK ALREADY!!!
## but there are packages (stringr) that do a better job than base R

char_1 <- "This | is | a | test | piece | of | text"

## Check if a string has a substring in it
grepl("test", char_1, fixed = T)
grepl("blabla", char_1, fixed = T)

## Replace a substring with another substring
gsub(" | ", " ", char_1, fixed = T)

## Split string on occurrence of a substring
strsplit(char_1, " | ", fixed = T)
## This returns a list, we will talk about them later

                                        # Vectors
## Vector is a list of obejcts of the same type
## Like a list of observations of one variable!!!

## Vectors can be created manually with the function c
vec_1 <- c(1.2, 4.1, 3.5, 5.0, 10)
vec_1

## Type of the vector
class(vec_1)
## Note that R has aumatically converted 10 to 10.0
## So all elements are of the same type and no information is lost

vec_2 <- c(4.5, 3.6, 3.0, 1.5, 7)

## Arithmatic operations on vectors are elementwise
vec_1 + vec_2
vec_1 * vec_2 #This is not vector multiplication!!

## If we use a scalar together with a vector, the operation
## is applied to all elements of the vector
1 + vec_1
2 * vec_1

## We can concatenate vectors with the c function
vec_3 <- c(vec_1, vec_2)
vec_3

## We can have vectors of any type
vec_4 <- c("A", "B", "C", "D", 10)
vec_4
class(vec_4)
## Note that R has automatically converted 10 to string "10"

## Ordinal scale data vectors can be represented as factors
vec_grades5 <- c(2, 3, 5, 5, 4, 2, 3, 3)
vec_grades5 <- factor(vec_grades5, levels = c(2, 3, 4, 5))
vec_grades5
levels(vec_grades5)
## We can set readable names for levels
levels(vec_grades5) <- c("fail", "pass", "good", "excellent")
vec_grades5
## But the values will be efficiently stored in memory as numbers!

## Type conversions also work with vectors
as.numeric(c("1", "2", "3", "4"))

## Working with vector elements
vec_5 <- c(1.1, 2.3, 3.3, 4.4, 5.5, 6.6, 7.7, 8.8, 9.9, 10.0)
vec_5
length(vec_5)

## !!!IN R, ARRAYS (lists and vectors too) START AT 1!!!
vec_5[0] #BOOM!
vec_5[1]

## We can use vectors as vector indices
vec_5[1:3]
vec_5[c(1, 4, 9)]

## Logical operations on vectors are elementwise and produce logical vectors
vec_5_l_1 <- vec_5 > 4
vec_5_l_1
## Which be used for vector indexing
vec_5[vec_5_l_1]

## We can use complex expressions this way
## (note that single & is elementwise, while && is not)
vec_5[(vec_5 > 4) & (vec_5 %% 2 == 0)]

## We can go from logical vectors to element numbers
## Using function
which(vec_5 > 3)
## All the complex expression also work inside which

## Add an element to a vector
vec_6 <- vec_5
vec_6

## One way
vec_6[length(vec_6) + 1] <- 11.11
vec_6

## Another way
vec_6 <- c(vec_6, 12.12) #Probably a bit slower
vec_6

## Replacing elements
vec_7 <- c("A", "B", "A", "A", "B", "B")
vec_7 <- replace(vec_7, vec_7 == "A", 1)
vec_7 <- replace(vec_7, vec_7 == "B", 2)
vec_7
vec_7 <- as.numeric(vec_7)
vec_7

## Other useful functions on vectors
vec_8 <- c(1,2,3,4)
vec_8

## Sum of elements
sum(vec_8)

## Product of elements
prod(vec_8)

## Smallest and largest element
min(vec_8)
max(vec_8)

## Repeat vector is different ways
rep(vec_8, times = 3)
rep(vec_8, each = 3)
