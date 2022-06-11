#refomat og data

library(here)
library(tidyverse)
library(RODBC)
library(readxl)
library(dplyr)

#format data to resemble each other
oc<-read_excel(here("data/CameraTraps_AllDeadDeer.xlsx"))%>%
  select(Site_ID, Carcass_Type, Study_Area, UTM_Zone, UTM_E, 
         UTM_N, First_Photo_Date, Last_Photo_Date)
colnames(oc)<-c("cam", "carcass", "study_area", "utm.z", "utm.e",
                "utm.n", "first_photo", "last_photo")

o20<-read_excel(here("data/CougarClusterData_Winter2020.xlsx"))%>%
  subset(CameraPlacement=="CSU")%>%
  select(Cluster_ID, Season, HabitatType, 
         DistanceToTrailMeters)
o20$Cluster_ID<-gsub("-CSU", "", as.character(o20$Cluster_ID))
colnames(o20)<-c("cam", "season", "habitat", "trail.m")

o17<-read_excel(here("data/CougarClusterData_2017-2019.xlsx"))%>%
  subset(CameraPlacement=="CSU")%>%
  select(Cluster_ID, Season, HabitatType, 
         DistanceToTrailMeters)
o17$Cluster_ID<-gsub("-CSU", "", as.character(o17$Cluster_ID))
o17$Cluster_ID<-gsub("-A", "", as.character(o17$Cluster_ID))
colnames(o17)<-c("cam", "season", "habitat", "trail.m")

#bind all data into master dataset
o17.20<-bind_rows(o17,o20)
o<-left_join(oc,o17.20)
write.csv(o,here("data/dir.csv"))

#check with online repository
online<-read_excel(here("data/ImageProcessingLog.xlsx"))%>%
  mutate(cam=ClusterID)%>%
  select(cam)
check<-anti_join(o,online,by="cam") # 2 missing cameras

#bind distance data
ogdat<-read.csv("data/dir.csv")
distance<-read_excel(here("data/cam_distance.xlsx"))%>%
  select(cam,building_id,building_distance,road_id,road_distance)
cam_distance<-left_join(ogdat, distance, by="cam")

#bind roads data
road<-read_excel(here("data/roads.xlsx"))%>%
  select(OBJECTID, ROAD_STATUS_LBL, ROAD_USGS_CLASS_LBL)
colnames(road)<-c("road_id","road_status","road_class")
cam_complete<-left_join(cam_distance, road, by="road_id")
