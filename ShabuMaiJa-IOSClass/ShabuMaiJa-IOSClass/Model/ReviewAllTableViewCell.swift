//
//  ReviewAllTableViewCell.swift
//  ShabuMaiJa-IOSClass
//
//  Created by Kanon Limprapaipong on 17/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class ReviewAllTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func set(account: Account) {
        self.nameLabel.text = account.name
        self.usernameLabel.text = account.username
    }
    
    var accountName: String {
        set(name) {
            self.nameLabel.text = name
        }
        get {
            return self.nameLabel.text!
        }
    }
    
    var accountUsername: String {
        set(type) {
            self.usernameLabel.text = type
        }
        get {
            return self.usernameLabel.text!
        }
    }

}
