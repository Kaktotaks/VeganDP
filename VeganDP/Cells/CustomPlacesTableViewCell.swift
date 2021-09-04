//
//  CustomPlacesTableViewCell.swift
//  VeganDP
//
//  Created by Леонід Шевченко on 20.08.2021.
//

import UIKit
import MapKit

protocol CustomPlacesTableViewCellDelegate {
    func openRegion(forItem item: Int)
}

class CustomPlacesTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var delegate: CustomPlacesTableViewCellDelegate?
    
    @IBOutlet weak var secondView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.secondView.layer.cornerRadius = 24    }

    
    @IBAction func locationButtonPressed(_ sender: Any) {
        self.delegate?.openRegion(forItem: self.tag)
    }
    
    func configure(with place: Place){
        self.locationTitleLabel.text = place.title
        self.descriptionLabel.text = place.descriptionText
        self.ratingLabel.text = place.rating
        self.cellImageView.image = place.image
    }
    
}
