//
//  ShowPriceListController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by DottyPurkt on 30/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class ShowPriceListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var accountList: AccountData = AccountData()
    
    @IBOutlet weak var restaurantTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        for _ in 1...20{
            self.accountList.add(account: Account(random: true))
        }
    }
    
    // tap on table view cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accountList.total()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantByPriceTableViewCell", for: indexPath) as! AccountTableViewCell
        cell.nameLabel.text = accountList.getAt(index: indexPath.row).name
        cell.usernameLabel.text = accountList.getAt(index: indexPath.row).username
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! ChooseActionController
        
        // use for pop up back to previous view controller
        // because we can go to ChooseActionView by multiple ways
        controller.previousViewController = self
    }

    
    
    
    

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}