#' Design Tile Pattern
#'
#' @param box the polygon that the shape constructed by it.
#' @param midpoint is one point in boundary box that basis lines are constructed.
#' @param theta the angle of basis lines in degree between 0 to 90.
#' @param delta the distance of basis lines between 0 to 1 (it depend on boundary box).
#' @param n the number of sides of polygon.
#' @param dist is the size of interior lines.
#' @param circle  is a Boolean variable that makes regions based on the intersection of circles instead of lines.
#' @param radius the double variable that if is not null, sets the line length or radius of the circle.
#' @param drawBox to show boundary box set it TRUE.
#' @param cropBox the polygon that the motif is cropped by it.
#'
#' @return
#' @import dplyr
#' @import sf
#' @export
#'
#' @examples
#' library(ggplot2)
#' tile <- motif(theta = 45, delta = 0.5, polyLine = T)
#' tilePlotter(tile)
#' tile <- motif(theta = 45, delta = 0.5, dist = 0.05, polyLine = F)
#' tilePlotter(tile)
#' s3 = sqrt(3)
#' hexagonal = rbind(c(-1,0), c(1,0), c(2,s3), c(1,2*s3), c(-1,2*s3),c(-2,s3),c(-1,0))
#' tile <- motif(theta = 45, n = 6, delta = 0.2, midpoint = c(0,0),
#'                 box = hexagonal, drawBox = T, polyLine = T)
#' tilePlotter(tile)
#'
motif <- function(
  box = rbind(c(-1,0), c(1,0), c(1,2), c(-1,2), c(-1,0)),
  midpoint = c(0,0),
  theta = 30,
  delta = 0.2,
  n = 4,
  dist = 0.001,
  circle = FALSE,
  radius = NULL,
  polyLine = F,
  drawBox = FALSE,
  cropBox = NULL
                 ){

  suppressMessages(library(dplyr)) # TODO remove package
  suppressMessages(library(sf))

  # Create Polygons
  if(is.null(cropBox)){
    pl_box = st_polygon(list(box)) %>% st_sfc()
  } else{
    pl_box = st_polygon(list(cropBox)) %>% st_sfc()
  }

  lns_box = st_linestring(box) %>% st_sfc()

  # Compute Center
  center = pl_box %>% st_centroid() %>% unlist()

  # Compute Diameter
  d = pl_box %>%
    st_cast('MULTIPOINT') %>%
    st_cast('POINT') %>%
    st_distance() %>%
    max()

  if(circle){
    d = pl_box %>%
      st_cast('MULTIPOINT') %>%
      st_cast('POINT') %>%
      st_distance() %>%
      min()
  }

  if(!is.null(radius)){
    d = radius
  }

  if(polyLine){
    ############################################################
    #                                                          #
    #                    Polylines Pattern                     #
    #                                                          #
    ############################################################

    if(!circle){
      # Create Basis Lines
      ln1 <- st_linestring(rbind(
        c(delta,0) + midpoint,
        c(delta - d*cos(theta*pi/180),0 + d*sin(theta*pi/180)) + midpoint
      )) %>% st_sfc %>%
        st_intersection(pl_box)
      ln2 <- st_linestring(rbind(
        c(-delta,0) + midpoint,
        c(-delta + d*cos(theta*pi/180),0 + d*sin(theta*pi/180)) + midpoint
      ))%>% st_sfc %>%
        st_intersection(pl_box)
    } else{
      ln1 <- st_buffer(st_point(c(delta,0) + midpoint),d)%>% st_sfc %>%
        st_intersection(pl_box)%>%
        st_cast("MULTILINESTRING")
      ln2 <- st_buffer(st_point(c(-delta,0) + midpoint),d)%>% st_sfc %>%
        st_intersection(pl_box)%>%
        st_cast("MULTILINESTRING")
    }


    shapes = rbind(
      ln1 %>% st_as_sf, ln2 %>% st_as_sf)

    # Rotate Basis Lines
    for(i in 1:(n-1)) {
      shapes = rbind(shapes, ((ln1-center)*rotation(-i*360/n)+center) %>% st_as_sf)
      shapes = rbind(shapes, ((ln2-center)*rotation(-i*360/n)+center) %>% st_as_sf)
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

    if(!circle){
      ln1 <- st_linestring(rbind(
        c(delta,0) + midpoint,
        c(delta - d*cos(theta*pi/180),0 + d*sin(theta*pi/180)) + midpoint
      ))
      ln2 <- st_linestring(rbind(
        c(-delta,0) + midpoint,
        c(-delta + d*cos(theta*pi/180),0 + d*sin(theta*pi/180)) + midpoint
      ))
    } else{
      ln1 <- st_buffer(st_point(c(delta,0) + midpoint),d)%>% st_sfc %>%
        st_intersection(pl_box)%>%
        st_cast("MULTILINESTRING")
      ln2 <- st_buffer(st_point(c(-delta,0) + midpoint),d)%>% st_sfc %>%
        st_intersection(pl_box)%>%
        st_cast("MULTILINESTRING")
    }

    line_list[[1]] = ln1
    line_list[[2]] = ln2

    # Rotate Basis Lines
    for(i in 2*(1:(n-1))) {
      line_list[[i+1]] = (ln1-center)*rotation(-i*360/(2*n))+center
      line_list[[i+2]] = (ln2-center)*rotation(-i*360/(2*n))+center
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
