#Conditionals and loops
#FizzBuzz again!

#Print numbers from 1 to 100, if the number is divisible by 3, print Fizz
#instead, if the number is divisible by 5, print Buzz, if by both, print
#FizzBuzz
#Use loops and coniditionals!

for (n in 1:100){
  if((n %% 3 == 0) & (n %% 5 == 0)){
    print("FizzBuzz")
    next
  }
  if(n %% 3 == 0){
    print("Fizz")
    next
  }
  if(n %% 5 == 0){
    print("Buzz")
    next
  }
  print(n)
}

#Make a function that will compute the nTh fibonacci number
#1 1 2 3 5 8 13 21... each number is the sum of the 2 previous ones

#Using recursion

fib.r <- function(n){
  if((n == 1) | (n == 2)){
    return(1)
  }
  return(fib.r(n - 2) + fib.r(n - 1))
}

#Using loops

fib.l <- function(n){
  if((n == 1) | (n == 2)){
    return(1)
  }
  pn2 <- 1
  pn1 <- 1
  n <- n - 2
  while(n > 0){
    nn <- pn2 + pn1
    pn2 <- pn1
    pn1 <- nn
    n <- n - 1
  }
  return(pn1)
}

#Using this function (in an inefficient manner), make a vector of first 50
#fibonacci numbers.

fib.list <- 1:50 %>% sapply(fib.l)

#Then estimate the ratios between consecutive numbers (this can be both done
#with loops and by vector/matrix manipulation)

#Loops
c.ratios <- c()
for (n in 2:length(fib.list)){
  ratio <- fib.list[n] / fib.list[n - 1]
  c.ratios[n - 1] <- ratio
}

#Vectors
c.ratios.v <- fib.list[2:length(fib.list)] / fib.list[1:length(fib.list)-1]

#Check if they are the same
prod(c.ratios == c.ratios.v) %>% as.logical()

#Plot this vector as a line
plot(y = c.ratios.v, x = 1:49, type = "l")
