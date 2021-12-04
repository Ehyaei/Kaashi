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

#' Motif Rotation
#'
#' @param tile is sf object likes as output of motif function.
#' @param theta the angle of rotation.
#' @param center the center of rotation. it is 2-D vector like c(0,0).
#'
#' @return sf object
#' @export
#'
#' @examples
#' library(ggplot2)
#' tile <- motif(polyLine = T, drawBox = T)
#' tile_30 <- motif_rotation(tile,30,center = c(0,1))
#' tilePlotter(tile)
#' tilePlotter(rbind(tile,tile_30))
motif_rotation <- function(tile, theta, center = c(0,0)){
  dplyr::mutate(tile, geometry = (geometry-center)*rotation(theta)+center)
}

#' Motif Transfer
#'
#' @param tile is sf object likes as output of motif function.
#' @param shift is 2-D shift vector like c(1,1).
#'
#' @return sf object
#' @export
#'
#' @examples
#' library(ggplot2)
#' tile <- motif(polyLine = T, drawBox = T)
#' tile_2_0 <- motif_transfer(tile, shift = c(2,0))
#' tilePlotter(tile)
#' tilePlotter(rbind(tile, tile_2_0))
motif_transfer <- function(tile, shift){
  dplyr::mutate(tile, geometry = geometry + shift)
}

#' Motif Scale
#'
#' @param tile is sf object likes as output of motif function.
#' @param scale numeric number that shape is scaled by it.
#'
#' @return sf object
#' @export
#'
#' @examples
#' library(ggplot2)
#' tile <- regularPolygon(3,sf = T)
#' scale_tile <- motif_scale(tile, 0.5)
#' tilePlotter(tile)
#' tilePlotter(rbind(tile, scale_tile))
motif_scale <- function(tile, scale){
  dplyr::mutate(tile, geometry = geometry * rep(scale,nrow(tile)))
}

#' Union of two tile
#'
#' @param tile1 sf object
#' @param tile2 sf object
#'
#' @return sf object
#' @export
#'
#' @examples
#' library(ggplot2)
#' tile <- motif(polyLine = F, drawBox = T)
#' tile_2_0 <- motif_transfer(tile, shift = c(1,0))
#' tilePlotter(st_union(tile, tile_2_0),tileColor = c("red","yellow","blue"))
motif_union <- function(tile1,tile2){
  st_union(tile1,tile2)
}

#' Create Regular Polygon
#'
#' @param n number of sides
#' @param sf if TRUE the sf polygon object was returned.
#'
#' @return matrix of points or sf polygon.
#' @export
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

#' Save Pattern
#'
#' @param plot name of ggplot object
#' @param path path of saving plot
#' @param name name of file c("png","eps","svg","pdf")
#' @param type includes subset of
#' @param dpi Plot resolution.
#'
#' @return
#' @import ggplot2
#' @export
#'
saveTile <- function(plot, path, name, type = c("png","eps","svg","pdf"), dpi = 200){
  save_path = paste0(path,"/",name)

  if("png" %in% type){
    ggplot2::ggsave(paste0(save_path,".png"), plot = plot, dpi = dpi,  device = "png")
    knitr::plot_crop(paste0(save_path,".png"))
  }

  if("eps" %in% type){
    ggplot2::ggsave(paste0(save_path,".eps"), plot = plot, device = "eps")
  }

  if("svg" %in% type){
    ggplot2::ggsave(paste0(save_path,".svg"), plot = plot, device = "svg")
  }

  if("pdf" %in% type){
    ggplot2::ggsave(paste0(save_path,".svg"), plot = plot, device = cairo_pdf)
  }
}
