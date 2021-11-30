#' Daily Minimal Theme
#'
#' @param base_size base font size of ggplot theme
#' @param background the background color of plot
#' @param textColor the text color
#' @param base_family the textfont family
#'
#' @return
#' @export
#'
#' @examples
#' library(ggplot2)
#' library(Kaashi)
#' square = regularPolygon(6)
#' tile <- motif(square,n = 6,theta = 45, delta = 0.3, polyLine = F, dist = 0.1)
#' p <- ggplot(tile)+
#' geom_sf(fill = textColor, color = textColor)+
#'   labs(caption = "Daily Motif \n \n NO. 1")+
#'   daily_minimal_theme()
daily_minimal_theme = function(base_size = 9, background = "#EEEEEE", textColor = "#101010",
                               base_family = "Virtuous Slab"){
  theme_void(base_size = base_size,base_family = base_family) +
    theme(
      legend.position = "none",
      axis.title = element_blank(),
      panel.background = element_rect(fill = background,color = background),
      plot.margin = margin(4, 4, 4, 4, "cm"),
      plot.background = element_rect(
        fill = background,
        colour = background,
        size = 1
      ),
      plot.caption = element_text(hjust = 0.5, vjust = -63, size = rel(0.8),
                                  color = textColor, face  = "plain",family = base_family)
    )
}

#' Plot and save tile with Daily Minimal Theme
#'
#' @param tile the sf object that is a output of motif function.
#' @param savePath the path of save image.
#' @param type the output type of image
#' @param base_size base font size of ggplot theme
#' @param background the background color of plot
#' @param textColor the text color
#' @param base_family the textfont family
#' @param dark if True replace the background by textColor
#'
#' @return
#' @export
#'
#' @examples
#' library(ggplot2)
#' library(Kaashi)
#' square = regularPolygon(6)
#' tile <- motif(square,n = 6,theta = 45, delta = 0.3, polyLine = F, dist = 0.1)
#' daily_minimal_plot(tile,"~/Desktop/motif.svg",caption = "Daily Motif \n \n NO. 1")

daily_minimal_plot <- function(tile, savePath, type = "svg", base_size = 9,
                               background = "#EEEEEE", textColor = "#101010",
                               base_family = "Virtuous Slab",dark = FALSE, caption = "Daily Motif \n \n NO. 1"
                               ){
  if(dark){
    bg = background
    background = textColor
    textColor = bg
  }
  p <- ggplot(tile)+
    geom_sf(fill = textColor, color = textColor)+
    labs(caption = caption)+
    scale_x_continuous(expand = c(0, 0))+
    scale_y_continuous(expand = c(0, 0))+
    daily_minimal_theme(base_size = base_size, background = background, textColor = textColor,
                        base_family = base_family)
  ggsave(filename = savePath, plot = p, device = type, width = 16, height = 16, units = "cm")
  print(p)
}


