# returns the model column and row for a given lattitue and longitude

library(M3)

get.row.col <- function(lon, lat, CMAQ.filename) {

  row <- col <- NULL
  a <- project.lonlat.to.M3(lon, lat, CMAQ.filename)$coords

  CMAQ.row.lower <- get.coord.for.dimension(CMAQ.filename, dimension="row", position="lower")$coords
  CMAQ.row.upper <- get.coord.for.dimension(CMAQ.filename, dimension="row", position="upper")$coords

  CMAQ.col.lower <- get.coord.for.dimension(CMAQ.filename, dimension="col", position="lower")$coords
  CMAQ.col.upper <- get.coord.for.dimension(CMAQ.filename, dimension="col", position="upper")$coords

  for(i in 1:length(lon)){
     if(length(which((CMAQ.row.lower < a[i,][2]) & (CMAQ.row.upper > a[i,][2])))==0 |
        length(which((CMAQ.col.lower < a[i,][1]) & (CMAQ.col.upper > a[i,][1])))==0){
        row <- append(row,NA)
	col <- append(col,NA)
     } else {	 
        row <- append(row,which((CMAQ.row.lower < a[i,][2]) & (CMAQ.row.upper > a[i,][2])))
        col <- append(col,which((CMAQ.col.lower < a[i,][1]) & (CMAQ.col.upper > a[i,][1])))     
     }
  }
  list(row = row, column = col)

}