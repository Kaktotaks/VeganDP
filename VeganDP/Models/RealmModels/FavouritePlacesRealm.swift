//
//  FavouritePlacesRealm.swift
//  VeganDP
//
//  Created by Леонід Шевченко on 24.08.2021.
//

import Foundation
import RealmSwift

class FavouritePlacesRealm: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var locationName: String?
    @objc dynamic var discipline: String?
    @objc dynamic var rating: String?
    @objc dynamic var descriptionText : String?
    @objc dynamic var placeurl: String?
    @objc dynamic var visualurl: String?
    @objc dynamic var phoneNum: String?

}
