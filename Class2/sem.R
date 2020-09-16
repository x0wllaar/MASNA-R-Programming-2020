                                        #Matrices
##PR1: Creare a 3 rows * 4 cols matrix of 2's. Then change second row, third
##column to NA

##PR2: Given 3 vectors, create 2 matrices: where vectors are the columns and
##where vecorts are rows
a <- c(8, 3, 4, 9, 10)
b <- c(5, 9, 7, 0, 2)
c <- c(21, 12, 19, 1, 25)

##PR3: Linear regression. Given vector y and matrix X, estimate linear
##regression coefficients using matrix operations
##HINT: in matrix form, the estimates can be computed as (Xt * X) ^ -1 * Xt * Y
##where Xt is a tranpose of X
y <- iris$Sepal.Length %>% unname %>% as.vector() %>% matrix(ncol = 1)
X <- iris[,2:4] %>% unname %>% as.matrix()
X <- cbind(X, rep(1, 150))

##Check with
summary(lm(Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width + 1, data = iris))

                                        #Lists
##PR4: Given 3 vectors
v_c <- c("A", "B", "C")
v_n <- c(10, 23, 8)
v_l <- c(TRUE, FALSE, TRUE)
##Create a list list_sv out of those vectors

##Accessing the list elemnts, display the letter B

##Display the vector v_l

##Name the elements of the list char, numeric, logical, dispay the element char

##Add the vector
v_f <- c(12.6, 86.5, 3.1415)
##to the list, name it float

##Add the values "D", 98, TRUE, 2.781 to each of the vectors of the list

##PR5: given a string
sem_str1 <- "46;44;8;96;42;51;79;63;46;18;95;64;50;8;77;75;93;81;63;98"
##Convert it to a numeric vector using the built-in R functions and %>% operator

                                        #Working with data!
##We have a file with 2012 presidential election results in Russia
elec_file <- "47130-8314.csv"

##Load this file into R (data.table)
##The file is UTF-8 encoded and contains cyrillic, expect problems on Windows
##Fread accepts "encoding" paramenter
all_data <- fread(elec_file, encoding = "UTF-8")

##Select columns "kom1", "kom2", "kom3", "1", "9", "10", "19", "20", "21", "22", "23" from the data
##Rename them to "region", "tik", "uik", "total", "invalid", "valid", "Zh", "Zu", "Mi", "Pr", "Pu"

##Add a variable called turnout (valid + invalid) (total number of voters)
##Add a variable called turnout_p (turnout / total * 100) (voter turnout percentage)

##Remove Baikonur and voters outside Russia from the data
##"Территория за пределами РФ"
##"Город Байконур (Республика Казахстан)"

##Remove rows with missing data

##Display descriptives of the data

##Aggregate columns turnout, total, invalid, valid, Zh, Zu, Mi, Pr, Pu by region (by summing them)
##Recompute turnout percentage for each region

##Create a factor variable with the region type
##“область”, “республика”, “край”, “округ”, “город”
##"oblast", "respublika", "krai", "okrug", "gorod"
##HINT: Use grepl and data.table subsetting

##Display a (fancy) barplot with the number of regions of different types

##Display a pie char with the same information

##Display a (fancy) histogram of turnout percentage

##Compute vote percentage for each of the candidates (number_of_voted / valid)

##Display a boxplot of percentage vote for Zuganov

##Display a violin plot of percentage vote for Mironov

##Display a density plot of valid percentage

##Display a scatterplot where X = percentage vote for Putin and Y = percentage turnout
