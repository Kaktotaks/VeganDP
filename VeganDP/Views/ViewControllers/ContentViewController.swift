//
//  ContentViewController.swift
//  VeganDP
//
//  Created by Леонід Шевченко on 15.07.2022.
//

import UIKit
import MapKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var contentTableView: UITableView!
    private var places: [Place] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTableView.register(UINib(nibName: Constants.customPlacesTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: Constants.customPlacesTableViewCellIdentifier)

        contentTableView.dataSource = self
        contentTableView.delegate = self
        loadInitialData()
    }
    
    func loadInitialData() {
        guard
            let fileName = Bundle.main.url(forResource: "VeganRestaurantCafeDP", withExtension: "geojson"),
            let placesData = try? Data(contentsOf: fileName)
        else {
            return
        }
        do {
            let features = try MKGeoJSONDecoder()
                .decode(placesData)
                .compactMap { $0 as? MKGeoJSONFeature }
            
            let validPlaces = features.compactMap(Place.init)
            
            places.append(contentsOf: validPlaces)
        } catch {
            
            print("Unexpected error: \(error).")
        }
    }
    
}

//MARK:- TableView extensions
extension ContentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomPlacesTableViewCell") as? CustomPlacesTableViewCell else { return UITableViewCell() }
        cell.configure(with: places[indexPath.row])
//        cell.delegate = self
        cell.tag = indexPath.row
        return cell
    }
}

extension ContentViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let identifier = String(describing: PlaceDetailViewController.self)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailViewController = storyboard.instantiateViewController(identifier: identifier) as? PlaceDetailViewController {
            detailViewController.place = self.places[indexPath.row]

            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }

    //Appearing cells animation
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.75) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
}

//extension ContentViewController: CustomPlacesTableViewCellDelegate {
//    
//    func openRegion(forItem item: Int) {
//        let geoObject = self.places[item]
//        
//        let latitude = geoObject.latitude ?? 0
//        let longitude = geoObject.longitude ?? 0
//        
//        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        let region = MKCoordinateRegion(center: coordinates,
//                                        latitudinalMeters: 500,
//                                        longitudinalMeters: 500)
//        self.mapView.setRegion(region, animated: true)
//    }
//}
