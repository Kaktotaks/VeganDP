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
  let coordinate: CLLocationCoordinate2D
  
  init(
    title: String?,
    locationName: String?,
    discipline: String?,
    rating: String?,
    descriptionText: String?,
    placeurl: String?,
    coordinate: CLLocationCoordinate2D
  ) {
    self.title = title
    self.locationName = locationName
    self.discipline = discipline
    self.rating = rating
    self.descriptionText = descriptionText
    self.placeurl = placeurl
    self.coordinate = coordinate
    
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


