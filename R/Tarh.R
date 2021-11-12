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
  theta = 30, delta = 0.2, n = 4, start_points = c(0,-1),
  drawBox = FALSE,
  box = rbind(c(-1,-1), c(1,-1), c(1,1), c(-1,1), c(-1,-1))
                 ){
  suppressMessages(library(dplyr)) # TODO remove package
  suppressMessages(library(sf))
  pl_box = st_polygon(list(box)) %>% st_sfc()
  lns_box = st_linestring(box) %>% st_sfc()
  bbox = c(xmin = -1, ymin = -1, xmax = 1, ymax = 1)
  d = 2*sqrt(2)

  ln1 <- st_linestring(rbind(
    c(delta,0) + start_points,
    c(delta - d*cos(theta*pi/180),0 + d*sin(theta*pi/180)) + start_points
  )) %>% st_sfc %>%
    st_crop(bbox)
  ln2 <- st_linestring(rbind(
    c(-delta,0) + start_points,
    c(-delta + d*cos(theta*pi/180),0 + d*sin(theta*pi/180)) + start_points
  ))%>% st_sfc %>%
    st_crop(bbox)

  shapes = rbind(
    ln1 %>% st_as_sf, ln2 %>% st_as_sf)

  for(i in 1:(n-1)) {
    shapes = rbind(shapes, (ln1*rot(-i*360/n)) %>% st_as_sf)
    shapes = rbind(shapes, (ln2*rot(-i*360/n)) %>% st_as_sf)
  }


  if(drawBox){
    shapes = rbind(shapes, lns_box) %>% unique()
  }
  sfc <- shapes$x
  shape_frame <- st_sf(
    name = paste0("R",stringr::str_pad(1:length(sfc),width = 2,side = "left",pad = "0")),
    geometry = sfc
  )
  return(shape_frame)

}


#' Tarh e Rangi (colorfull pattern)
#'
#' @param theta
#' @param delta
#' @param n
#' @param dist
#' @param start_points
#' @param box
#'
#' @return
#' @export
#'
#' @examples
tarhe_rangi <- function(
  theta = 30, delta = 0.2, n = 4, dist = 0.001,
  start_points = c(0,-1),
  box = rbind(c(-1,-1), c(1,-1), c(1,1), c(-1,1), c(-1,-1))
){
  suppressMessages(library(dplyr)) # TODO remove package
  suppressMessages(library(sf))
  pl_box = st_polygon(list(box)) %>% st_sfc()

  bbox = c(xmin = -1, ymin = -1, xmax = 1, ymax = 1)
  d = 2*sqrt(2)

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

  for(i in 2*(1:(n-1))) {
    line_list[[i+1]] = ln1*rot(-i*360/(2*n))
    line_list[[i+2]] = ln2*rot(-i*360/(2*n))
  }
shape = pl_box
  for (i in 1:length(line_list)) {
    shape = st_difference(shape, st_buffer(line_list[[i]],dist = dist))
  }

sfc = st_cast(shape,"POLYGON")
shape_frame <- st_sf(
  name = paste0("R",stringr::str_pad(1:length(sfc),width = 2,side = "left",pad = "0")),
  area = round(st_area(sfc),3),
  geometry = sfc
)
    return(shape_frame)
}


