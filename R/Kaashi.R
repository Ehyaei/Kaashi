#' Kaashi
#'
#' @param tarh
#' @param n
#' @param shift
#'
#' @return
#' @import dplyr
#' @export
#' @examples
kaashi <- function(tarh, n, d = 4,
                   box = rbind(c(-1,-1), c(1,-1), c(1,1), c(-1,1), c(-1,-1))
                     ){
  suppressMessages(library(dplyr)) # TODO remove package
  suppressMessages(library(sf))

  pl_box = st_polygon(list(box)) %>% st_sfc()
  # Compute Diameter
  ln1 <- st_linestring(box[1:2,])
  ln2 <- st_linestring(box[2:3,])
  ln3 <- st_linestring(box[3:4,])

  # Compute Center
  center = pl_box %>% st_centroid()

  shift1 <- st_distance(ln1,center) %>% as.vector()
  shift2 <- st_distance(ln2,center) %>% as.vector()
  shift3 <- st_distance(ln3,center) %>% as.vector()

  vs1  = st_nearest_points(ln1,center) %>% st_cast("POINT")  %>%  unlist()
  vectotshift1 = vs1[1:2]-vs1[3:4]
  vectotshift1 = vectotshift1/sqrt(sum(vectotshift1^2))
  vs2  = st_nearest_points(ln2,center) %>% st_cast("POINT")  %>%  unlist()
  vectotshift2 = vs2[1:2]-vs2[3:4]
  vectotshift2 = vectotshift2/sqrt(sum(vectotshift2^2))
  vs3  = st_nearest_points(ln3,center) %>% st_cast("POINT")  %>%  unlist()
  vectotshift3 = vs3[1:2]-vs3[3:4]
  vectotshift3 = vectotshift3/sqrt(sum(vectotshift3^2))

  # Rectangular Tiling
  if(d == 4){
    # Compute Center

    for(i in 0:(n-1)) {
      for(j in 0:(n-1)){
        if(i == 0 & j == 0){
          tiling <- tarh
        } else{
          tiling = rbind(
            tiling,
            dplyr::mutate(tarh,geometry = geometry + 2*(i*shift1 * vectotshift1 + j*shift2*vectotshift2))
          )
        }
      }
    }
  }

  # Hexagonal Tiling

  if(d == 6){
    # Compute Center

    for(i in 0:(n-1)) {
      for(j in 0:(n-1)){
        for (k in 0:(n-1)){
          if(i == 0 & j == 0 && k ==0){
            tiling <- tarh
          } else{
            tiling = rbind(
              tiling,
              dplyr::mutate(tarh,geometry = geometry + 2*(i*shift1 * vectotshift1 + j*shift2*vectotshift2 + k*shift3*vectotshift3)))
        }
        }
      }
    }
  }

  return(tiling)
}
