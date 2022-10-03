list.of.packages <- c("data.table","RPostgreSQL","reshape2","here","tiff","raster","maptools","sp","geosphere")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, repos="http://cran.us.r-project.org")
lapply(list.of.packages, require, character.only=T)

# https://www.neonscience.org/resources/learning-hub/tutorials/raster-data-r
# https://www.neonscience.org/resources/learning-hub/tutorials/extract-values-rasters-r

setwd("C:/git/fao-wapor")

# Reading in shape file data and raster

world <- readShapeSpatial("ne_10m_admin_0_countries.shp")

map <- world[world$ADMIN=="South Sudan",1]

# Read in the raster data from WAPOR

str_name<-'L1_QUAL-NDVI_LT.tif' 

read_file<-raster(str_name) 

read_file<-rasterize(read_file)

plot(read_file)

# Point up shape file

destPoint_v <- function (x, y, b, d, a = 6378137, f = 1/298.257223563, ...) 
{
  r <- list(...)$r
  if (!is.null(r)) {
    return(.old_destPoint(x, y, b, d, r = r))
  }
  b <- as.vector(b)
  d <- as.vector(d)
  x <- as.vector(x)
  y <- as.vector(y)
  p <- cbind(x, y, b, d)
  r <- .Call("_geodesic", as.double(p[, 1]), as.double(p[, 2]), 
             as.double(p[, 3]), as.double(p[, 4]), 
             as.double(a), as.double(f), 
             PACKAGE = "geosphere")
  r <- matrix(r, ncol = 3, byrow = TRUE)
  colnames(r) <- c("lon", "lat", "finalbearing")
  return(r[, 1:2, drop = FALSE])
}

map <- raster::shapefile(map)

plot(map)

dist <- 10000

bbox <- raster::extent(map)

# Calculate number of points on the vertical axis.
ny <- ceiling(geosphere::distGeo(p1 = c(bbox@xmin, bbox@ymin), 
                                 p2 = c(bbox@xmin, bbox@ymax)) / dist)
# Calculate maximum number of points on the horizontal axis. 
# This needs to be calculated for the lowermost and uppermost horizontal lines
# as the distance between latitudinal lines varies when the longitude changes. 
nx <- ceiling(max(geosphere::distGeo(p1 = c(bbox@xmin, bbox@ymin), 
                                     p2 = c(bbox@xmax, bbox@ymin)) / dist,
                  geosphere::distGeo(p1 = c(bbox@xmin, bbox@ymax), 
                                     p2 = c(bbox@xmax, bbox@ymax)) / dist))

# Create result data frame with number of points on vertical axis.
df <- data.frame(ny = 1:ny)

# Calculate coordinates along the vertical axis.
pts <- geosphere::destPoint(p = c(bbox@xmin, bbox@ymin), 
                            b = 0, d = dist * (1:ny - 1))
df$x <- pts[, 1]
df$y <- pts[, 2]

# Add points on horizontal axis.
df <- tidyr::crossing(nx = 1:nx, df)

# Calculate coordinates.
pts <- destPoint_v(df$x, df$y, b = 90, dist * (df$nx - 1))

# Turn coordinates into SpatialPoints.
pts <- SpatialPoints(cbind(pts[, 1], pts[, 2]), proj4string = CRS(proj4string(map)))

# Cut to boundaries of map.
result <- raster::intersect(pts, map)

# Plot result.
plot(result,pch=19,cex=0.001)
title("S.Sudan in Points")

# Join the map of S.Sudan

read_file2 <- crop(read_file, extent(map))
read_file3 <- mask(read_file2, map)

plot(read_file3)

data <- raster::extract(read_file3, result, buffer = 5000, fun=mean, df=TRUE) 

data[,c("x","y")] <- coordinates(result)



