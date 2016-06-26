library(httr)

geocode <- function(address, lang="uk_UA", results = 1, saveToFile = FALSE, allowMetadata = TRUE, fileName = "~/R/geocoded.csv") {
  
  geocodedDF <- data.frame()
  
  for (i in address) {
    
    #request body---------------------------------------------------------------
    repeat{
        
        request <- GET("https://geocode-maps.yandex.ru/1.x/?format=json&", 
                       query = list(geocode = i, lang=lang, results = results))
        
        if(length(content(request)) != 0 &
           length(content(request)$response$GeoObjectCollection$metaDataProperty$GeocoderResponseMetaData$found) != 0) {
            
            break
        }
    }
    
    #full response
    response <- content(request)$response

    #response metadata----------------------------------------------------------
    metadata <- response$GeoObjectCollection$metaDataProperty$GeocoderResponseMetaData
    
    request <- metadata$request #address you requested
    found <- as.numeric(metadata$found)
    
    #if nothing found-----------------------------------------------------------
    
    if (length(response$GeoObjectCollection$featureMember) == 0 | found == 0) {
        lon = "not found"
        lat = "not found"
        kind = "not found"
        precision = "not found"
        text = "not found"
        addressLine = "not found"
        countryNameCode = "not found"
        countryName = "not found"
        administrativeAreaName = "not found"
        localityName = "not found"
        thoroughfareName = "not found"
        premiseNumber = "not found"
        
    } else {
        
        #if user wants more results than available return what's available
        nresults = ifelse(found <= results, found, results) 
        
        for (i in 1:nresults) {
            
            #response body------------------------------------------------------
            geoobject <- response$GeoObjectCollection$featureMember[[i]][1]$GeoObject
            
            #geoobject medatada-------------------------------------------------
            geoobjectMetadata <- geoobject$metaDataProperty$GeocoderMetaData
            
            kind <- geoobjectMetadata$kind
            text <- geoobjectMetadata$text
            precision <- geoobjectMetadata$precision
            
            #adress details-----------------------------------------------------
            addressDetails <- geoobject$metaDataProperty$GeocoderMetaData$AddressDetails$Country
            
            addressLine <- addressDetails$AddressLine
            if(is.null(addressLine )) {addressLine  = "NA"}
            
            countryNameCode <- addressDetails$CountryNameCode
            if(is.null(countryNameCode)) {countryNameCode = "NA"}
            
            countryName <- addressDetails$CountryName
            if(is.null(countryName)) {countryName = "NA"}
            
            administrativeAreaName <- addressDetails$AdministrativeArea$AdministrativeAreaName
            if(is.null(administrativeAreaName)) {administrativeAreaName = "NA"}
            
            locality <- addressDetails$AdministrativeArea$Locality
            if(typeof(locality) != "list") {
                
                localityName = "NA"
                thoroughfareName = "NA"
                premiseNumber = "NA"
                
            } else {
                
                localityName <- addressDetails$AdministrativeArea$Locality$LocalityName
                if(is.null(localityName)) {localityName = "NA"}
                
                thoroughfareName <- addressDetails$AdministrativeArea$Locality$Thoroughfare$ThoroughfareName
                if(is.null(thoroughfareName)) {thoroughfareName = "NA"}
                
                premiseNumber <- addressDetails$AdministrativeArea$Locality$Thoroughfare$Premise$PremiseNumber
                if(is.null(premiseNumber)) {premiseNumber = "NA"}
                
            }
            
            #coordinates--------------------------------------------------------
            coordinates <- geoobject$Point$pos
            if(is.null(coordinates)) {coordinates = "NA"}
            
            if(!is.null(coordinates)) {
                
                lon <- as.numeric(as.character(strsplit(coordinates, " ")[[1]][1]))
                lat <- as.numeric(as.character(strsplit(coordinates, " ")[[1]][2]))
                
            } else {
                
                lon <- "NA"
                lat <- "NA"
            }
            
        }
        
    }
    
    #full or partial------------------------------------------------------------
    if (allowMetadata == TRUE) {
        
        geocoded <- data.frame(request, lon, lat, kind, precision, text, 
                               addressLine, countryNameCode, countryName, 
                               administrativeAreaName, localityName, 
                               thoroughfareName, premiseNumber)
        
    } else {
        
        geocoded <- data.frame(request, lon, lat)
    }
    
    #save to file or return-----------------------------------------------------
    if (saveToFile == TRUE) {
        
        write.table(x = geocoded, file = fileName, 
                    col.names = FALSE, row.names = FALSE, append = TRUE, 
                    sep = ",", qmethod = "double")
        
    } else {
        
        geocodedDF <- rbind.data.frame(geocodedDF, geocoded)
    }
    
    #make a pause between requests
    Sys.sleep(1)
    
  }
  
  #return data.frame
  if(saveToFile == FALSE) {
      
      return(geocodedDF)
  }
  
}
