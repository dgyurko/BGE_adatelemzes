# Swirl package
install.packages("swirl")
library(swirl)

## To start
swirl()


bye()

# Assignment operator
vec <- 1:5
2:6 -> vec

mean(x = vec)

# Reference vs value types
x <- 2
y <- x
x <- 5

# Data types
x <- c(1.2, 2.3, 3.5)
typeof(x)
class(x)

y <- c(3L, 4L, 5L)
typeof(y)
class(y)

# Character type
z <- c(1L, 3, "asd")

'hello'
c('hello', "world")

family_gender <- factor(c("female", "male", "female", "male"))
family_gender[1] <- "asdas"

# Logical type
TRUE
FALSE
T
F

x <- c(TRUE, FALSE, TRUE)
y <- 1:10
y > 5
y[y > 5]

# Vectorization
1:3 + 2:4
1:5 + 1

1:5 + 1:2

# Vectorization test
if(!require(microbenchmark)) install.packages("microbenchmark")
library(microbenchmark)

num_vec <- 1:1000

microbenchmark(
  vectorization = num_vec + 1,
  loop = for (i in 1:length(num_vec)) num_vec + 1,
  times = 10
)

if (TRUE) {
  print("TRUE")
}

is_greater_than_5 <- function(x) {
  if (x > 5) {
    print("> 5")
  } else {
    print("<= 5")
  }
}

is_greater_than_5(3)
is_greater_than_5(10)

is_greater_than_5(c(2, 4, 10))

is_greater_than_5_v2 <- function(x) {
  ifelse(x > 5, TRUE, FALSE)
}

is_greater_than_5_v2(c(2, 4, 10))