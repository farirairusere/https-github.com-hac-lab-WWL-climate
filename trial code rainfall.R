# Load necessary libraries
library(ncdf4)
library(ggplot2)
library(dplyr)
library(RNetCDF)
library(raster)

# Open the netCDF file
opendap_url <- "https://tds-proxy.nkn.uidaho.edu/thredds/dodsC/macav2livneh_pr_BNU-ESM_r1i1p1_historical_1950_2005_CONUS_daily_aggregated.nc"

# Use the brick function directly with the URL
pr <- brick(opendap_url)

# Print information about the raster brick
print(pr)

#Define the original points
original_pt <- cbind(c(-116, -117), c(46, 48))

# Adjust the longitudes by subtracting 360
adjusted_pt <- original_pt
adjusted_pt[, 1] <- adjusted_pt[, 1] + 360

# Extract data using the adjusted points
adjusted_ex <- raster::extract(pr, adjusted_pt)

# Check the dimensions of the new extracted data
dim(adjusted_ex)

# View the first few rows of the new extracted data for both points
head(adjusted_ex[1, ])
head(adjusted_ex[2, ])

# Create a data frame for the first point
time <- seq(as.Date("1950-01-01"), by = "day", length.out = ncol(adjusted_ex))
data_point1 <- data.frame(Date = time, Precipitation = adjusted_ex[1, ])
data_point2 <- data.frame(Date = time, Precipitation = adjusted_ex[2, ])

# Extract Year, Month, and Day from Date
data_point1 <- data_point1 %>%
  mutate(Year = as.numeric(format(Date, "%Y")),
         Month = as.numeric(format(Date, "%m")),
         Day = as.numeric(format(Date, "%d")))

data_point2 <- data_point2 %>%
  mutate(Year = as.numeric(format(Date, "%Y")),
         Month = as.numeric(format(Date, "%m")),
         Day = as.numeric(format(Date, "%d")))

# View the first few rows of the updated data frames
head(data_point1)
head(data_point2)

# Plot the time series for the first point
ggplot(data_point1, aes(x = Date, y = Precipitation)) +
  geom_line() +
  ggtitle("Daily Precipitation for Point 1") +
  xlab("Date") +
  ylab("Precipitation (mm)")

# Plot the time series for the second point
ggplot(data_point2, aes(x = Date, y = Precipitation)) +
  geom_line() +
  ggtitle("Daily Precipitation for Point 2") +
  xlab("Date") +
  ylab("Precipitation (mm)")

summary(data_point1$Precipitation)
summary(data_point2$Precipitation)

# Save the data frames to CSV files
write.csv(data_point1, "data_point1.csv", row.names = FALSE)
write.csv(data_point2, "data_point2.csv", row.names = FALSE)

# Check if the files have been created successfully
list.files(pattern = "data_point")

View(data_point1)
View(data_point2)
