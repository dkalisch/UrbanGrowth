# Combine BIP and area data
test <- join(BIP, df, by = 'region', type = 'inner')

# Calculate the density of a county
test$density <- (test$male + test$female) / test$area

# Calculate the GDP per density
test$densBIP <- test$value / test$density

# Z-Transformation for the density / GDP data
test$densBIPnrom <- scale(test$densBIP)