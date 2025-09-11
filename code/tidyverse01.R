library(tidyverse)

set.seed(123)

iris_sub <- as_tibble(iris) %>% 
  group_by(Species) %>% 
  sample_n(3) %>% 
  ungroup()

print(iris_sub)

#Single match ==
filter(iris_sub, Species == "virginica")

#Multiple match %in%
filter(iris_sub, Species %in% c("virginica", "versicolor"))

#Except !=
filter(iris_sub, Species != "virginica")

#Except multiple !=
filter(iris_sub, !(Species %in% c("virginica", "versicolor")))

#Greater than >
filter(iris_sub, Sepal.Length > 5)

#Greater than and equal to >=
filter(iris_sub, Sepal.Length >= 5)

#less than <
filter(iris_sub, Sepal.Length < 5)

#less than and equal to <=
filter(iris_sub, Sepal.Length <= 5)

#Multiple conditions (AND) & (or ,)
# Sepal.Length is less than 5 AND Species equals "setosa"
filter(iris_sub,
       Sepal.Length < 5 & Species == "setosa")

# same: "," works like "&"
filter(iris_sub,
       Sepal.Length < 5, Species == "setosa")

#Multiple conditions (OR) |
#Either Sepal.Length is less than 5 OR Species equals "setosa"
filter(iris_sub,
       Sepal.Length < 5 | Species == "setosa")

#Increasing/ascending order
arrange(iris_sub, Sepal.Length)

#Decreasing/descending order
arrange(iris_sub, desc(Sepal.Length))

#Exercise
#1
iris_sub

filter(iris_sub, Sepal.Width > 3.0 )
