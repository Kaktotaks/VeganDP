//
//  PlaceDetailViewController.swift
//  VeganDP
//
//  Created by Леонід Шевченко on 19.08.2021.
//

import Foundation
import RealmSwift
import WebKit

class PlaceDetailViewController: UIViewController, WKUIDelegate{

    
    @IBOutlet weak var detailWebView: WKWebView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var place: Place? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.descriptionLabel.text = self.place?.descriptionText
        self.ratingLabel.text = self.place?.rating
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
//        var placesurl = self.place?.placeurl
//        let myURL = URL(string: "\(placesurl)")
//        let myRequest = URLRequest(url: myURL)
//        detailWebView.load(myRequest)
        
        var placesurl = self.place?.placeurl
        let myRequest = URLRequest(url: placesurl)
        detailWebView.load(myRequest)
        
        
        
        
    }
    
   

    
    
}
