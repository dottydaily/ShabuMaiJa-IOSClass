//
//  findGroupController.swift
//  ShabuMaiJa-IOSClass
//
//  Created by DottyPurkt on 14/11/2561 BE.
//  Copyright © 2561 iOS Dev. All rights reserved.
//

import UIKit

class FindGroupController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var storeList: StoreData = StoreData()
    
    @IBOutlet weak var storeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for _ in 1...5{
            self.storeList.add(store: Store(random: true))
        }
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storeList.total()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTableViewCell", for: indexPath) as! StoreTableViewCell
        cell.nameLabel.text = storeList.getAt(index: indexPath.row).name
        cell.typeLabel.text = storeList.getAt(index: indexPath.row).type
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
