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
