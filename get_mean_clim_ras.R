#=============================================================================#
# Name   : get_mean_clim_ras
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
library(raster)
library(maps)
library(mapdata)
library(fields)
library(rangeBuilder)

dirpath <- 'G:/Clorofila/crop_Peru/regrid/'
xlim <- c(-85,-70)
ylim <- c(-20,0)
zlim <- c(0,15)

filenames <- list.files(path = dirpath, pattern = '.nc', recursive = T, full.names = T)
ras <- raster(filenames[1])

days <- seq(from = as.Date('2002-01-01'), to = as.Date('2018-12-31'), by = 'day')
days <- days[-c(211:217)]
days <- days[c(185 : (185+length(filenames)-1) )]

days <- strsplit(x = as.character(days), split = '-')
days <- unlist(days)

matdays <- matrix(data = days, nrow = length(filenames), byrow = T)
meses <- c('01', '02', '03', '04', '05', '06',
           '07', '08', '09', '10', '11', '12')

png(filename = paste0(dirpath, 'clim_chl.png'), width = 1250, height = 1050, res = 120)
par(mfrow = c(3, 4),        # 2x2 layout
    oma = c(2, 2, 1, 0.5),  # two rows of text at the outer left and bottom margin
    mar = c(1, 1, .5, 1.7), # space for one row of text at ticks and to separate plots
    mgp = c(2, .5, 0),      # axis label at 2 rows distance, tick labels at 1 row
    xpd = F,                # allow content to protrude into outer margin (and beyond)
    font = 2)
# par(mfrow = c(3,4), lwd = 2)
for (i in 1:12) {
  month <- matdays[,2]
  month <- which(month == meses[i])
  
  file_month <- filenames[month]
  month_vals <- matrix(data = NA, nrow = dim(ras)[1]*dim(ras)[2], ncol = length(file_month))
  for (j in 1:length(file_month)) {
    ras <- raster(file_month[j])
    month_vals[,j] <- getValues(ras)
    print(file_month[j])
  }
  mean_month <- apply(X = month_vals, MARGIN = c(1), FUN = mean, na.rm = T)
  ras[] <- mean_month
  
  # png(filename = paste0(dirpath, meses[i],'clim_chl.png'), width = 850, height = 850, res = 120)
  # par(lwd = 2)
  plot(ras, xlim = xlim, ylim = ylim, zlim = zlim, axes = F, legend = F, col = tim.colors(64))
  grid()
  if (i == 1 | i == 5 | i == 9){
    axis(side = 2, font = 2, lwd.ticks = 2, cex.axis = 1.5, las = 2)}
  if (i == 9 | i == 10 | i == 11 | i == 12){
    axis(side = 1, font = 2, lwd.ticks = 2, cex.axis = 1.5)}
  map('worldHires', add=T, fill=T, col='gray')
  legend('bottomleft', legend = paste('Mes', i), cex = 1.5)
  addRasterLegend(ras, location = c(-71,-70,-15,-3), ramp = tim.colors(64), minmax = zlim, digits = 0, cex.axis = 2)
  box(lwd = 2)
}
dev.off()
#=============================================================================#
# END OF PROGRAM
#=============================================================================#