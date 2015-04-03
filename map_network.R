#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#*     Melbourne public transit                                        *
#*  2015-04-02                                                         *
#*                                                                     *
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#*     Load packages
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
library(ggplot2)
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#*       Read and prepare data
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
fulldata.shapes <- do.call("rbind",
                           lapply(list.files(path = "X:/transit/melb",
                                             pattern = "shapes.txt",
                                             recursive = TRUE,
                                             full.names = TRUE),
                                  FUN = function(xfiles) {
                                    xdat <- read.csv(xfiles,
                                             header=TRUE)
                                    xdat$stream <- xfiles
                                    return(xdat)
                                    }))
#name of first column seems messed up :( so correct this
names(fulldata.shapes) <- c("shape_id", "shape_pt_lat", "shape_pt_lon",
                            "shape_pt_sequence", "shape_dist_traveled",
                            "stream")
fulldata.shapes$stream <- as.factor(fulldata.shapes$stream)
#recoding factors
levels(fulldata.shapes$stream) <- c("Metropolitan Train",
                                    "Metropolitan Tram",
                                    "Metropolitan Bus")
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#*       Mapping
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#we're only plotting the routes so just the shapes file will do
plotmap <- ggplot() +
  geom_path(data=fulldata.shapes,
            aes(shape_pt_lon, shape_pt_lat, group=shape_id, colour=stream),
            size=.3, alpha=.05)  +
  scale_colour_manual(values = c("firebrick3","chartreuse", "deepskyblue"))
plotmap + 
#   ylim(-38.2, -37.5) +
#   xlim(144.6, 145.6) +
  theme(plot.background = element_rect(fill = "black", colour = NA),
        panel.background = element_rect(fill = "black", colour = NA),
        title = element_text(colour="gray70", size = 13),
        axis.title.x = element_text(hjust=1,colour="gray70", size = 8),
        axis.title.y = element_text(vjust=90, colour="deepskyblue4", size = 8),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank(),
        legend.position = "none",
        axis.text.x  = element_blank(),
        axis.text.y  = element_blank(),
        axis.ticks  = element_blank()) +
  coord_equal() +
  ggtitle(expression(atop("",
                          "Melbourne public transport network"))) +
  xlab("Blue for bus, red for train and green for tram.\nRoutes based on PTV GTFS data (https://www.data.vic.gov.au/data/dataset/ptv-timetable-and-geographic-information-2015-gtfs)") +
  ylab("")