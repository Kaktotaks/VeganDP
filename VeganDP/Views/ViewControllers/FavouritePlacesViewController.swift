//
//  FavouritePlacesViewController.swift
//  VeganDP
//
//  Created by Леонід Шевченко on 24.08.2021.
//


import UIKit
import RealmSwift
import MapKit


class FavouritePlacesViewController: UIViewController, CustomPlacesTableViewCellDelegate {
    func openRegion(forItem item: Int) {}
    
    var places: [FavouritePlacesRealm] = []
    
    let realm = try? Realm()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Constants.ViewControllerTitles.favourites
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: Constants.customPlacesTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: Constants.customPlacesTableViewCellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.places = self.getPlaces()
        self.tableView.reloadData()
    }
    
    private func getPlaces() -> [FavouritePlacesRealm] {
        
        var places = [FavouritePlacesRealm]()
        guard let placesResults = realm?.objects(FavouritePlacesRealm.self) else { return [] }
        for place in placesResults {
            places.append(place)
        }
        return places
    }
    
}

//MARK: TableView extensions
extension FavouritePlacesViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.customPlacesTableViewCellIdentifier) as? CustomPlacesTableViewCell else { return UITableViewCell() }
        cell.configureRealm(with: places[indexPath.row])
        cell.delegate = self
        cell.tag = indexPath.row
        return cell
    }
    
}


extension FavouritePlacesViewController: UITableViewDelegate {
    
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
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            places.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
        }
    }
}
