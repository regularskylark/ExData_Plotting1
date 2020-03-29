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

# convert string date to R date
power_data[, Date := lapply(.SD, as.Date, "%d/%m/%Y"), .SDcols = c("Date")]

# select correct dates
power_data <- power_data[(Date >= "2007-02-01") & (Date <= "2007-02-02")]

png("plot1.png", width=480, height=480)

# plot 1
hist(power_data[, Global_active_power], main="Global Active Power", xlab="Global Active Power (kiloWatts)", ylab="Frequency", col="Red")

dev.off()