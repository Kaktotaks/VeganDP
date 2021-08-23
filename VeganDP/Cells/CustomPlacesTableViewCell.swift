//
//  CustomPlacesTableViewCell.swift
//  VeganDP
//
//  Created by Леонід Шевченко on 20.08.2021.
//

import UIKit
import MapKit

class CustomPlacesTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBAction func locationButtonPressed(_ sender: Any) {
        
        
    }
    
    func configure(with place: Place){
        self.locationTitleLabel.text = place.title
        self.descriptionLabel.text = place.descriptionText
        self.ratingLabel.text = place.rating
        self.cellImageView.image = place.image
    }
    
}
