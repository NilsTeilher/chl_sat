library(raster)
dirpath="G:/Clorofila/crop_Peru/"
# rasfiles=list.files(path = dirpath,pattern = ".nc",recursive = T,full.names =F)

for (year in 2002:2018) {
  dir.create(path = paste0(dirpath,"regrid/",year),showWarnings = F)
  newpath=paste0(dirpath,year, "/")
  rasfiles=list.files(path = newpath,pattern = ".nc",recursive = F,full.names =F)

  for (i in 1:length(rasfiles)) {
    ras=raster(paste0(newpath,rasfiles[i]))
    ras2=aggregate(ras, fact= 4 ,fun=mean,na.rm=T)
    newname=paste0(dirpath,"regrid/",year,"/",rasfiles[i])
    writeRaster(x = ras2,filename = newname, overwrite = TRUE)
    print(newname)
  }
}


# ras=raster(x =rasfiles[1])
# class(ras)
# dim(ras)
# res(ras)
# 
# ras2=aggregate(ras, fact= 4 ,fun=mean,na.rm=T);dim(ras2);res(ras2)
# par(mfrow = c(1,2))
# plot(ras)
# plot(ras2)
# 
# dir.create(path = paste0(dirpath,"regrid"),showWarnings = F)
# 
# 
# 
# # par(mfrow = c(1,2))
# # x <- raster(matrix(1:100, nrow = 480, ncol = 480)); dim(x);plot(x)
# # y <- aggregate(x, fact = 4, fun = mean, na.rm = TRUE); dim(y);plot(y)
# 
