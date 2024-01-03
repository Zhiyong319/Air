### define functions

cone <-function(true1,true2,hemi=1) {
  
  true1  <-33
  true2  <-45
  hemi   <- 1   
  
  pi180  <-pi/180
  
  cone   <- log10(cos(true1 * pi180)) - log10(cos(true2 * pi180))
  cone   <- cone / ( log10( tan((45.0 - hemi*true1/2.0) * pi180)) 
                     -  log10( tan((45.0 - hemi*true2/2.0) * pi180)) )
  
  # if met_tru1 and met_tru2 are the same
  if(true1 == true2) {
    cone <- hemi * sin(true1*pi180)
  }
  return(cone)
  
}

wrf_projection <-function(file) {
  
  f1  <-nc_open(file)
  
  head <- ncatt_get(f1, varid=0, attname="TITLE" )$value
  time <- ncvar_get(f1, varid="Times")
  mproj<- ncatt_get(f1, varid=0, attname="MAP_PROJ" )$value
  
  # WRF  1-Lamb     2-Polar    3-Merc      4- Lat-lon
  if(mproj == 1){
    lat1    <- ncvar_get(f1, varid="XLAT",start=c(1,1,1),count=c(1,1,1))
    lon1    <- ncvar_get(f1, varid="XLONG",start=c(1,1,1),count=c(1,1,1))
    lat     <- ncvar_get(f1, varid="XLAT",start=c(1,1,1),count=c(-1,-1,1))
    lon     <- ncvar_get(f1, varid="XLONG",start=c(1,1,1),count=c(-1,-1,1))
    nx      <- ncatt_get(f1, varid=0, attname="WEST-EAST_GRID_DIMENSION" )$value
    ny      <- ncatt_get(f1, varid=0, attname="SOUTH-NORTH_GRID_DIMENSION" )$value
    dx      <- ncatt_get(f1, varid=0, attname="DX" )$value
    truelat1<- ncatt_get(f1, varid=0, attname="TRUELAT1" )$value
    truelat2<- ncatt_get(f1, varid=0, attname="TRUELAT2" )$value
    standlon<- ncatt_get(f1, varid=0, attname="STAND_LON" )$value
  }
  
  if(mproj == 2){
    lat1      <- ncvar_get(f1, varid="XLAT",start=c(1,1,1),count=c(1,1,1))
    lon1      <- ncvar_get(f1, varid="XLONG",start=c(1,1,1),count=c(1,1,1))
    lat       <- ncvar_get(f1, varid="XLAT",start=c(1,1,1),count=c(-1,-1,1))
    lon       <- ncvar_get(f1, varid="XLONG",start=c(1,1,1),count=c(-1,-1,1))
    nx        <- ncatt_get(f1, varid=0, attname="WEST-EAST_GRID_DIMENSION" )$value
    ny        <- ncatt_get(f1, varid=0, attname="SOUTH-NORTH_GRID_DIMENSION" )$value
    dx        <- ncatt_get(f1, varid=0, attname="DX" )$value
    truelat1  <- ncatt_get(f1, varid=0, attname="TRUELAT1" )$value
    truelat2  <- ncatt_get(f1, varid=0, attname="TRUELAT2" )$value
    standlon  <- ncatt_get(f1, varid=0, attname="STAND_LON" )$value
  }
  
  if(mproj == 3){
    lat1      <- ncvar_get(f1, varid="XLAT",start=c(1,1,1),count=c(1,1,1))
    lon1      <- ncvar_get(f1, varid="XLONG",start=c(1,1,1),count=c(1,1,1))
    lat       <- ncvar_get(f1, varid="XLAT",start=c(1,1,1),count=c(-1,-1,1))
    lon       <- ncvar_get(f1, varid="XLONG",start=c(1,1,1),count=c(-1,-1,1))
    nx        <- ncatt_get(f1, varid=0, attname="WEST-EAST_GRID_DIMENSION" )$value
    ny        <- ncatt_get(f1, varid=0, attname="SOUTH-NORTH_GRID_DIMENSION" )$value
    dx        <- ncatt_get(f1, varid=0, attname="DX" )$value
    truelat1  <- ncatt_get(f1, varid=0, attname="TRUELAT1" )$value
    truelat2  <- ncatt_get(f1, varid=0, attname="TRUELAT2" )$value
    standlon  <- ncatt_get(f1, varid=0, attname="STAND_LON" )$value
  }
  
  if(mproj == 4){
    lat1      <- ncvar_get(f1, varid="XLAT",start=c(1,1,1),count=c(1,1,1))
    lon1      <- ncvar_get(f1, varid="XLONG",start=c(1,1,1),count=c(1,1,1))
    lat       <- ncvar_get(f1, varid="XLAT",start=c(1,1,1),count=c(-1,-1,1))
    lon       <- ncvar_get(f1, varid="XLONG",start=c(1,1,1),count=c(-1,-1,1))
    nx        <- ncatt_get(f1, varid=0, attname="WEST-EAST_GRID_DIMENSION" )$value
    ny        <- ncatt_get(f1, varid=0, attname="SOUTH-NORTH_GRID_DIMENSION" )$value
    dx        <- ncatt_get(f1, varid=0, attname="DX" )$value
    truelat1  <- ncatt_get(f1, varid=0, attname="TRUELAT1" )$value
    truelat2  <- ncatt_get(f1, varid=0, attname="TRUELAT2" )$value
    standlon  <- ncatt_get(f1, varid=0, attname="STAND_LON" )$value
  }
  
  conef  <- cone(truelat1,truelat2)
  
  projection <-list(mproj=mproj, lat=lat, lon=lon, lat1=lat1, lon1=lon1, nx=nx, ny=ny, dx=dx,
                    truelat1=truelat1, truelat2=truelat2, standlon=standlon, conef=conef)
  
  return(projection)
  
}

# Output: List with i and j index values in fractional form
lamb_latlon_to_ij <- function(reflat, reflon, iref, jref, truelat1, truelat2,
                              stdlon, delx, grdlat, grdlon, radius= 6370000.0) {
  
  
  pi     <- 4.0*atan(1.0)
  pi2    <- pi/2.0
  pi4    <- pi/4.0
  d2r    <- pi/180.0
  r2d    <- 180.0/pi
  omega4 <- 4.0*pi/86400.0
  
  if(truelat1 == truelat2) {
    gcon <- sin( abs(truelat1) * d2r)
  } else {
    gcon <- (log(sin((90.0- abs(truelat1))* d2r))-log(sin((90.0- abs(truelat2))* d2r)))/
      (log(tan((90.0- abs(truelat1))*0.5* d2r))-log(tan((90.0- abs(truelat2))*0.5* d2r)))
  }
  
  ogcon  <- 1.0/gcon
  ahem   <- abs( truelat1 / truelat1 )
  deg    <- (90.0- abs(truelat1)) * d2r
  cn1    <- sin(deg)
  cn2    <- radius * cn1 * ogcon
  deg    <- deg * 0.5
  cn3    <- tan(deg)
  deg    <- (90.0- abs(reflat)) * 0.5 * d2r
  cn4    <- tan(deg)
  rih    <- cn2 *(cn4 / cn3)**gcon
  deg    <- (reflon-stdlon) * d2r * gcon
  
  xih    <- rih * sin(deg) - delx/2
  yih    <- (-1 * rih * cos(deg) * ahem) - delx/2
  
  deg    <- (90.0 - (grdlat * ahem) ) * 0.5 * d2r
  cn4    <- tan(deg)
  
  rrih   <- cn2 *  (cn4/cn3)**gcon
  check  <- 180.0-stdlon
  alnfix <- stdlon + check
  alon   <- grdlon + check
  
  if (alon<0.0)  { alon <- alon+360.0 }
  if (alon>360.0){ alon <- alon-360.0 }
  
  deg    <- (alon-alnfix) * gcon * d2r
  XI     <- rrih * sin(deg)
  XJ     <- -1* rrih * cos(deg) * ahem
  
  grdi   <- iref+(XI-xih)/(delx)
  grdj   <- jref+(XJ-yih)/(delx)
  
  return(list(i=grdi, j=grdj))
  
}

polars_latlon_to_ij <- function(lat1, lon1, delx, truelat1, stdlon, 
                                lato, lono, radius= 6370000.0) {
  
  rad_per_deg <- pi/180
  deg_per_rad <- 180/pi
  
  reflon      <- stdlon + 90.
  
  hemi   <- 1
  if(truelat1 < 0) {
    hemi <- -1
  }
  
  rebydx    <- radius / delx
  scale_top <- 1. + hemi * sin(truelat1 * rad_per_deg)
  
  ala1      <- lat1 * rad_per_deg
  rsw       <- rebydx*cos(ala1)*scale_top/(1.+hemi*sin(ala1))
  
  alo1      <- (lon1 - reflon) * rad_per_deg
  polei     <- 1. - rsw * cos(alo1)
  polej     <- 1. - hemi * rsw * sin(alo1)
  
  
  ala       <- lato * rad_per_deg
  rm        <- rebydx * cos(ala) * scale_top/(1. + hemi *sin(ala))
  alo       <- (lono - reflon) * rad_per_deg
  grdi      <- polei + rm * cos(alo)
  grdj      <- polej + hemi * rm * sin(alo)
  
  
  return(list(i=round(grdi), j=round(grdj)))
  
}

mercat_latlon_to_ij <- function(reflat, reflon, lat, lon, dx, stdlt1, lato, lono, radius= 6370000.0) {
  
  # Calculation used in Obsgrid for Mercator. Saved here for possible use in the future.
  rad_per_deg <- pi/180
  deg_per_rad <- 180/pi
  
  lon0 <- reflon
  if(lon0 < 0) {
    lon0 <- 360+lon0
  } 
  
  lon360 <- lono
  if(lon360 < 0) {
    lon360 <- 360+lon360
  } 
  
  clain  <- cos(rad_per_deg*stdlt1)
  dlon   <- dx / (radius * clain)
  
  rsw <- 0.
  if(reflat != 0) {
    rsw <- (log(tan(0.5*((reflat+90.)*rad_per_deg))))/dlon
  }
  
  
  deltalon <- lon360 - lon0
  deltalat <- lato - reflat
  
  grdi <- 1. + (deltalon/(dlon*deg_per_rad))
  grdj <- 1. + (log(tan(0.5*((lato + 90.) * rad_per_deg)))) / dlon - rsw
  
  # More direct calculation that finds closest grid point using min distance
  # between site lat-lon and all grid point lat-lons.
  d    <- sqrt( (lato-lat)^2 + (lono-lon)^2 )
  ind  <- which(d == min(d), arr.ind =T)
  grdi <-ind[1]
  grdj <-ind[2]
  
  return(list(i=round(grdi), j=round(grdj)))
  
}

latlon_latlon_to_ij <- function(lat, lon, lato, lono) {
  
  # More direct calculation that finds closest grid point using min distance
  # between site lat-lon and all grid point lat-lons.
  d    <- sqrt( (lato-lat)^2 + (lono-lon)^2 )
  ind  <- which(d == min(d), arr.ind =T)
  grdi <-ind[1]
  grdj <-ind[2]
  
  return(list(i=grdi, j=grdj))
  
}