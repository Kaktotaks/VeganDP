//
//  ViewController.swift
//  VeganDP
//
//  Created by Леонід Шевченко on 12.08.2021.
//

import UIKit
import MapKit
import RealmSwift

class ViewController: UIViewController {
    
    // Создаем объект реалм
    let realm = try? Realm()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placesMenuButton: UIButton!
    @IBOutlet weak var closeMenuButton: UIButton!
    
    private var places: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "VeganDP"
        
        self.tableView.register(UINib(nibName: "CustomPlacesTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomPlacesTableViewCell")
        
        // Set initial location in DP
        let initialLocation = CLLocation(latitude: 48.458130, longitude: 35.047344)
        mapView.centerToLocation (initialLocation)
        
        //Adding a scale and restriction to the map (Visual area)
        let dniproCenter = CLLocation(latitude: 48.458130, longitude: 35.047344)
        let region = MKCoordinateRegion(
            center: dniproCenter.coordinate,
            latitudinalMeters: 15000,
            longitudinalMeters: 15000)
        mapView.setCameraBoundary(
            MKMapView.CameraBoundary(coordinateRegion: region),
            animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 60000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        
        mapView.delegate = self
        
        mapView.register(
            PlacesView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        loadInitialData()
        mapView.addAnnotations(places)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Во время появления контроллера выполняем загрузку мест:
        //        self.requestDPPlaces()
        
    }
    
    
    
    
    
    private func loadInitialData() {
        // 1
        guard
            let fileName = Bundle.main.url(forResource: "VeganRestaurantCafeDP", withExtension: "geojson"),
            let placesData = try? Data(contentsOf: fileName)
        else {
            return
        }
        
        do {
            // 2
            let features = try MKGeoJSONDecoder()
                .decode(placesData)
                .compactMap { $0 as? MKGeoJSONFeature }
            // 3
            let validPlaces = features.compactMap(Place.init)
            // 4
            places.append(contentsOf: validPlaces)
        } catch {
            // 5
            print("Unexpected error: \(error).")
        }
    }
    
    // Show tableview
    @IBAction func placesMenuButtonPressed(_ sender: Any) {
        UITableView.animate(withDuration: 1,
                            delay: 0,
                            usingSpringWithDamping: 10,
                            initialSpringVelocity: 0)
        {self.tableView.frame = CGRect(x: 0,
                                       y: 576,
                                       width: 428,
                                       height: 267) };
        UIButton.animate(withDuration: 1,
                         delay: 0,
                         usingSpringWithDamping: 10,
                         initialSpringVelocity: 0 )
        {self.placesMenuButton.frame = CGRect(x: 180,
                                              y: 851,
                                              width: 64,
                                              height: 40) };
        UIButton.animate(withDuration: 1,
                         delay: 0,
                         usingSpringWithDamping: 10,
                         initialSpringVelocity: 0)
        {self.closeMenuButton.frame = CGRect(x: 350,
                                             y: 510,
                                             width: 50,
                                             height: 50) }
    }
    
    
    // Hide tableView
    @IBAction func closeMenuButtonPressed(_ sender: Any) {
        
        UITableView.animate(withDuration: 1,
                            delay: 0,
                            usingSpringWithDamping: 10,
                            initialSpringVelocity: 0)
        {self.tableView.frame = CGRect(x: 0,
                                       y: 900,
                                       width: 428,
                                       height: 267) };
        UIButton.animate(withDuration: 1,
                         delay: 0,
                         usingSpringWithDamping: 10,
                         initialSpringVelocity: 0 )
        {self.closeMenuButton.frame = CGRect(x: -50,
                                             y: 525,
                                             width: 50,
                                             height: 50) };
        UIButton.animate(withDuration: 1,
                         delay: 0,
                         usingSpringWithDamping: 10,
                         initialSpringVelocity: 0 )
        {self.placesMenuButton.frame = CGRect(x: 182,
                                              y: 797,
                                              width: 64,
                                              height: 40) }
        
    }
    
    
}




//! - Расширение для карты

private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 3000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}


extension ViewController: MKMapViewDelegate {
    
    func mapView(
        _ mapView: MKMapView,
        annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl
    ) {
        guard let place = view.annotation as? Place else {
            return
        }
        
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ]
        place.mapItem?.openInMaps(launchOptions: launchOptions)
    }
    
}

//! - Расширения для таблицы

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomPlacesTableViewCell") as? CustomPlacesTableViewCell else { return UITableViewCell() }
        cell.configure(with: places[indexPath.row])
        cell.delegate = self
        cell.tag = indexPath.row
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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


extension ViewController: CustomPlacesTableViewCellDelegate {
    func openRegion(forItem item: Int) {
        let geoObject = self.places[item]
        
        let latitude = geoObject.latitude ?? 0
        let longitude = geoObject.longitude ?? 0
        
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: coordinates,
                                        latitudinalMeters: 500,
                                        longitudinalMeters: 500)
        self.mapView.setRegion(region, animated: true)
    }
    
    //    func openRegion(_ region: MKCoordinateRegion) {
    //        self.mapView.setRegion(region, animated: true)
    //    }
}



