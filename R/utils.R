#' Rotation function
#'
#' @param a angle of rotation in degree
#'
#' @return matrix of rotation
#'
#' @examples
#' rotation(45)
rotation <- function(theta){
  matrix(c(cos(theta*pi/180), sin(theta*pi/180), -sin(theta*pi/180), cos(theta*pi/180)), 2, 2)
}

#' Create Regular Polygon
#'
#' @param n number of sides
#' @param sf if TRUE the sf polygon object was returned.
#'
#' @return matrix of points or sf polygon.
#'
#' @examples
#' regularPolygon(5) %>% plot()
#' regularPolygon(5,TRUE) %>% tilePlotter()
regularPolygon <- function(n,sf = F){
  points = list()
  for(i in 1:n){
    theta = -pi/2-pi/n-2*pi/n + i*2*pi/n
    points[[i]] = c(cos(theta),sin(theta))
  }
  scale = sqrt(sum((points[[1]]-points[[2]])^2))
  polygon = (2/scale)*(rbind(do.call(rbind, points),points[[1]]))
  polygon[,2] = polygon[,2]-polygon[1,2]

  if(sf){
    sfc <- st_sfc(st_polygon(list(polygon)))
    polygon <- st_sf(
      name = paste0("R",stringr::str_pad(n,width = 2,side = "left",pad = "0")),
      area = round(st_area(sfc),3),
      geometry = sfc
    )
  }
  return(polygon)
}

