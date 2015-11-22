# Merges the training and the test sets to create one data set
    features <- read.table("features.txt")
    x.train <- read.table("./train/X_train.txt")
    y.train <- read.table("./train/y_train.txt")
    s.train <- read.table("./train/subject_train.txt")
    x.test <- read.table("./test/X_test.txt")
    y.test <- read.table("./test/y_test.txt")
    s.test <- read.table("./test/subject_test.txt")    
    dataset <- rbind(x.train, x.test)
    
# Extracts only the measurements on the mean and standard deviation for each measurement and 
# appropriately labels the data set with descriptive variable names
    dataset <- dataset[,features[unlist(lapply(features[,2], function(x) grepl("mean|std", x))),1]]
    names(dataset) <- features[unlist(lapply(features[,2], function(x) grepl("mean|std", x))),2]
    dataset <- cbind(rbind(s.train, s.test), dataset, rbind(y.train, y.test))
    names(dataset)[1] <- "subject"; names(dataset)[length(names(dataset))] <- "activity"
    rm(features, s.test, s.train, x.test, x.train, y.test, y.train)
    
# Uses descriptive activity names to name the activities in the data set
    activity_labels <- read.table("activity_labels.txt")
    names(activity_labels) <- c("activity", "activity_labels")
    dataset <- merge(dataset, activity_labels, all.x=T)
    dataset <- subset(dataset, select=-activity)
    
# Creates a second, independent tidy data set with the average of each variable 
# for each activity and each subject
    tidydata <- aggregate(. ~ subject + activity_labels, dataset, mean)
    
