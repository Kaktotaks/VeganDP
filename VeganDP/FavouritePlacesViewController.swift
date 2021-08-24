//
//  FavouritePlacesViewController.swift
//  VeganDP
//
//  Created by Леонід Шевченко on 24.08.2021.
//


import UIKit
import RealmSwift

class FavouritePlacesViewController: UIViewController {
    
    var places: [FavouritePlacesRealm] = []
    
    let realm = try? Realm()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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

extension FavouritePlacesViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = self.places[indexPath.row].title
        return cell ?? UITableViewCell()
    }

    
}
