### 1. Készíts egy vektort, ami 30-tól 50-ig tartalmaz elemeket. Számítsd ki az elemek minimumát, maximumát, átlagát, összegét és mediánját.

`summary`: Minimum, kvartilisek, átlag, maximum

```{r}
vec <- 30:50
summary(vec)
min(vec)
max(vec)
mean(vec)
sum(vec)
median(vec)
```

### 2. Készíts egy vektort, ami 0-tól 100-ig 5-ösével tartalmaz elemeket (0, 5, 10, 15, ..., 100)

`?seq`

```{r}
seq(from = 0, to = 100, by = 5)
```

### 3. Készíts egy vektort, ami 10 random egész számot tartalmazzon

Függvény leírás: `?sample`

- `x`: Vektor, amiből random választunk
- `size`: Hány elemet választunk ki
- `replace`: Szerepelhet-e ugyanaz az érték 2-szer

```{r}
sample(x = 1:100, size = 10, replace = TRUE)
```

### 4. Hogyan tudod elérni, hogy mindig ugyanazokat a random számokat generálja egy script?

A `set.seed` függvénnyel. Ha ugyanazt a számot adjuk meg, pl.: 123, akkor mindig ugyanazokat a számokat kapjuk vissza. Ez azért fontos, mert ezáltal megismételhető lesz egy script.

```{r}
set.seed(123)
sample(x = 1:100, size = 10, replace = TRUE)

set.seed(123)
sample(x = 1:100, size = 10, replace = TRUE)
```

### 5. Készíts egy karakter vektort, ami a "category1", "category2", ..., "category150" értékeket tartalmazza

Karakterek összefűzése: `paste`, vagy `paste0`.

```{r}
paste0("category", 1:150)
```

### 6. Készíts 3 tetszőleges vektort, majd fűzd őket össze egy vektorba.

`c`: combine/concatenate. `...` argumentum azt jelenti, hogy bármennyi elem megadható.

```{r}
vec_a <- 1:2
vec_b <- 3:4
vec_c <- 5:6
c(vec_a, vec_b, vec_c)

```

### 7. Fűzd össze egy vektor összes elemét egy értékké (;-vel elválasztva)

`collapse` argumentum: "an optional character string to separate the results"

```{r}
paste0(c("a", "b", "c", "d"), collapse = ";")
```

### 8. Hogyan tudod egy vektorból az összes egyedi értéket egyszer megtartani?

```{r}
vec <- c("a", "a", "b", "b", "c")
unique(vec)

```

### 9. Írj egy függvényt, ami egy tetszőleges vektor minimumát és maximumát adja vissza egy vektorban.

```{r}
minmax <- function(x) {
  c(min(x), max(x))
}
minmax(c(1, 2, 5))
```


### 10. Válaszd ki az 1:100 vektor első 5 elemét, az utolsó 5 elemét, az első és utolsó 5 elemet egyszerre.

`head`: első n elem
`tail`: utolsó n elem

```{r}
head(vec, 5)
tail(vec, 5)
c(head(vec, 5), tail(vec, 5))
```

Alternatív megoldás indexekkel:

```{r}
vec <- 1:100
vec[1:5]
vec[seq(from = length(vec) - 5, to = length(vec))]
vec[c(1:5, seq(from = length(vec) - 5, to = length(vec)))]
```

### 11. Válaszd ki az 15:30 vektor 20-nál nagyobb elemeit.
```{r}
vec <- 15:30
vec[vec > 20]
```

### 12. Mentsd el memóriába az 1:10 vektort. A vektor 5.ik elemét írd felül, az értéke legyen: 2. Minden páros indexű elem értékét oszd el 2-vel.

Páros elem: `seq_along(vec) %% 2 == 0`

`seq_along`: vektor elemeinek az indexe. Pl. `seq_along(c("a", "b", "c"))`: `c(1, 2, 3)`
`%%`: maradékos osztás (modulo)
`ifelse`: vektorizált elágazás

```{r}
vec <- 1:10
vec[5] <- 2
ifelse(seq_along(vec) %% 2 == 0, vec / 2, vec)
```

### 13. Adott az 1:3 vektor, fűzz hozzá 1-1 0 elemet az elejére és a végére (0, 1, 2, 3, 0)
```{r}
vec <- 1:3
c(0, vec, 0)
```

### 14. Szúrj be egy elemet a 1:5 vektor 2 és 3 elemei közé.
```{r}
vec <- 1:5
c(vec[1:2], 999, vec[3:5])
```


### 15. Hány elemből áll az 1:5 vektor?
```{r}
length(1:5)
```

### 16. Készíts egy üres vektort, majd adj hozzá 2 tetszőleges értéket.
```{r}
vec <- vector()
vec[1] <- "hello"
vec[2] <- "hi"
```

### 17. Mi történik, ha különböző hosszúságú vektorokat adunk össze?

Különböző hosszúságú vektorok esetén a rövidebb vektort kiegészíti az R a hosszabb vektor hosszára. Amennyiben ez nem többszöröse, akkor warning-ot dob.

### 18. Ismételd meg egy vektor elemeit 10-szer. (pl.: 1:3, 1,2,3,1,2,3,1,2,3, ...)

```{r}
vec <- 1:3
rep(vec, times = 10)
```

### 19. Ismételd meg egy vektor elemenként 5-ször. (pl.: 1:3, 1,1,1,1,1,2,2,2,2,2,...)

```{r}
rep(vec, each = 10)
```

### 20. Szerepel-e a "setosa" az iris$Species vektorban?

`%in%` operátor: szerepelnek-e egy vektor értékei egy másik vektorban

```{r}
"setosa" %in% iris$Species
```

### 21. Generálj egy 1 elemű logikai vektort, ami `TRUE` értékkel rendelkezzen, ha az iris$Sepal.Length minden értéke kisebb mint 10, 
egyéb esetben `FALSE` értéke legyen.

`all`: TRUE, ha egy logikai vektor minden eleme igaz

```{r}
all(iris$Sepal.Length < 10)
```

### 22. Írj egy függvényt `any_greater_than_5` néven, ami `TRUE` értéket ad vissza, ha a vektor tartalmaz legalább egy 5-nél nagyobb értéket, 
egyéb esetben `FALSE` értéket.

`any`: TRUE, ha egy logikai vektor legalább egyik eleme igaz

```{r}
any_greater_than_5 <- function(x) {
  any(x > 5)
}
```

### 23. A 10:20 vektor melyik indexű elemei nagyobbak 15-nél? Listázd ki az elemeket

```{r}
vec <- 10:20
idx <- which(vec > 15)
vec[idx]
```
