//
//  MatchVC.swift
//  Dating App
//
//  Created by Khoa Nguyen on 9/17/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit

class MatchVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    
    var users = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.dataSource = self
        tableView.delegate = self
        
        
//        self.tabBarController?.delegate = self as! UITabBarControllerDelegate
        
        let u1 = User(id: "Wd9Ow2xKqwVKU", matchTags: 19, gender: 1)
        let u2 = User(id: "MNgnf3dfl2W", matchTags: 4, gender: 1)
        let u3 = User(id: "HiHFLSwc7ASBxZq", matchTags: 60, gender: 1)
        let u4 = User(id: "HiHFLSwc7ASBxZ", matchTags: 7, gender: 1)
        
        users.append(contentsOf: [u1,u2,u3,u4])
        
        users = users.sorted { $0.matchTags > $1.matchTags }
        
        
    
        tableView.reloadData()
        
    }
}

extension MatchVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MatchCell", for: indexPath) as? MatchCell else {
            return UITableViewCell()
        }
        cell.configureCell(user: users[indexPath.row])
        return cell
    }
}
extension MatchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        
        DataService.instance.addNewConversation(recipientId: users[indexPath.row].id) { (converId) in
            self.tabBarController?.selectedIndex = 2
        }
    
    }
}




