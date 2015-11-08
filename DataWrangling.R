RailwaySchedule = read.csv("G:\\One Drive\\OneDrive\\STAT - projects\\GitHub\\irctcSimulation\\Indian railways.csv", header = TRUE)
RailwaySchedule=RailwaySchedule[,c("Train.No.","train.Name","station.Code","Station.Name","Arrival.time","Departure.time")]
names(RailwaySchedule)[names(RailwaySchedule) =="Train.No."] <- "TrainNo"
names(RailwaySchedule)[names(RailwaySchedule) =="Station.Name"] <- "StationName"
names(RailwaySchedule)[names(RailwaySchedule) =="Arrival.time"] <- "ArrivalTime"
names(RailwaySchedule)[names(RailwaySchedule) =="Departure.time"] <- "DepartureTime"
names(RailwaySchedule)[names(RailwaySchedule) =="train.Name"] <- "TrainName"
names(RailwaySchedule)[names(RailwaySchedule) =="station.Code"] <- "StationCode"
colnames(RailwaySchedule)

#attach(RailwaySchedule)
ScAndBzaRails = RailwaySchedule[trimws(RailwaySchedule$StationCode)=="SC" | trimws(RailwaySchedule$StationCode)=="BZA",]
#detach(RailwaySchedule)
#attach(ScAndBzaRails)
#detach(ScAndBzaRails)
dim(RailwaySchedule)
dim(ScAndBzaRails)
colnames(ScAndBzaRails)

ScAndBzaRails[,c(1)]=trimws(ScAndBzaRails[,c(1)])
ScAndBzaRails[,c(2)]=trimws(ScAndBzaRails[,c(2)])
ScAndBzaRails[,c(3)]=trimws(ScAndBzaRails[,c(3)])
ScAndBzaRails[,c(4)]=trimws(ScAndBzaRails[,c(4)])
ScAndBzaRails[,c(5)]=trimws(ScAndBzaRails[,c(5)])
ScAndBzaRails[,c(6)]=trimws(ScAndBzaRails[,c(6)])

ScAndBzaRails[ScAndBzaRails$StationCode=="SC",]

ScAndBzaRails[,c('TrainNo')]=substr(ScAndBzaRails[,c('TrainNo')], 2, nchar(ScAndBzaRails[,c('TrainNo')])-1)
ScAndBzaRails[,c('ArrivalTime')]=substr(ScAndBzaRails[,c('ArrivalTime')], 2, nchar(ScAndBzaRails[,c('ArrivalTime')])-1)
ScAndBzaRails[,c('DepartureTime')]=substr(ScAndBzaRails[,c('DepartureTime')], 2, nchar(ScAndBzaRails[,c('DepartureTime')])-1)
head(ScAndBzaRails)

sapply(ScAndBzaRails, class)
install.packages(chron)
library(chron)
#ScAndBzaRailsCopy=ScAndBzaRails

ScAndBzaRails[,c('ArrivalTimeStamp')]=chron(times=ScAndBzaRails[,c('ArrivalTime')])
ScAndBzaRails[,c('DepartureTimeStamp')]=chron(times=ScAndBzaRails[,c('DepartureTime')])
ScAndBzaRails[,c('ArrivalTimeMinutes')]=as.numeric(ScAndBzaRails[,c('ArrivalTimeStamp')])*24*60
ScAndBzaRails[,c('DepartureTimeMinutes')]=as.numeric(ScAndBzaRails[,c('DepartureTimeStamp')])*24*60
head(ScAndBzaRails)

ScAndBzaRails=ScAndBzaRails[ , !names(ScAndBzaRails) %in% c("ArrivalTime","DepartureTime")]
names(ScAndBzaRails)

ScAndBzaRails[,c('ServiceTimeMinutes')]=ScAndBzaRails[,c('DepartureTimeMinutes')]-ScAndBzaRails[,c('ArrivalTimeMinutes')]
dim(ScAndBzaRails)
ScAndBzaRails=ScAndBzaRails[ScAndBzaRails$ServiceTimeMinutes>0,] # removing invalid service times
#only one calendar day are considered

ScaRails=ScAndBzaRails[ScAndBzaRails$StationCode=='SC',]
BzaRails=ScAndBzaRails[ScAndBzaRails$StationCode=='BZA',]

ScBzaRouteTrainNos=intersect(ScaRails$TrainNo, BzaRails$TrainNo)
ScAndBzaRails[,c("IsTrainInRoute")]=0
ScAndBzaRails[ScAndBzaRails$TrainNo %in% ScBzaRouteTrainNos,c("IsTrainInRoute")]=1
ScAndBzaRails


ScBzaRouteTrainsData=ScAndBzaRails[ScAndBzaRails$IsTrainInRoute==1,]
ScBzaTrainsonlyInOneStation = ScAndBzaRails[ScAndBzaRails$IsTrainInRoute==0,]
dim(ScBzaRouteTrainsData)
dim(ScBzaTrainsonlyInOneStation)
install.packages("xlsx")
library(xlsx) #load the package
write.xlsx(ScBzaRouteTrainsData,"G:\\One Drive\\OneDrive\\STAT - projects\\GitHub\\irctcSimulation\\ScBzaRouteTrainsData.xlsx", sheetName = "Sheet1", row.names = FALSE)

write.xlsx(ScBzaTrainsonlyInOneStation,"G:\\One Drive\\OneDrive\\STAT - projects\\GitHub\\irctcSimulation\\ScBzaTrainsonlyInOneStation.xlsx",sheetName = "Sheet1", row.names = FALSE)

#make service times > 30 = mod and correct arrival times to reflect the same
#