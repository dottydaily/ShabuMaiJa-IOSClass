//
//  ReviewAllController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by Kanon Limprapaipong on 17/12/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class ReviewAllController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var ReviewAllTableView: UITableView!
    var hostUserID: String!
    
    var accountList: AccountData = AccountData()
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accountList.total()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewAllTableViewCell", for: indexPath) as! ReviewAllTableViewCell
        cell.nameLabel.text = accountList.getAt(index: indexPath.row).name
        cell.usernameLabel.text = accountList.getAt(index: indexPath.row).username
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var controller: ReviewController!
        if (segue.destination is ReviewController) {
            controller = segue.destination as! ReviewController
            
            // use for pop up back to previous view controller
            // because we can go to ChooseActionView by multiple ways
            controller.previousViewController = self
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        // Do any additional setup after loading the view.
        for _ in 1...20{
            self.accountList.add(account: Account(random: true))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
