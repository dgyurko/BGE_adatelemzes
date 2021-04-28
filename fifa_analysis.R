library(data.table)
library(magrittr)
library(stringr)

fifa_data <- fread("data/FIFA19.csv", encoding = "UTF-8")

# Clustering
abilities <- c("Crossing", "Finishing", "HeadingAccuracy", "ShortPassing", "Volleys", "Dribbling", "Curve", "FKAccuracy", 
               "LongPassing", "BallControl", "Acceleration", "SprintSpeed", "Agility", "Reactions", "Balance", "ShotPower", 
               "Jumping", "Stamina", "Strength", "LongShots", "Aggression", "Interceptions", "Positioning", "Vision", "Penalties", 
               "Composure", "Marking", "StandingTackle", "SlidingTackle", "GKDiving", "GKHandling", "GKKicking", "GKPositioning", "GKReflexes")

cluster_data <- fifa_data[, c("Name", "Position", abilities), with = FALSE]
cluster_data <- na.omit(cluster_data)

fifa_clusters <- kmeans(cluster_data[, -1:-2], centers = 6)
cbind(cluster_data, cluster_no = fifa_clusters$cluster)[cluster_no == 5]
cbind(cluster_data, cluster_no = fifa_clusters$cluster)[cluster_no == 5 & Position != "GK"]

# Search for a GK
fifa_clusters <- kmeans(cluster_data[Position == "GK", (ncol(cluster_data) - 4):ncol(cluster_data)], centers = 6)
df <- cbind(cluster_data[Position == "GK"], cluster_no = fifa_clusters$cluster)[cluster_no == 1]
merge(
  x = df,
  y = fifa_data[, .(Name, Age, Value, Wage)],
  by = "Name",
  all.x = TRUE
)

# PCA --------------------------------------------------------------------------
#install.packages("corrplot")
library(corrplot)
corrplot::corrplot(cluster_data[, -1:-2])
source("http://www.sthda.com/upload/rquery_cormat.r")
rquery.cormat(cluster_data[, -1:-2])

cor(cluster_data[, -1:-2])

# Conduct PCA
fifa_pca <- prcomp(cluster_data[, -1:-2], center = TRUE, scale. = TRUE)
summary(fifa_pca)

# Check correlation of principal components
rquery.cormat(fifa_pca$x)

# Screeplot
screeplot(fifa_pca, type = "l", npcs = 15, main = "Screeplot of the first 10 PCs")
abline(h = 1, col="red", lty=5)
legend("topright", legend=c("Eigenvalue = 1"),
       col=c("red"), lty=5, cex=0.6)

# Plot cumulative variance
cumpro <- cumsum(fifa_pca$sdev^2 / sum(fifa_pca$sdev^2))
plot(cumpro[0:15], xlab = "PC #", ylab = "Amount of explained variance", main = "Cumulative variance plot")
abline(v = 6, col="blue", lty=5)
abline(h = 0.88759, col="blue", lty=5)
legend("topleft", legend=c("Cut-off @ PC6"),
       col=c("blue"), lty=5, cex=0.6)

# Decision Trees ---------------------------------------------------------------
library(rpart)
library(rpart.plot)

fifa_data[, Value2 := str_remove_all(Value, pattern = "[€]") %>% 
            str_replace_all(pattern = "K", replacement = "*1000") %>% 
            str_replace_all(pattern = "M", replacement = "*1000000")]
fifa_data[, Value2 := unlist(lapply(fifa_data$Value2, function(x) eval(parse(text = x))))]

## Split into train/test/validation
train_ratio <- 0.8
train_idx <- sample(x = seq_len(nrow(fifa_data)), size = floor(nrow(fifa_data) * train_ratio))
data_train <- fifa_data[train_idx, c(abilities, "Value2"), with = FALSE]
data_test <- fifa_data[-train_idx, c(abilities, "Value2"), with = FALSE]

fifa_tree <- rpart(Value2 ~ . , 
                   data = data_train,
                   method  = "anova",
                   control = list(minsplit = 11, maxdepth = 8))
summary(fifa_tree)
rpart.plot(fifa_tree)

tree_pred <- predict(fifa_tree, newdata = data_test)

# Random Forest
library(randomForest)
fifa_rf <- randomForest(Value2 ~ ., data = na.omit(data_train), ntree = 100, importance = TRUE)
fifa_rf

varImpPlot(fifa_rf)

pred_randomForest <- predict(fifa_rf, newdata = data_test)
tmp <- cbind.data.frame(
  actual = data_test$Value2,
  pred = pred_randomForest,
  diff = data_test$Value2 - pred_randomForest
)

fifa_rf_rmse <- mltools::rmse(preds = pred_randomForest, actuals = data_test$Value2, na.rm = TRUE)

ggplot(tmp, aes(x = actual, y = pred)) +
  #geom_point() +
  geom_bin2d() +
  geom_smooth(method = 'lm') +
  scale_x_log10() +
  scale_y_log10() +
  theme_minimal()