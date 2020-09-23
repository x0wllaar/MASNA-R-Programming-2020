                                        #Matrices
##PR1: Creare a 3 rows * 4 cols matrix of 2's. Then change second row, third
##column to NA

mat_1 <- matrix(2, nrow = 3, ncol = 4)
mat_1[2,3] <- NA
mat_1

##PR2: Given 3 vectors, create 2 matrices: where vectors are the columns and
##where vecorts are rows
a <- c(8, 3, 4, 9, 10)
b <- c(5, 9, 7, 0, 2)
c <- c(21, 12, 19, 1, 25)

##Columns
mat_2_c <- cbind(a, b, c)
mat_2_c

##Rows
mat_2_r <- rbind(a, b, c)
mat_2_r

##PR3: Linear regression. Given vector y and matrix X, estimate linear
##regression coefficients using matrix operations
##HINT: in matrix form, the estimates can be computed as (Xt * X) ^ -1 * Xt * Y
##where Xt is a tranpose of X
y <- iris$Sepal.Length %>% unname %>% as.vector() %>% matrix(ncol = 1)
X <- iris[,2:4] %>% unname %>% as.matrix()
X <- cbind(X, rep(1, 150))

lr_coef <- solve(t(X) %*% X) %*% t(X) %*% y
lr_coef

##Check with
summary(lm(Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width + 1, data = iris))

                                        #Lists
##PR4: Given 3 vectors
v_c <- c("A", "B", "C")
v_n <- c(10, 23, 8)
v_l <- c(TRUE, FALSE, TRUE)
##Create a list list_sv out of those vectors
list_sv <- list(v_c, v_n, v_l)
list_sv

##Accessing the list elemnts, display the letter B
list_sv[[1]][2]

##Display the vector v_l
list_sv[[3]]

##Name the elements of the list char, numeric, logical, dispay the element char
names(list_sv) <- c("char", "numeric", "logical")
list_sv$char

##Add the vector
v_f <- c(12.6, 86.5, 3.1415)
##to the list, name it float
list_sv[[length(list_sv) + 1]] <- v_f
names(list_sv)[[length(names(list_sv))]] <- "float"
list_sv

##Add the values "D", 98, TRUE, 2.781 to each of the vectors of the list
list_sv$char[length(list_sv$char) + 1] <- "D"
list_sv$numeric[length(list_sv$numeric) + 1] <- 98
list_sv$logical[length(list_sv$logical) + 1] <- TRUE
list_sv$float[length(list_sv$float) + 1] <- 2.781
list_sv

##PR5: given a string
sem_str1 <- "46;44;8;96;42;51;79;63;46;18;95;64;50;8;77;75;93;81;63;98"
##Convert it to a numeric vector using the built-in R functions and %>% operator
sem_str1 %>% strsplit(split = ";", fixed = TRUE) %>% unlist %>% as.numeric()
