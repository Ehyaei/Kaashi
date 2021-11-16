#' Plot Tile and Tiling Pattern
#'
#' plot is used for plot pattern or tessellation outputs. In fact it is ggplot-based
#' function that uses geom_sf to plot sf class object.
#'
#' @param shape pattern or tessellation function outputs. It is sf class object.
#' @param tileColor if the shape is a polygon, for coloring its regions you can
#' set tileColor, which is a vector of colors equal to the number of regions.
#' @param fill is the name of shape sf column and default value is "area".
#' If you can color shape regions base of region code you can set it "name"
#' @param lineColor for coloring the shape of a class of polyline
#' @param borderSize the size of lines
#' @param borderColor the color of  shape's border of a class of polygon
#'
#' @return ggplot objects
#' @export ggplot
#'
#' @examples
#' library(ggplot2)
#' tile <- motif(theta = 45, delta = 0.5, polyLine = T)
#' tilePlotter(tile)
#' tiling <- tiling(tile, n = 5)
#' tilePlotter(tiling)
#' tile <- motif(theta = 45, delta = 0.5, dist = 0.05, polyLine = F)
#' tiling <- tiling(tile, n = 5)
#' tilePlotter(tiling,tileColor = c("#EF821D","#2eb6c2","#0C3263"),borderSize = 0.01)
tilePlotter <- function(shape, tileColor = NULL, fill = "area", lineColor = "black",
                       borderSize  = 0.5, borderColor = "white") {
  if("area" %in% colnames(shape)){
    shape$area = as.factor(shape$area)
  }

  p <- ggplot(shape) +
    theme_void()+
    theme(legend.position = "none")
  if("area" %in% colnames(shape)){
    if(!is.null(tileColor)){
      p = p +
        geom_sf(aes_string(fill = fill), color = borderColor, size = borderSize)+
        scale_fill_manual(values = tileColor)
    } else{
      p = p +
        geom_sf(color = borderColor, size = borderSize)+
        scale_fill_manual(values = tileColor)
    }
  } else {
    p = p + geom_sf(color = lineColor, size = borderSize)
  }
return(p)
}
