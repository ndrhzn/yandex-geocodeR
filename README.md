# yandex-geocodeR
simple yandex geocoding API wrapper for R

**function**

**geocode**(*address, lang="uk_UA", results = 1, saveToFile = FALSE, allowMetadata = TRUE, fileName = "~/R/geocoded.csv"*)

**arguments**

**address** - character vector of length 1 or more - basically address you want to geocode

**lang** - character - locale (language and region), by default it's "uk_UA" now but you can change it. available options - "ru_RU", "be_BY", "en_US", "tr_TR"

**results** - numeric - number of results to return (in case there're more then one)

**saveToFile** - logical (TRUE/FALSE) - do you want to save result to csv file or to return dataframe, defaults to FALSE

**allowMetadata** - logical (TRUE/FALSE) - do you want just longitude and latitude or additional information, defaults to TRUE

**fileName** - character - in case you want to save data to file you should provide path and filename, defaults to "~/R/geocoded.csv"

**output** is data.frame

*(with allowMetadata = TRUE)*

**request** - address you requested  
**lon** - longitude  
**lat** - latitude  
**kind** - toponim kind (house, street, metro, district, locality) [*read the yandex docs*](https://tech.yandex.ru/maps/doc/geocoder/desc/concepts/input_params-docpage/)   
**precision** - exact, number, near, range, street, other [*read the yandex docs*](https://tech.yandex.ru/maps/doc/geocoder/desc/reference/precision-docpage/)   
**text** - full address decoded by yandex                      
**addressLine**  
**countryNameCode**  
**countryName**  
**administrativeAreaName**  
**localityName**  
**thoroughfareName**  
**premiseNumber**  

*with (allowMetadata = FALSE)*

**request**  
**lon**  
**lat**  

**limitations**  

25 000 requests per day

**dependencies**  

httr library

read [yandex geocoding docs](https://tech.yandex.ru/maps/doc/geocoder/desc/concepts/About-docpage/)
