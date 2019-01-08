//
//  ShowPriceListController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by DottyPurkt on 30/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class ShowPriceListController: UIViewController {
    
    var previousViewController: UIViewController! = nil
    var restaurantList: [Restaurant] = []
    var min : Double = 0
    var max : Double = 0
    
  
    @IBOutlet weak var restaurantTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            database.getPlaceByPrice(minPrice: 100, maxPrice: 500, completion: { (restaurants) in
                self.restaurantList = restaurants
            })
            self.restaurantTableView.reloadData()
            print(self.restaurantList)
        }
        
        // Do any additional setup after loading the view.
//        for _ in 1...20{
//            self.accountList.add(account: Account(random: true))
//        }
        // do some magic here
        print("--------\n")
        print(restaurantList.count)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! ChooseActionController
        
        // use for pop up back to previous view controller
        // because we can go to ChooseActionView by multiple ways
        controller.previousViewController = self
    }
}
extension ShowPriceListController : UITableViewDelegate, UITableViewDataSource {
    // tap on table view cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurantList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantByPriceTableViewCell", for: indexPath) as! RestaurantTableViewCell
        let min = restaurantList[indexPath.row].minPrice
        let stringPrice : String = String(format:"%f",min)
        cell.nameLabel.text = restaurantList[indexPath.row].name
        cell.priceLabel.text = stringPrice
        return cell
    }
}
