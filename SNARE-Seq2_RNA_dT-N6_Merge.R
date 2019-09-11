#Function to merge dT and N6 Cell Barcodes for SPLiT-Seq data
#Input is .RDS files generated from the DropEST pipeline
#Library barcodes (provided separately) are appended to each cell barcode after merging

dtn6.file = "/path/to/R1_dTN6_pairs.txt"

merge.dtn6 = function(rds, library = "KC1", min.umi = 0, dtn6.file = dtn6.file){
  dt.barcodes <- read.table(dtn6.file, header = F, stringsAsFactors = F)[,1]
  n6.barcodes <- read.table(dtn6.file, header = F, stringsAsFactors = F)[,2]
  rds$cm_raw <-  rds$cm_raw[,colSums(rds$cm_raw) > min.umi]
  
  n6.dt.map <- dt.barcodes
  names(n6.dt.map) <- n6.barcodes
  is.dt <- sapply(colnames(rds$cm_raw), function(x) substr(x, 17, 24) %in% dt.barcodes)
  
  cell.barcodes <- sapply(colnames(rds$cm_raw), function(x) substr(x, 1, 16))
  dt.barcodes <- sapply(colnames(rds$cm_raw), function(x) {
    x <- substr(x, 17, 24)
    if (x %in% names(n6.dt.map)) {
      return(n6.dt.map[[x]])
    } else {
      return(x)
    }
  })
  
  new.barcodes <- paste0(cell.barcodes, dt.barcodes)
  names(new.barcodes) <- colnames(rds$cm_raw)
  unique.barcodes <- unique(new.barcodes)
  
  combined.matrix <- matrix(0, nrow(rds$cm_raw), length(unique.barcodes))
  rownames(combined.matrix) <- rownames(rds$cm_raw)
  colnames(combined.matrix) <- unique.barcodes
  
  combined.matrix[,new.barcodes[colnames(rds$cm_raw)[is.dt]]] <- as.matrix(rds$cm_raw[,is.dt])
  combined.matrix[,new.barcodes[colnames(rds$cm_raw)[!is.dt]]] <- combined.matrix[,new.barcodes[colnames(rds$cm_raw)[!is.dt]]] + as.matrix(rds$cm_raw[,!is.dt])
  combined.matrix <- as(combined.matrix, "dgCMatrix")
  
  colnames(combined.matrix) <- paste(library, colnames(combined.matrix), sep="_")
  combined.matrix
  
}
