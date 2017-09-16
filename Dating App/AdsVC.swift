//
//  AdsVC.swift
//  Dating App
//
//  Created by Khoa Nguyen on 9/17/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit

protocol AdsVCDelegate {
    func invite(ad: Ad)
}


class AdsVC: UIViewController {

    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var ads = [Ad]()
    
    var delegate: AdsVCDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        let backBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(self.back_TouchUpInside))
        backBtn.tintColor = #colorLiteral(red: 0.952462852, green: 0.3920735717, blue: 0.9882180095, alpha: 1)
        navigationItem.setLeftBarButton(backBtn, animated: true)
        
        
       
        loadData(type: 0)
        
    }
    
    func loadData(type: Int){
        DataService.instance.loadAds(type: type) { (ads) in
            self.ads = ads
            self.tableView.reloadData()
        }
    }

    func back_TouchUpInside(){
    
        dismiss(animated: true, completion: nil)
    }

    @IBAction func segment_ValueChanged(_ sender: Any) {
        
        switch segment.selectedSegmentIndex {
        case 0:
            loadData(type: 0)
        case 1:
            loadData(type: 1)
        case 2:
            loadData(type: 2)
        default:
            loadData(type: 3)
        }
    }

}

extension AdsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ads.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdCell", for: indexPath) as? AdCell else {
            return UITableViewCell()
        }
        cell.configureCell(ad: ads[indexPath.row], index: indexPath.row + 1)
        return cell
    }
}
extension AdsVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.invite(ad: ads[indexPath.row])
        back_TouchUpInside()
        
        
    }
}
