//
//  ViewController.swift
//  Dating App
//
//  Created by Khoa Nguyen on 9/16/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit
import ProgressHUD
class LoginVC: UIViewController {
    @IBOutlet weak var emailTF: UITextField!

    @IBOutlet weak var passwordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    @IBAction func login_TouchUpInside(_ sender: Any) {
        
        emailTF.text = "user@gmail.com"
        passwordTF.text = "123456"
        
        guard let email = emailTF.text, email != "" else {
            showAlert(title: "Erorr", message: "Vui lòng nhập tên tài khoản")
            return
        }
        guard let password = passwordTF.text, password != ""  else {
            showAlert(title: "Erorr", message: "Vui lòng nhập mật khẩu")
            return
        }
        
        ProgressHUD.show("Đang đăng nhập")
        
        AuthService.instance.loginUser(withEmail: email, andPassword: password) { (complete, erorr) in
            
            
            ProgressHUD.showSuccess("...")
            if !complete {
                
                if (erorr! as NSError).code == 17011 {
                    
                    let alert = UIAlertController(title: APP_TITLE, message: LOGIN_NEW_ACCOUNT_WARNING, preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Đồng ý", style: .default, handler:  {
                        action in
                        AuthService.instance.registerUser(withEmail: email, andPassword: password, userCreationComplete: { (isComplete, erorr) in
                            
                            
                            if erorr != nil {
                                self.showAlert(title: "ERROR", message: (erorr?.localizedDescription)!)
                            }else {
                                self.performSegue(withIdentifier: "LoginToTabbar", sender: nil)
                            }
                            
                            
                        })
                    })
                    
                    let cancelAction = UIAlertAction(title: "Hem", style: .default, handler: nil)
                
                    alert.addAction(okAction)
                    alert.addAction(cancelAction)
                    
                    self.present(alert, animated: true, completion: nil)

                    
                    
                }
                
                self.showAlert(title: "ERROR", message: (erorr?.localizedDescription)!)
            }
            else {
                 self.performSegue(withIdentifier: "LoginToTabbar", sender: nil)
            }
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.self.endEditing(true)
    }
    
    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }


}

