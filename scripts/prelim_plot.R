#preliminary plots

library(ggplot2)
library(ggpubr)

ggplot(cam_complete)+
  geom_point(aes(x=elevation,y=building_distance),col="red")+
  geom_point(aes(x=elevation,y=road_distance),col="blue")+
  geom_smooth(aes(x=elevation,y=building_distance),
              method=lm, se=FALSE, linetype="dashed", 
              size=0.5, color="red")+
  geom_smooth(aes(x=elevation,y=road_distance),
              method=lm, se=FALSE, linetype="dashed", 
              size=0.5, color="blue")+
  ylab("Distance (m)")+
  xlab("Elevation (m)")
