library(maps)
library(mapdata)

dirpath="G:/Clorofila/crop_Peru/regrid/"

for (year in 2002:2018) {
  new_path <- paste0(dirpath, year, "/")
  
  rasfiles=list.files(path = new_path,pattern = ".nc",full.names = T,recursive = T)
  rasfiles=rasfiles[1:90]
  ras=raster(rasfiles[1]);dim(ras)
  
  mat=matrix(data=NA, nrow = dim(ras)[1]*dim(ras)[2], ncol = length(rasfiles))
  # dim(mat)
  for (i in 1:length(rasfiles)) {
    miras=raster(rasfiles[i])
    mat[,i]=getValues(miras)
    print(rasfiles[i])
  }
  
  meanras=apply(X = mat,MARGIN = c(1),FUN = mean,na.rm=T)
  # length(meanras)
  ras[]=meanras
  
  png(filename = paste0(dirpath, year,'mean_chl.png'), width = 850, height = 850, res = 120)
  par(lwd = 2)
  plot(ras,xlim=c(-90,-70),ylim=c(-20,0), zlim = c(0,20), axes = F)
  grid()
  axis(side = 1, font = 2, lwd.ticks = 2)
  axis(side = 2, font = 2, lwd.ticks = 2, las = 2)
  map('worldHires', add=T, fill=T, col='gray')
  box(lwd = 2)
  dev.off()
  
}

