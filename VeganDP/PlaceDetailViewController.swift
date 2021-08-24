//
//  PlaceDetailViewController.swift
//  VeganDP
//
//  Created by Леонід Шевченко on 19.08.2021.
//

import Foundation
import RealmSwift
import WebKit
import SafariServices

class PlaceDetailViewController: UIViewController, WKUIDelegate{
    
    
    @IBOutlet weak var locationTypeImageView: UIImageView!
    @IBOutlet weak var detailWebView: WKWebView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumLabel: UILabel!
    @IBOutlet weak var dlGradientView: GradientView!
    @IBOutlet weak var rlGradientView: GradientView!
    @IBOutlet weak var pnGradientView: GradientView!
    
    var place: Place? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.descriptionLabel.text = self.place?.descriptionText
        self.ratingLabel.text = self.place?.rating
        self.locationTitleLabel.text = self.place?.title
        self.addressLabel.text = self.place?.subtitle
        self.locationTypeImageView.image = self.place?.image
        self.phoneNumLabel.text = self.place?.phoneNum
        
        self.dlGradientView.layer.cornerRadius = 16
        self.rlGradientView.layer.cornerRadius = 16
        self.pnGradientView.layer.cornerRadius = 16
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getWebAddress()
        
    }
    
    // unwrap String property in URL
    func getWebAddress(){
        if let placesURLString = self.place?.placeurl {
            if let placesURL = URL(string: placesURLString) {
                let myRequest = URLRequest(url: placesURL)
                detailWebView.load(myRequest)
            }
        }
    }
    
    
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
    
    // MARK: добавить вызов по нажатию на кнопку телефона
//    func makePhoneCall(phoneNumber: String) {
//        if let phoneURLString = self.place?.phoneNum {
//            if let phoneURL = URL(string: phoneURLString){
//            let alert = UIAlertController(title: ("Call " + (place?.phoneNum)! + "?"), message: nil, preferredStyle: .alert)
//                   alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
//                       UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
//                   }))
//
//                   alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//                   self.present(alert, animated: true, completion: nil)
//               }
//    }
//    }
    
}
