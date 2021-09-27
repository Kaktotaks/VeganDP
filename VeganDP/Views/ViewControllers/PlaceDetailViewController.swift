//
//  PlaceDetailViewController.swift
//  VeganDP
//
//  Created by Леонід Шевченко on 19.08.2021.
//
import UIKit
import Foundation
import RealmSwift
import SafariServices


class PlaceDetailViewController: UIViewController{
    
    
    @IBOutlet weak var locationTypeImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumLabel: UILabel!
    @IBOutlet weak var dlGradientView: GradientView!
    @IBOutlet weak var pnGradientView: GradientView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var place: Place? = nil
    
    let realm = try? Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    func setupUI() {
        let placeCollectionViewCellIdentifier = String(describing: PlacesPhotosCollectionViewCell.self)
        
        self.collectionView.register(UINib(nibName: placeCollectionViewCellIdentifier, bundle: nil),
                                     forCellWithReuseIdentifier: placeCollectionViewCellIdentifier)
        
        self.descriptionLabel.text = self.place?.descriptionText
        self.locationTitleLabel.text = self.place?.title
        self.addressLabel.text = self.place?.subtitle
        self.locationTypeImageView.image = self.place?.image
        self.phoneNumLabel.text = self.place?.phoneNum
        
        self.dlGradientView.layer.cornerRadius = 16
        self.pnGradientView.layer.cornerRadius = 16
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView.reloadData()
        
        self.title = self.place?.title
        
        let logoutBarButtonItem = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(addToFavouriteButtonPressed))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
        
        
        
    }
    
    @IBAction func addToFavouriteButtonPressed(_ sender: Any) {
        let placeRealm = FavouritePlacesRealm()
        
        placeRealm.rating = self.place?.rating
        placeRealm.descriptionText = self.place?.descriptionText
        placeRealm.discipline = self.place?.discipline
        placeRealm.locationName = self.place?.locationName
        placeRealm.phoneNum = self.place?.phoneNum
        placeRealm.placeurl = self.place?.placeurl
        placeRealm.title = self.place?.title ?? ""
        
        
        try? realm?.write {
            realm?.add(placeRealm)
        }
        self.showAlert()
    }
    
    // Alert func when place added to favourites (addToFavouriteButtonPressed)
    func showAlert() {
        let alert = UIAlertController(title: Constants.Alerts.addedToFavourites, message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: Constants.Alerts.ok, style: .cancel, handler: { action in
            print(Constants.Alerts.tappedOk)
        }))
        
        present(alert, animated: true)
    }
    
    // Open website of picked places
    @IBAction func goToSafariWebButtonPressed(_ sender: Any) {
        if let placesURLString = self.place?.placeurl {
            if let placesURL = URL(string: placesURLString){
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
                
                let web = SFSafariViewController(url: placesURL, configuration: config)
                present(web, animated: true)
            }
        }
    }
    
    
}

//MARK: - CollectionView extensions
extension PlaceDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.place?.visualurl?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.placesPhotosCollectionViewCellIdentifier, for: indexPath) as? PlacesPhotosCollectionViewCell {
            cell.configureWith(profilePath: place?.visualurl?[indexPath.row])
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension PlaceDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 350, height: 200)
    }
}
