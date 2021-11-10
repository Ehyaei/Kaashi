############################################################
#                                                          #
#                        SF package                        #
#                                                          #
############################################################

library(sf)
library(sp)
library(rgeoss)
library(dplyr)
library(purrr)
library(ggplot2)

############################################################
#                                                          #
#                         Plot Box                         #
#                                                          #
############################################################

box1 = rbind(c(-1,-1), c(1,-1), c(1,1), c(-1,1), c(-1,-1))
st_box1 = st_polygon(list(box1))
st_box2 = st_polygon(list(0.5*box1))

kaashi <- tibble::tribble(
  ~shape, ~geometry,
  "box1", st_box1,
  "box2", st_box2,
  ) %>%
  st_as_sf()


st_buffer(st_point(c(0,0)),1)

############################################################
#                                                          #
#                    Intersection Lines                    #
#                                                          #
############################################################


line1 <- rbind(c(-1,-1),c(1,1))
line2 <- rbind(c(-1,1),c(1,-1))
l1 <- st_linestring(line1)
l2 <- st_linestring(line2)
pnts <- st_intersection(l1, l2)

plot(l1)
plot(l2, add = TRUE)
plot(pnts, add = TRUE, col = "red", pch = 21)

############################################################
#                                                          #
#              Intersection Line with Polygon              #
#                                                          #
############################################################

pnts   <- st_intersection(l1,
                          st_cast(st_box1, "MULTILINESTRING", group_or_split = FALSE))

circle <- st_buffer(st_point(c(0,0)),1)
plot(l1)
plot(st_box1, add = TRUE)
plot(pnts, add = TRUE, col = "red", pch = 21)
plot(circle, add = T)


############################################################
#                                                          #
#                           MINI                           #
#                                                          #
############################################################

library(minisvg)
library(minipdf)

git remote set-url origin https://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@github.com/ehyaei/kaashi.git
