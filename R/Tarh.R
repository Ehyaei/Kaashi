#' pattern
#'
#' @param theta
#' @param delta
#' @param n
#' @param start_points
#' @param drawBox
#' @param box
#'
#' @return
#' @import dplyr
#' @importFrom  sf st_polygon
#' @export
#'
#' @examples
pattern <- function(
  theta = 30,
  delta = 0.2,
  n = 4,
  dist = 0.001,
  start_points = c(0,-1),
  polyLine = F,
  drawBox = FALSE,
  box = rbind(c(-1,-1), c(1,-1), c(1,1), c(-1,1), c(-1,-1))
                 ){

  suppressMessages(library(dplyr)) # TODO remove package
  suppressMessages(library(sf))

  # Create Polygons
  pl_box = st_polygon(list(box)) %>% st_sfc()
  lns_box = st_linestring(box) %>% st_sfc()

  # Compute Center
  center = pl_box %>% st_centroid() %>% unlist()

  # Compute Diameter
  d = pl_box %>%
    st_cast('MULTIPOINT') %>%
    st_cast('POINT') %>%
    st_distance() %>%
    max()

  if(polyLine){
    ############################################################
    #                                                          #
    #                    Polylines Pattern                     #
    #                                                          #
    ############################################################

    # Create Basis Lines
    ln1 <- st_linestring(rbind(
      c(delta,0) + start_points,
      c(delta - d*cos(theta*pi/180),0 + d*sin(theta*pi/180)) + start_points
    )) %>% st_sfc %>%
      st_intersection(pl_box)
    ln2 <- st_linestring(rbind(
      c(-delta,0) + start_points,
      c(-delta + d*cos(theta*pi/180),0 + d*sin(theta*pi/180)) + start_points
    ))%>% st_sfc %>%
      st_intersection(pl_box)

    shapes = rbind(
      ln1 %>% st_as_sf, ln2 %>% st_as_sf)

    # Rotate Basis Lines
    for(i in 1:(n-1)) {
      shapes = rbind(shapes, ((ln1-center)*rot(-i*360/n)+center) %>% st_as_sf)
      shapes = rbind(shapes, ((ln2-center)*rot(-i*360/n)+center) %>% st_as_sf)
    }

    # Add Box
    if(drawBox){
      shapes = rbind(shapes, lns_box) %>% unique()
    }

    # Last Crop
    shapes = shapes %>% st_intersection(pl_box)

    # Create SF Objects
    sfc <- shapes$x
    shapes_frame <- st_sf(
      name = paste0("R",stringr::str_pad(1:length(sfc),width = 2,side = "left",pad = "0")),
      geometry = sfc
    )

  } else{

    ############################################################
    #                                                          #
    #                    Polygons Pattern                      #
    #                                                          #
    ############################################################

    # Create Basis Lines
    line_list = list()
    ln1 <- st_linestring(rbind(
      c(delta,0) + start_points,
      c(delta - d*cos(theta*pi/180),0 + d*sin(theta*pi/180)) + start_points
    ))
    line_list[[1]] = ln1
    ln2 <- st_linestring(rbind(
      c(-delta,0) + start_points,
      c(-delta + d*cos(theta*pi/180),0 + d*sin(theta*pi/180)) + start_points
    ))
    line_list[[2]] = ln2

    # Rotate Basis Lines
    for(i in 2*(1:(n-1))) {
      line_list[[i+1]] = (ln1-center)*rot(-i*360/(2*n))+center
      line_list[[i+2]] = (ln2-center)*rot(-i*360/(2*n))+center
    }
    # Create Shape
    shapes = pl_box
    for (i in 1:length(line_list)) {
      shapes = st_difference(shapes, st_buffer(line_list[[i]],dist = dist))
    }

    # Last Crop
    shapes = shapes %>% st_intersection(pl_box)

    sfc = st_cast(shapes,"POLYGON")
    shapes_frame <- st_sf(
      name = paste0("R",stringr::str_pad(1:length(sfc),width = 2,side = "left",pad = "0")),
      area = round(st_area(sfc),3),
      geometry = sfc
    )
  }

  return(shapes_frame)
}
