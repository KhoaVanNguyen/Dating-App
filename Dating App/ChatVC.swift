//
//  ChatVC.swift
//  Dating App
//
//  Created by Khoa Nguyen on 9/16/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var conversations = [Conversation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        DataService.instance.loadAllConversation { (conversations) in
            self.conversations = conversations
            self.tableView.reloadData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ChatVCToChatDetailVC" {
//            if let detailVC = segue.destination as? ChatDetailVC {
//                if let conver = sender as? Conversation {
//                    print("HERE")
//                    print(conver)
//                    detailVC.conversation = conver
//                }
//            }
//            
//        }
        let nav = segue.destination as? UINavigationController
        
        let chatdetailVC = nav?.viewControllers.first as! ChatDetailVC
        if let conver = sender as? Conversation {
                                print("HERE")
                                print(conver)
                        chatdetailVC.conversation = conver
        }
    
        
    }
}

extension ChatVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath)
        cell.textLabel?.text = conversations[indexPath.row].id
        return cell
    }
}

extension ChatVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ChatVCToChatDetailVC", sender: conversations[indexPath.row])
        
    }
}





