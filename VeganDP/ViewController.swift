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
    
    private var places: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Регистрируем ячейку для UITableView, по идентификатору Cell. Если вы создаете свою (кастомную) ячейку, вы должны указать ее класс вместо UITableViewCell
        self.tableView.register(UINib(nibName: "CustomPlacesTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomPlacesTableViewCell")
        
        // Set initial location in Honolulu
        let initialLocation = CLLocation(latitude: 48.458130, longitude: 35.047344)
        mapView.centerToLocation (initialLocation)
        
        //Adding a scale and restriction to the map (Visual area)
        let oahuCenter = CLLocation(latitude: 48.458130, longitude: 35.047344)
        let region = MKCoordinateRegion(
          center: oahuCenter.coordinate,
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
    
    func requestDPPlaces() {
// код для загрузки мест
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

//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
//            return UITableViewCell()
//        }
//
//        cell.textLabel?.text = self.places[indexPath.row].title
//        cell.selectionStyle = .none
//
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomPlacesTableViewCell") as? CustomPlacesTableViewCell else { return UITableViewCell() }
        cell.configure(with: places[indexPath.row])
        return cell
    }
}

extension ViewController: UITableViewDelegate {

    /// Метод срабатывает по нажатию на ячейку tableView
    /// - Parameters:
    ///   - tableView: Наша таблица (UITableView)
    ///   - indexPath: Индекс выбранной ячейки. Имеет параметр .section и .row, мы используем .row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let identifier = String(describing: MediaDetailViewController.self)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let detailViewController = storyboard.instantiateViewController(identifier: identifier) as? MediaDetailViewController {
            
//            detailViewController.movie = self.movies[indexPath.row]
            
//            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }



