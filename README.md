
<!-- README.md is generated from README.Rmd. Please edit that file -->

<a href={https://github.com/Ehyaei/Kaashi}><img src="man/figures/kaashi.svg" alt="Kaashi logo" align="right" width="160" style="padding: 0 15px; float: right;"/>

# Kaashi (Tile)

[![](https://img.shields.io/badge/devel%20version-0.1.0-orange.svg)](https://github.com/Ehyaei/Kaashi)
[![](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![](https://img.shields.io/github/last-commit/Ehyaei/Kaashi.svg)](https://github.com/Ehyaei/Kaashi/commits/main)

The art of tiling has long been used to decorate homes and holy places
in Iran. One of the masterpieces of this art can be found in Isfahan’s
Sheikh Lotfollah Mosque.

<a><img src="man/figures/lotfollah.png" align="right" width="100%" style="padding: 0 15px; float: right;"/>

The purpose of this package is to create Islamic pattern using R
functions.

## Installation

You can install the development version of Kaashi from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ehyaei/kaashi")
```

## How Create Kashi

``` r
library(Kaashi)
library(ggplot2)

kas <- kaashi(tarh(theta = 45, delta = 0.5), n = 5)
ggplot(kas) + geom_sf() + theme_void()
```

<img src="man/figures/README-kashi-1.svg" width="100%" />

``` r
kasr <- kaashi(tarhe_rangi(theta = 45, delta = 0.5,dist = 0.05), n = 5)
ggplot(kasr) + 
  geom_sf(aes(fill = area),color = "white",size = 0.01) + 
  scale_fill_gradientn(colours = c("#EF821D","#2eb6c2","#0C3263"))+
  theme_void()+theme(legend.position = "none")
```

<img src="man/figures/README-kashi_rangi_1-1.svg" width="100%" />

``` r
kasr <- kaashi(tarhe_rangi(theta = 30, delta = 0.5), n = 5)
ggplot(kasr) + 
  geom_sf(aes(fill = as.factor(area)),color = "white",size= 0.001) + 
  scale_fill_manual(values =  c("#FFAD00","#FFAD00","#BF5700","#002D7B","#007EA1"))+
  theme_void()+theme(legend.position = "none")
```

<img src="man/figures/README-kashi_rangi_2-1.svg" width="100%" />

``` r
# Hexagonal Box
s3 = sqrt(3)
hex_box = rbind(c(-1,0), c(1,0), c(2,s3), c(1,2*s3), c(-1,2*s3),c(-2,s3),c(-1,0))
tarh_hex = tarh(theta = 45, n = 6, delta = 0.2, start_points = c(0,0),
                box = hex_box,drawBox = T) 
ggplot(tarh_hex)+ geom_sf() + theme_void()
```

<img src="man/figures/README-hexagonal_pattern-1.svg" width="100%" />

``` r
tarh_hex = tarhe_rangi(theta = 60, n = 6, delta = 0.2, 
                       start_points = c(0,0), box = hex_box,dist = 0.05)
kaashi_hex = kaashi(tarh = tarh_hex,n = 2,d = 6, box = hex_box)
ggplot(kaashi_hex)+
  geom_sf(aes(fill = as.factor(area)),color = "white",size= 0.1) + 
  scale_fill_manual(values =  c("#FFAD00","#FFAD00","#007EA1","#002D7B"))+
  theme_void()+theme(legend.position = "none")
```

<img src="man/figures/README-hexagonal_kaashi-1.svg" width="100%" />
