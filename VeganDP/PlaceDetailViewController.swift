//
//  PlaceDetailViewController.swift
//  VeganDP
//
//  Created by Леонід Шевченко on 19.08.2021.
//

import Foundation
import RealmSwift
import WebKit
// Добавить импорт браузера

class PlaceDetailViewController: UIViewController, WKUIDelegate{

    
    @IBOutlet weak var detailWebView: WKWebView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let myURL = URL(string: "https://dollar.com.ua/")
        let myRequest = URLRequest(url: myURL!)
        detailWebView.load(myRequest)
        
    }
    
    
}
