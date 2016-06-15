library(httr)

geocode <- function(address) {
  
  #geocodedDF <- data.frame()
  
  for (i in address) {
    
    request <- GET("https://geocode-maps.yandex.ru/1.x/?format=json&", 
                   query = list(geocode = i, lang=uk_UA))
    
    response <- content(request)
    
    geoobject <- response$response$GeoObjectCollection$featureMember[[1]][1]
    
    objectDescription <- geoobject$GeoObject$metaDataProperty$GeocoderMetaData$text
    if(is.null(objectDescription)) {objectDescription = "NA"}
    
    country <- geoobject$GeoObject$metaDataProperty$GeocoderMetaData$AddressDetails$Country$CountryName
    if(is.null(country)) {country = "NA"}
    
    adminRegion <- geoobject$GeoObject$metaDataProperty$GeocoderMetaData$AddressDetails$Country$AdministrativeArea$AdministrativeAreaName
    if(is.null(adminRegion)) {adminRegion = "NA"}
    
    subAdminRegion <- geoobject$GeoObject$metaDataProperty$GeocoderMetaData$AddressDetails$Country$AdministrativeArea$SubAdministrativeArea$SubAdministrativeAreaName
    if(is.null(subAdminRegion)) {subAdminRegion = "NA"}
    
    locality <- geoobject$GeoObject$metaDataProperty$GeocoderMetaData$AddressDetails$Country$AdministrativeArea$SubAdministrativeArea$Locality$LocalityName
    if(is.null(locality)) {locality = "NA"}
    
    coordinates <- geoobject$GeoObject$Point$pos
    if(is.null(coordinates)) {coordinates = "NA"}
    
    if(!is.null(coordinates)) {
      
      lon <- strsplit(coordinates, " ")[[1]][1]
      lat <- strsplit(coordinates, " ")[[1]][2]
      
    } else {
      
      lon <- "NA"
      lat <- "NA"
    }
    
    
    geocoded <- data.frame(i, lon, lat, objectDescription, country, adminRegion, subAdminRegion, locality)
    
    #geocodedDF <- rbind.data.frame(geocodedDF, geocoded)
    
    write.table(x = geocoded, file = "~/R/geocoded.csv", append = T, row.names = F, col.names = F, sep = ",")
    
    Sys.sleep(1)
    
  }
  
  #return(geocodedDF)
  
}
