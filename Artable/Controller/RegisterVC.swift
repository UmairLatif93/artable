//
//  RegisterVC.swift
//  Artable
//
//  Created by Umair Latif on 16/10/2019.
//  Copyright © 2019 Umair Latif. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController, UITextFieldDelegate {
    
    //Outlets
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var cnfrmPasswordTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passCheckImg: UIImageView!
    @IBOutlet weak var confirmPassCheckImg: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        passwordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        cnfrmPasswordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        guard let passTxt = passwordTxt.text else { return }
        
        if textField == cnfrmPasswordTxt {
            
            passCheckImg.isHidden = false
            confirmPassCheckImg.isHidden = false
        }else {
            
            if passTxt.isEmpty {
                
                passCheckImg.isHidden = true
                confirmPassCheckImg.isHidden = true
                cnfrmPasswordTxt.text = ""
            }
        }
        
        if passwordTxt.text == cnfrmPasswordTxt.text {
            
            passCheckImg.image = UIImage(named: AppImages.GreenCheck)
            confirmPassCheckImg.image = UIImage(named: AppImages.GreenCheck)
            
        }else {
            
            passCheckImg.image = UIImage(named: AppImages.RedCheck)
            confirmPassCheckImg.image = UIImage(named: AppImages.RedCheck)
        }
    }

    @IBAction func RegisterClicked(_ sender: UIButton) {
            
        guard let email = emailTxt.text , email.isNotEmpty ,
        let username = userNameTxt.text , username.isNotEmpty ,
        let password = passwordTxt.text , password.isNotEmpty else {
            
                simpleAlert(title: "Error", msg: "Please fill out all fields.")
                return
            }
        
        guard let confirmPass = cnfrmPasswordTxt.text , confirmPass == password else {
            
            simpleAlert(title: "Error", msg: "Passwords do not match.")
            return
        }
        
        activityIndicator.startAnimating()
        
        guard let authUser = Auth.auth().currentUser else { return }
        
        let credentials = EmailAuthProvider.credential(withEmail: email, password: password)
        
        authUser.link(with: credentials) { (result, error) in
            
            if let error = error {
                
                debugPrint(error)
                self.activityIndicator.stopAnimating()
                Auth.auth().handleFireAuthError(error: error, vc: self)
                return
            }
            
            self.activityIndicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
        }
    }
}
