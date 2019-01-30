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
    var restaurantList: [Restaurant] = []
    var choosedRestaurant: Restaurant? = nil
    @IBOutlet weak var categoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurantList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantByCategoryTableViewCell", for: indexPath) as! RestaurantTableViewCell
        cell.nameLabel.text = restaurantList[indexPath.row].name
        //cell.usernameLabel.text = accountList.getAt(index: indexPath.row).username
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.destination is ChooseActionController) {
            if let index = categoryTableView.indexPathForSelectedRow {
            
                let controller = segue.destination as! ChooseActionController
                
                // use for pop up back to previous view controller
                // because we can go to ChooseActionView by multiple ways
                controller.choosedRestaurant = restaurantList[index.item]
                print(controller.choosedRestaurant.name)
                controller.previousViewController = self
            }
        }
    
    }
    @IBAction func getShabu(_ sender: Any) {
        let sv = displaySpinner(onView: self.view,alpha: 0.6)
        database.getPlaceByCategory(category: "Shabu", completion: { (restaurants) in
            self.restaurantList = restaurants
            for restaurant in self.restaurantList {
                print(restaurant.name)
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            
            self.categoryTableView.reloadData()
            self.removeSpinner(spinner: sv)
        }
    }
    @IBAction func getDessert(_ sender: Any) {
        let sv = displaySpinner(onView: self.view,alpha: 0.6)
        database.getPlaceByCategory(category: "Dessert", completion: { (restaurants) in
            self.restaurantList = restaurants
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            
            self.categoryTableView.reloadData()
            self.removeSpinner(spinner: sv)
        }
    }
    @IBAction func getFastFood(_ sender: Any) {
        let sv = displaySpinner(onView: self.view,alpha: 0.6)
        database.getPlaceByCategory(category: "FastFood", completion: { (restaurants) in
            self.restaurantList = restaurants
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            
            self.categoryTableView.reloadData()
            self.removeSpinner(spinner: sv)
        }
    }
    @IBAction func getYakiniku(_ sender: Any) {
        let sv = displaySpinner(onView: self.view,alpha: 0.6)
        database.getPlaceByCategory(category: "Yakiniku", completion: { (restaurants) in
            self.restaurantList = restaurants
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            
            self.categoryTableView.reloadData()
            self.removeSpinner(spinner: sv)
        }
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
