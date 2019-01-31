//
//  findGroupController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by DottyPurkt on 14/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class FindGroupController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var accountList: [Account] = []
    var choosedRestaurant: Restaurant! = nil
    var observer: NSObject? = nil
    
    @IBOutlet weak var accountTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check if found and has no lobby
        var foundNoLobby = false
        
        // reload lobby automatically when lobby is add or remove
        observer = Database.database().reference().child("LobbyList/\(choosedRestaurant.placeId)").observe(.value) { (snapshot) in
            
            let sv = self.displaySpinner(onView: self.view, alpha: 0.6)
            
            if snapshot.exists() {  // if have any lobby
                foundNoLobby = false
                print("IN FIND GROUP PAGE : \(snapshot.childrenCount)")
                
                // get lobby from firebase
                database.getLobbyList(placeId: self.choosedRestaurant.placeId,completion: { (account) in
                    
                    if account.count == 0 {  // error
                        self.accountList = []
                        self.sendAlertUtil(Title: "No Lobby", Description: "Create or Join other restaurants")
                        self.accountTableView.reloadData()
                        self.removeSpinner(spinner: sv)
                    } else if !foundNoLobby{  // if found then reload
                        print("IN FIND GROUP PAGE : account.count = \(account.count)")
                        
                        self.accountList = account
                        self.accountTableView.reloadData()
                        self.removeSpinner(spinner: sv)
                    }
                })
            } else {  // no lobby
                self.accountList = []
                foundNoLobby = true
                self.sendAlertUtil(Title: "No Lobby", Description: "Create or Join other restaurants")
                self.accountTableView.reloadData()
                self.removeSpinner(spinner: sv)
            }
            } as NSObject
    }
    
    // tap on table view cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accountList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTableViewCell", for: indexPath) as! AccountTableViewCell
        cell.nameLabel.text = accountList[indexPath.row].name
        cell.usernameLabel.text = accountList[indexPath.row].username
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        Database.database().removeObserver(observer!, forKeyPath: "LobbyList/\(choosedRestaurant.placeId)")
        let controller = segue.destination as! GroupDetailController
        if let index = accountTableView.indexPathForSelectedRow {
            controller.ownerName = accountList[index.row].name
            controller.ownerUsername = accountList[index.row].username
            controller.placeId = choosedRestaurant.placeId
            controller.ownerId = accountList[index.row].uid
        }
        
        /*
        let controller = seque.destination as! SweetViewController
        if let index = tableView.indexPathForSelectedRow{
            controller.sweetText = data[index.row]
        }
         */
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
