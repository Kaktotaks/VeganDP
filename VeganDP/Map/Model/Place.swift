//
//  Artwork.swift
//  VeganDP
//
//  Created by Леонід Шевченко on 16.08.2021.
//

import Foundation
import MapKit
import Contacts

class Place: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    let discipline: String?
    let rating: String?
    let descriptionText: String?
    let placeurl: String?
    let phoneNum: String?
    let longitude: Double?
    let latitude: Double?
    let objectID: Int?
    let coordinate: CLLocationCoordinate2D
    
    init(
        title: String?,
        locationName: String?,
        discipline: String?,
        rating: String?,
        descriptionText: String?,
        placeurl: String?,
        phoneNum: String?,
        longitude: Double?,
        latitude: Double?,
        objectID: Int?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.rating = rating
        self.descriptionText = descriptionText
        self.placeurl = placeurl
        self.phoneNum = phoneNum
        self.longitude = longitude
        self.latitude = latitude
        self.coordinate = coordinate
        self.objectID = objectID
        
        
        super.init()
    }
    
    init?(feature: MKGeoJSONFeature) {
        // 1
        guard
            let point = feature.geometry.first as? MKPointAnnotation,
            let propertiesData = feature.properties,
            let json = try? JSONSerialization.jsonObject(with: propertiesData),
            let properties = json as? [String: Any]
        else {
            return nil
        }
        
        // 3
        title = properties["title"] as? String
        locationName = properties["location"] as? String
        discipline = properties["discipline"] as? String
        rating = properties["rating"] as? String
        descriptionText = properties["descriptionText"] as? String
        placeurl = properties["placeurl"] as? String
        phoneNum = properties["phoneNum"] as? String
        objectID = properties["objectid"] as? Int
        
        
        var longitude: Double = 0
        
        if let longitudeString = properties["longitude"] as? String {
            if let longitudeDouble = Double(longitudeString){
                longitude = longitudeDouble
            }
        }
        
        self.longitude = longitude
        
        var latitude: Double = 0
        if let latitudeString = properties["latitude"] as? String {
            if let latitudeDouble = Double(latitudeString){
                latitude = latitudeDouble
            }
        }
        
        self.latitude = latitude
        
        coordinate = point.coordinate
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    var mapItem: MKMapItem? {
        guard let location = locationName else {
            return nil
        }
        
        let addressDict = [CNPostalAddressStreetKey: location]
        let placemark = MKPlacemark(
            coordinate: coordinate,
            addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    
    // Set the images to iur annotation
    
    var image: UIImage {
        guard let name = discipline else {
            return #imageLiteral(resourceName: "greenflag")
        }
        
        switch name {
        case "Restaurant":
            return #imageLiteral(resourceName: "salad")
        case "Cafe":
            return #imageLiteral(resourceName: "coffee")
        default:
            return #imageLiteral(resourceName: "greenflag")
        }
    }
}


