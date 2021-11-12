
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Kaashi

<!-- badges: start -->
<!-- badges: end -->

The goal of Kaashi is to …

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
library(pals)
kasr <- kaashi(tarhe_rangi(theta = 45, delta = 0.5), n = 5)
ggplot(kasr) + 
  geom_sf(aes(fill = area),color = "white") + 
  scale_fill_gradientn(colours = rev(pals::parula()))+
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
