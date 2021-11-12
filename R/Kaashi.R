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
kaashi <- function(tarh, n, shift = 2){
  for(i in 0:(n-1)) {
    for(j in 0:(n-1)){
      if(i == 0 & j == 0){
        tiling <- tarh
      } else{
        tiling = rbind(
          tiling,
          dplyr::mutate(tarh,x = x+c(i*shift,j*shift))
        )
      }
    }
  }
  return(tiling)
}
