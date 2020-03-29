library("data.table")

# comment these lines out if wd already local or not run from source()
thisdir <- getSrcDirectory(function(x) {x})
setwd(thisdir)

# load, unzip data into data directory if needed 
dir.create(file.path(".", "data"), showWarnings = FALSE)
data_filename = "data/data.zip"
if (!file.exists(data_filename)){
  data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file( data_url, destfile=data_filename)
  unzip("data/data.zip", exdir = "./data")
}
data_dir <- "./data"
power_data <- fread(file.path(data_dir, "household_power_consumption.txt"), na.strings="?")

# convert string date/time to R date
power_data$Date_time <- paste(power_data$Date, power_data$Time)
power_data[, Date_time := lapply(.SD, as.POSIXct, format = "%d/%m/%Y %H:%M:%S"), .SDcols = c("Date_time")]

# select correct dates
power_data <- power_data[(Date_time >= "2007-02-01") & (Date_time < "2007-02-03")]

png("plot2.png", width=480, height=480)

# plot 2
plot(x=power_data[, Date_time], y=power_data[, Global_active_power], 
     type="l", xlab="", ylab="Global Active Power (kilowatts)")

dev.off()
