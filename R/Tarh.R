#' Tarh
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
tarh <- function(
  theta = 135, delta = 0.2, n = 4, start_points = c(0,-1),
  drawBox = FALSE,
  box = rbind(c(-1,-1), c(1,-1), c(1,1), c(-1,1), c(-1,-1))
                 ){
  suppressMessages(library(dplyr)) # TODO remove load pacakage
  suppressMessages(library(sf))
  pl_box = st_polygon(list(box)) %>% st_sfc()


  box = c(xmin = -1, ymin = -1, xmax = 1, ymax = 1)
  d = 2*sqrt(2)

  ln1 <- st_linestring(rbind(
    c(delta,0) + start_points,
    c(delta - d*cos(theta*pi/180),0 + d*sin(theta*pi/180)) + start_points
  )) %>% st_sfc %>%
    st_crop(box)
  ln2 <- st_linestring(rbind(
    c(-delta,0) + start_points,
    c(-delta + d*cos(theta*pi/180),0 + d*sin(theta*pi/180)) + start_points
  ))%>% st_sfc %>%
    st_crop(box)

  shapes = rbind(
    ln1 %>% st_as_sf, ln2 %>% st_as_sf)

  for(i in 1:(n-1)) {
    shapes = rbind(shapes, (ln1*rot(-i*360/n)) %>% st_as_sf)
    shapes = rbind(shapes, (ln2*rot(-i*360/n)) %>% st_as_sf)
  }
  if(drawBox){
    return(rbind(shapes, pl_box))
  } else{
    return(shapes)
  }
}



