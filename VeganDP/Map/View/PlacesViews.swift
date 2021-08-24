//
//   ArtworkViews.swift
//  VeganDP
//
//  Created by Леонід Шевченко on 17.08.2021.
//

import Foundation
import MapKit

class PlacesView: MKAnnotationView {
  override var annotation: MKAnnotation? {
    willSet {
      guard let place = newValue as? Place else {
        return
      }

      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 48, height: 48)))
      mapsButton.setBackgroundImage(#imageLiteral(resourceName: "Map"), for: .normal)
      rightCalloutAccessoryView = mapsButton

      image = place.image
      
      let detailLabel = UILabel()
      detailLabel.numberOfLines = 0
      detailLabel.font = detailLabel.font.withSize(12)
      detailLabel.text = place.subtitle
      detailCalloutAccessoryView = detailLabel
    }
  }
}




