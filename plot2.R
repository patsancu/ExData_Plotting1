# ===============
# Data processing
# ===============
# Needed data is between 66638, 69517 rows
# 66638 31/1/2007 ends
# 68077 1/1/2007 ends
# 69517 2/2/2007 ends
data <- read.csv2(file="household_power_consumption.txt", skip = 66637, nrows = 69517 - 66637, header = F )
head(data) # debugging purposes
tail(data) # debugging purposes
#Name correctly variables
names(data) <- c("Date", "Time", "Global_active_power", 
                 "Global_reactive_power",
                 "Voltage",
                 "Global_intensity",
                 "Sub_metering_1",
                 "Sub_metering_2",
                 "Sub_metering_3")
data$Date <- strptime(data$Date, format="%d/%m/%Y")

# Join the date with the hour 
data$DateTime <- strftime(paste(data$Date,data$Time), format="%Y-%m-%d %H:%M:%S")
# and convert it
data$DateTime <- as.POSIXlt(data$DateTime)

# ============
# File opening
# ============
png(filename = "plot2.png", width = 480, height = 480)

with(data, {
    
    plot(as.POSIXlt(DateTime), 
         as.numeric(as.character(Global_active_power)), 
         type = "l",
         xlab ="Date",
         ylab = "Global active power (kilowatts)") # axis at 4-hour intervals.
    # now label every hour on the time axis
    plot(as.POSIXlt(DateTime), as.numeric(as.character(Global_active_power)), type = "l", 
         xlab ="Date",
         ylab = "Global active power (kilowatts)",
         xaxt = "n")
    r <- as.POSIXct(round(range(as.POSIXlt(DateTime)), "days"))
    axis.POSIXct(1, at = seq(r[1], r[2], by = "day"), format = "%a")
})

#Explicitly turns off the device
dev.off()