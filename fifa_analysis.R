library(data.table)

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
