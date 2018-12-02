//
//  ShowCategoryListController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by Pornpat Santibuppakul on 11/30/18.
//  Copyright © 2018 iOS Dev. All rights reserved.
//

import UIKit

class ShowCategoryListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var accountList: AccountData = AccountData()
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for _ in 1...20{
            self.accountList.add(account: Account(random: true))
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accountList.total()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantByCategoryTableViewCell", for: indexPath) as! AccountTableViewCell
        cell.nameLabel.text = accountList.getAt(index: indexPath.row).name
        cell.usernameLabel.text = accountList.getAt(index: indexPath.row).username
        return cell
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
