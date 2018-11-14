//
//  StoreTableViewCell.swift
//  ShabuMaiJa-IOSClass
//
//  Created by DottyPurkt on 14/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class StoreTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func set(store: Store) {
        self.nameLabel.text = store.name
        self.typeLabel.text = store.type
    }
    
    var storeName: String {
        set(name) {
            self.nameLabel.text = name
        }
        get {
            return self.nameLabel.text!
        }
    }
    
    var storeType: String {
        set(type) {
            self.typeLabel.text = type
        }
        get {
            return self.typeLabel.text!
        }
    }
    
}
