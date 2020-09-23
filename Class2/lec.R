                                        #Pipeline operator
##There is a library called purr that has this operator %>%
##In RStudio, it can be inserted with Ctrl-Shift-M
##It allowws to chain functions and values together in a readable fasion
##For example
print(paste(log(as.numeric("1234")), "is irrational"))
##Is kinda hard to read
library(purrr)
##We can rewrite this as
"1234" %>% as.numeric() %>% log() %>% paste(., "is irrational") %>% print
##Which, to me is much easier to read and understand what is going on
##Note that a . indicates where the previous value should go
##Otherwise, it is assumed that it's the first argument
##Some libraries (such as dplyr) make extensive use of it
##I will use it a lot as well

                                        #A little bit more about vectors
##If all elements of a vector are unique, we can do set operations on it

vec_1 <- c(1, 1, 2, 3, 4, 5, 6, 7, 7, 8, 9, 9, 10)
vec_2 <- c(9, 10, 22, 33, 44)
##We can use the function unique to create such vectors
vec_1 <- vec_1 %>% unique()
vec_1
##Both vec_1 and vec_2 have only unique vaules and can be treated as sets

##Check if element in set (this also works with repeated elements)
10 %in% vec_1
is.element(10, vec_2)

##Union of 2 sets (element in any or in both)
union(vec_1, vec_2)

##Intersection of 2 sets (element in both)
intersect(vec_1, vec_2)

##Set difference (element in fist but not in second)
setdiff(vec_1, vec_2)
setdiff(vec_2, vec_1)
##Order matters!

##Set equality (have the same elements)
setequal(vec_1, vec_2)
setequal(vec_1, vec_1)
##Order of elements does not matter here
setequal(rev(vec_1), vec_1)

                                        #Matrices
##A lot of data is 2-dimensional (variables * observations) and can be
##represented as a matrix. Which is convenient because we can do linear algebra
##on it! R has support for matrices. Matrices in R are like matrices in math,
##and we can do mathematical operations on them

##We can create an empty matrix like this
mat_1 <- matrix(0, nrow = 4, ncol = 3)
mat_1
##We can use any value in place of the 0

##Look at the size of the matrix
dim(mat_1)

##We can create matrices from vectors
##By concatenating them
vec_2 <- c(1, 2, 3, 4)
vec_3 <- c(5, 6, 7, 8)
vec_4 <- c(9, 10, 11, 12)
vec_5 <- c(13, 14, 15, 16)

##Each vector is a row
rbind(vec_2, vec_3, vec_4, vec_5)

##Each vector is a column
##Usable from a matrix out of vectors of observations of individual variables
cbind(vec_2, vec_3, vec_4, vec_5)

##We can make a matrix from a vector by wrapping it around
mat_2 <- matrix(1:12, nrow = 3, ncol = 4)
mat_2

##Accessing elements of matrices
mat_2[1, 3]
##Matrix[row, column]
mat_2[1, ]
##Get a whole line as a vector
mat_2[, 4]
##Get a whole column as a vector
##We can assign elements is well
mat_2[1, 3] <- 7

##We can give names to rows and columns of a matrix
colnames(mat_1) <- c("Var1", "Var2", "Var3")
rownames(mat_1) <- c("Obs1", "Obs2", "Obs3", "Obs4")
mat_1

##Some operations on matrices
##Transpose
mat_2_t <- t(mat_2)
mat_2_t

##MATRIX Multiplication (like in math)
mat_2_proj <- mat_2 %*% mat_2_t
mat_2_proj

##Can MATRIX multiply with a vector
mat_2 %*% c(1, 1, 1, 1)

##ELEMENTWISE Multiplication
mat_2 * mat_2

##Addition
mat_2 + mat_2

##Multiply by scalar
3 * mat_2

##Determinant
mat_3 <- c(2, 2, 3, 2) %>% matrix(2, 2)
mat_3
det(mat_2_proj)
det(mat_3)

##Inverse
mat_3_i <- solve(mat_3)
mat_3_i
mat_3 %*% mat_3_i

                                        #Lists
##Lists can be thought of as vectors of vectors or as nested arrays. They are
##NOT matrices!. They can hold elements of different types and are ordered They
##are useful to carry structured data around. Many objects in R can be thought
##of as lists, like linear regression (lm) results
list_1 <- list(c(1, 2, 3), c(4, 5, 6))
list_1
list_2 <- list(c("A", "B", "C"), c(1, 2, 3))
list_2

##We can access elements of lists with [[number]]
list_1[[2]]
list_2[[1]]
##We can change elements of lists
list_1[[2]] <- list_1[[2]] + 1
list_1
##And we can add elements to lists too
list_1[[3]] <- "test"
list_1
list_1[[3]] <- NULL
list_1

##Elements of lists can be named
list_3 <- list(letters = c("A", "B", "C"), numbers = c(1,2,3))
list_3
##We can still access them by number
list_3[[1]]
##But it's much more readable to access by name
list_3$letters
##We can remove names with unname
unname(list_3)
##And get and change names with names
names(list_3)
names(list_3) <- c("character", "integer")
list_3

##We can use unlist to turn lists into vectors
list_4 <- c(1,2,3) %>% list()
list_4
unlist(list_4)
##If we have more than 1 elemest, they will be appended sequentially
unlist(list_1)
unlist(list_2)
##All rules about vectors (same type) still apply

                                        #Working with data
##Finally we get to work with data!
##But first, we need to load them into R

##R can load data from files. By default (and if you use relative paths) R looks
##for files in the so-called working directory. We can get the name of this
##directory with getwd and set it with setwd
getwd()
w_dir <- getwd()
setwd(w_dir)
##setwd("/path/to/your/directory")
##NB! Windows being Windows, you should use the FORWARD slash in file paths not
##the windows default backslash (/ not \)
##In paths, you can refer to the current directory as "."

##List files in working directory
list.files(".")

##First, we will work with plain R data frames. They are always available, but
##extremely inconvenient to work with and slow. We will also work with CSV and
##TSV files here, as we do not need any external packages to read and write them

##We can read data from a CSV file into a data frame
df_1 <- read.csv("iris.csv")
df_1
##Convenient viewer
View(df_1)

##We can read data from a TSV file into a data frame
df_2 <- read.table("iris.txt", sep = "\t", header = TRUE)
View(df_2)

##Working with data in other formats
##Excel data can be read (and written) with the openxlsx library
##Note that it's not that efficient, especially with 1GB+ files
library(openxlsx)
df_3 <- read.xlsx("iris.xlsx")
View(df_3)

##STATA files can be read with the foreign library
##I am not sure if I can put the file on GitHub, so this code will get it from
##the internet
dta_link <- "https://stats.idre.ucla.edu/stat/stata/examples/kirk/co3.dta"
dta_file <- tempfile(fileext = ".dta")
download.file(dta_link, dta_file)
library(foreign)
df_4 <- read.dta(dta_file)
View(df_4)

##Writing files work almost the same, but use write.* functions instead of
##read.*. Not all formats can be written! I recommend keeping your data in
##either CSV or XLSX, because they are open (XLSX is open too) and well
##supported on many platforms
ac_csv <- tempfile(fileext = ".csv")
ac_csv
write.csv(airquality, ac_csv)
read.csv(ac_csv) %>% View()

##We can also use R's own internal format to save data to disk, this is quick
##and compatible with other R installations. Not very compatible with other
##programs though
ac_rdata <- tempfile(fileext = ".RData")
save(airquality, file = ac_rdata)
load(ac_rdata)

##However, in this course we will make a lot of use of the data.table package.
##It provides some functions to work with files, but also has a nice collection
##of functions and a nice syntax for data wrangling. I work with this package a
##lot. Another advantage is that it's very fast, especially when working with
##millions of lines of data
library(data.table)

##First of all, we can turn data frames into data tables
dt_df <- as.data.table(df_1)
class(dt_df)
View(dt_df)

##We can also read data from csv with fread (this is much faster than read.csv)
dt_iris <- fread("iris.csv")
View(iris)

##We can write data to csv files with fwrite
fwrite(airquality, ac_csv)

##Now, let's convert an internal dataset into a data table and explore some of
##the functions to work with data
dt_1 <- as.data.table(airquality)
View(dt_1)

##Size of our data set (the same function as the size of a matrix)
dim(dt_1)
##Observations Variables
#Number of rows and columns separately
nrow(dt_1)
ncol(dt_1)

##Quick summary of the dataset
summary(dt_1)

##First land last observations
head(dt_1, 10)
tail(dt_1, 10)
