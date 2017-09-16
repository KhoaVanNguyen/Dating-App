//
//  HashTagVC.swift
//  Dating App
//
//  Created by Khoa Nguyen on 9/16/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit
import ProgressHUD
import CoreLocation
class HashTagVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var constraintToBottom: NSLayoutConstraint!

    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var userTagCollectionView: UICollectionView!
    @IBOutlet weak var hashtagTF: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    var locationManager = CLLocationManager()
    let locationAuthStatus = CLLocationManager.authorizationStatus()
    
    
    var hashtags = [HashTag]()
    var userTags = [HashTag]()
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        locationManager.delegate = self
        hashtagTF.delegate = self
        
        
        configureAuthorizedStatus()
        userTagCollectionView.dataSource = self
        userTagCollectionView.delegate = self
        ProgressHUD.show("....")
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        DispatchQueue.main.async {
            DataService.instance.getAllHashTag { (hashtagData) in
                
                ProgressHUD.dismiss()
                self.hashtags = hashtagData
                self.collectionView.reloadData()
            }
            DataService.instance.loadUserTag(completion: { (userTags) in
                
            })
        }
        
        
        
        
    }
    
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        addNewHashTag()
        return false
    }
    
    @IBAction func send_TouchUpInside(_ sender: Any) {
        addNewHashTag()
        
    }
    
    func keyboardWillShow(_ notification : NSNotification ){
        
        
//        userTagCollectionView.isHidden = true
        
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
        UIView.animate(withDuration: 0.25) {
            self.constraintToBottom.constant = keyboardFrame!.height
//            self.collectionViewHeight.constant = keyboardFrame!.height * 2
            self.view.layoutIfNeeded()
        }
        
    }
    
    func keyboardWillHide(_ notification : NSNotification ){
        UIView.animate(withDuration: 0.1) {
            self.constraintToBottom.constant = 0
            
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    func addNewHashTag(){
        guard let hashtag = hashtagTF.text, hashtag != "" else {
            self.showAlert(title: APP_TITLE, message: "Hashtag không được trống")
            return
        }
        
        
        let formatHashTag = hashtag.removingWhitespaces()
        
        DataService.instance.addNewHashTag(hashtag: formatHashTag) { (complete) in
            if complete {
                self.hashtagTF.text = ""
            }
        }
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
//    func showAlert() {
//        let alert = UIAlertController(title: "Error", message: "We need your location to find the nearest jobs in your area. Please go to Settings to turn on location service", preferredStyle: .alert)
//        
//        
//        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
//            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
//                return
//            }
//            
//            if UIApplication.shared.canOpenURL(settingsUrl) {
//                if #available(iOS 10.0, *) {
//                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                        print("Settings opened: \(success)") // Prints true
//                    })
//                } else {
//                    // Fallback on earlier versions
//                }
//            }
//        }
//        alert.addAction(settingsAction)
//        
//        present(alert, animated: true, completion: nil)
//    }


}

extension HashTagVC: CLLocationManagerDelegate{
    func configureAuthorizedStatus(){
        if locationAuthStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }else if locationAuthStatus == .denied {
            print("in configureAuthorizedStatus")
        }
        else {
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            guard let coordinate = locationManager.location?.coordinate else {
                return
            }
            
            DataService.instance.lat = coordinate.latitude
            DataService.instance.lng = coordinate.longitude
            print(DataService.instance.lat)
            print(DataService.instance.lng)
            
        }else if status == .denied {
//            showAlert()
        }
    }
}

extension HashTagVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == userTagCollectionView {
            return userTags.count
        }
        
        return hashtags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == userTagCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HashTagCell", for: indexPath) as? HashTagCell {
                
                cell.configureCell(tag: userTags[indexPath.row].content)
                return cell
            }
        }
        
        
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HashTagCell", for: indexPath) as? HashTagCell {
            
            cell.configureCell(tag: hashtags[indexPath.row].content)
            return cell
        }
        
        return UICollectionViewCell()
        
    }
}
extension HashTagVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        
        userTags.append(hashtags[indexPath.row])
        
        DispatchQueue.main.async {
            DataService.instance.addNewHashTag(hashtag: self.hashtags[indexPath.row].content) { (complete) in
            }
        }
        
        userTagCollectionView.reloadData()
    }
    
}
extension HashTagVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
//        
//        if collectionView == userTagCollectionView {
//            
//        }
//        
        
        
        let size: CGSize = hashtags[indexPath.row].content.size(attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17.0)])
        
        return CGSize(width: size.width * 2, height: size.height * 2)
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 28
//    }
    

    
    
    
}


