//
//  PlacesPhotosCollectionViewCell.swift
//  VeganDP
//
//  Created by Леонід Шевченко on 12.09.2021.
//

import UIKit
import SDWebImage
import os

class PlacesPhotosCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.cellImageView.layer.cornerRadius = 16
    }
    
    
    func configureWith(profilePath: String?) {
        self.loadImage(profilePath: profilePath)
    }
    
    private func loadImage(profilePath: String?) {

        guard let profilePath = profilePath else {
            os_log("RrofilePath is nil")
            return
        }
        let imageURL = URL(string: profilePath)
        self.cellImageView.sd_setImage(with: imageURL, completed: nil)
    }

}
