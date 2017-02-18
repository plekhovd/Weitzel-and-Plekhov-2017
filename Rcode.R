library(raster)
library(rgdal)
library(gdalUtils)

rasterOptions(progress = "text")

setwd("/Users/danplekhov/Desktop/Working Files/Weitzel and Plekhov 2017/GIS/Raster/tiles") # set directory

projection = "+init=EPSG:4326"   # set projection (WGS84)
crs = crs(projection) # create crs objection

dir = dir("tiles", ".hdf") # filter through directory for .hdf files

for(i in 1:length(dir)){  # for each file in directory, access NPP raster, and write to new directory
  sds = get_subdatasets(dir[i])
  gdal_translate(sds[2], dst_dataset = "NPP.tif", overwrite = TRUE)
  r = raster("NPP.tif")
  r = writeRaster(r, paste0("tilesProj/NPP", i, ".tif"), overwrite = TRUE)
}

dir2 = list.files("tilesProj", ".tif")   # filter through directory for .tif files
rasterList = lapply(paste0("tilesProj/",dir2), raster)  #create list of rasters for each time 
rasterMerge =  do.call("merge",rasterList)   # merge all rasters to single raster
rasterMerge = projectRaster(rasterMerge, crs = crs)
rasterMerge = reclassify(rasterMerge, c(6, Inf, NA))  # remove values greater than 6
rasterMerge = writeRaster(rasterMerge, "NPPmerge.tif", overwrite = TRUE) # export raster


