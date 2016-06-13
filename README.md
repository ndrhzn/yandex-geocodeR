# yandex-geocodeR
simple yandex geocoding API wrapper for R

function **geocode** has only one argument for now - **address** (character vector of length 1 or more) and returns 

* address  
* lon
* lat
* objectDescription
* country
* adminRegion
* subAdminRegion
* locality

it uses yandex geocoding api (with 25 000 requests per day limit) and httr library

you can save geocoded data into csv on the fly (default mode now) or geocode all data and combine it to dataframe (if you want to use this - comment out *write.table* block and uncomment commented lines with *geocodedDF*)

read [yandex geocoding docs](https://tech.yandex.ru/maps/doc/geocoder/desc/concepts/About-docpage/)
