## Distribution of Failure and Success

fail <- c(seq(0.05, 0.5, by = 0.05), rep(0.5, 9)) # independent room probabilities of failure

succeed <- 1 - fail # independent room probabilities of success

fail_at_room <- numeric(19)
fail_at_room[1] <- 0.05
for (i in 1:18) {
  succeed_room <- cumprod(succeed[1:i]) # gives the cumulative probability of room success
  succeed_number <- rev(succeed_room)[1] # gives the final number
  fail_at_room[i + 1] = succeed_number * fail[i + 1] # what is the probability we succeed all prior rooms, but fail at this one?
} 

success <- 1 - c(seq(0.05, 0.5, by = 0.05), rep(0.5, 9))
success_at_room <- numeric(19)
success_at_room[1] <- 0.95 
for (i in 1:18) {
  success_at_room[i + 1] <- rev(cumprod(success[1:(i+1)]))[1] # what is the probability we succeed this room AND have succeeded all rooms prior? 
} 

data_frame <- data.frame("Room" = 1:19, "Independent Room Failure" = fail, "Distribution of Room Failure" = round(fail_at_room, 10), "Room Success" = round(success_at_room, 10), check.names = F)



## Chi-Squared Goodness of Fit Test

data <- c(2, 2, 5, 3, 5, 3, 6, 8, 3, 8, 5, 5, 6, 4, 6, 4, 2, 7, 6, 8, 6, 5, 7, 4, 5, 2, 10, 6, 7, 4, 2, 4, 3, 6, 3, 9, 8, 3, 5, 8, 6) # which room i failed at, n = 41
table_data <- unname(table(data))

observed <- c(0, table_data, rep(0, 9))

expected <- round(fail_at_room, 10) * 41

chisq_value <- sum((observed - expected)^2 / expected)

p_value <- pchisq(chisq_value, 40, lower.tail = F)
