//
//  RestaurantTableViewCell.swift
//  ShabuMaiJa-IOSClass
//
//  Created by DottyPurkt on 2/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bahtLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    func set(restaurant: Restaurant) {
        let min = restaurant.minPrice
        let stringPrice : String = String(format:"%f",min)
        self.nameLabel.text = restaurant.name
        self.priceLabel.text = stringPrice
        self.bahtLabel.text = "Baht"
    }
    var restaurantName: String {
        set(name) {
            self.nameLabel.text = name
        }
        get {
            return self.nameLabel.text!
        }
    }
    
    var restaurantPrice: String {
        set(type) {
            self.priceLabel.text = type
        }
        get {
            return self.priceLabel.text!
        }
    }

}
