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

png("plot4.png", width=480, height=480)
par(mfrow=c(2,2))

# plot 4.1 (plot 2)
plot(x=power_data[, Date_time], y=power_data[, Global_active_power], 
     type="l", xlab="", ylab="Global Active Power")

# plot 4.2
plot(power_data[, Date_time],powerDT[, Voltage], type="l", xlab="datetime", ylab="Voltage")

# plot 4.3
plot(power_data[, Date_time], power_data[, Sub_metering_1], type="l", xlab="", ylab="Energy sub metering")
lines(power_data[, Date_time], power_data[, Sub_metering_2],col="red")
lines(power_data[, Date_time], power_data[, Sub_metering_3],col="blue")
legend("topright", col=c("black","red","blue"), 
       c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), x.intersp=1, bty="n",
       lty=c(1,1), lwd=c(1,1))

# Plot 4.4
plot(power_data[, Date_time], power_data[,Global_reactive_power], type="l", xlab="datetime", ylab="Global_reactive_power")

dev.off()