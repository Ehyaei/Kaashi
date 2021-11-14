#' Rotation function
#'
#' @param a angle of rotation in degree
#'
#' @return matrix of rotation
#'
#' @examples
#' rotation(45)
rotation = function(theta){
  matrix(c(cos(theta*pi/180), sin(theta*pi/180), -sin(theta*pi/180), cos(theta*pi/180)), 2, 2)
}
