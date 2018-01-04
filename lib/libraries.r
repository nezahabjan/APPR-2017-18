library(knitr)
library(dplyr)
library(readr)
library(rvest)
library(gsubfn)
library(ggplot2)
library(reshape2)
library(shiny)
library(rjson)
<<<<<<< HEAD
=======
library(tidyr)
library(reshape)
>>>>>>> 47b97175e6181178b705af3a13029a348985b899

install.packages("jsonlite", repos="http://cran.r-project.org")
library(jsonlite)
# Uvozimo funkcije za pobiranje in uvoz zemljevida.
source("lib/uvozi.zemljevid.r", encoding = "UTF-8")

