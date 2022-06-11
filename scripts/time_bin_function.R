library(dplyr)
library(lubridate)

coug_bin<-function(fname){
cam<-read.csv(fname)%>%
  unite("date_time", Date:Time, remove=FALSE, sep=" ")
cam$date_time2<-parse_date_time(cam$date_time, orders = c('ymd HMS','dmy HMS'))
cam.30<-cam%>%
  mutate(time.bin=format(ceiling_date(date_time2, "30 mins"), "%Y%m%d %H%M"))%>%
  mutate(end.date=cam[1,38]+2592000)%>%
  subset(date_time2 <= end.date)%>%
  mutate(COUG=ifelse(Species1=="Cougar",1,0))%>%
  filter(COUG==1)%>%
  distinct(time.bin,.keep_all = TRUE)%>%
  group_by(ClusterID, COUG)%>%
  summarize(nobs=n())
}

#test function
test<-coug_bin("data/cam/MVC202F-2713-Reconyx_Checked.csv")
