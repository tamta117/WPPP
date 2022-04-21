#refomat og data

library(here)
library(tidyverse)
library(RODBC)
library(readxl)

oc<-read_excel(here("data/CameraTraps_AllDeadDeer.xlsx"))%>%
  select(Site_ID, Carcass_Type, Study_Area, UTM_Zone, UTM_E, 
         UTM_N, First_Photo_Date, Last_Photo_Date)
colnames(oc)<-c("cam", "carcass", "study_area", "utm.z", "utm.e",
                "utm.n", "first_photo", "last_photo")

o20<-read_excel(here("data/CougarClusterData_Winter2020.xlsx"))%>%
  subset(CameraPlacement=="CPU")%>%
  select(Cluster_ID, Season, HabitatType, BurnCategory, 
         DistanceToTrailMeters)
o20$Cluster_ID<-gsub("-CPU", "", as.character(o20$Cluster_ID))
colnames(o20)<-c("cam", "season", "habitat", "burn", "trail.m")

o17<-read_excel(here("data/CougarClusterData_2017-2019.xlsx"))%>%
  subset(CameraPlacement=="CPU")%>%
  select(Cluster_ID, Season, HabitatType, BurnCategory, 
         DistanceToTrailMeters)
o17$Cluster_ID<-gsub("-CPU", "", as.character(o17$Cluster_ID))
colnames(o17)<-c("cam", "season", "habitat", "burn", "trail.m")

o17.20<-bind_rows(o17,o20)
o<-left_join(oc,o17.20)
write.csv(o,here("data/dir.csv"))
