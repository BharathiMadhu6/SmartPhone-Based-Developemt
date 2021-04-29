//
//  ViewController.swift
//  AddToCart
//
//  Created by bharathi madhu on 4/20/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import SwiftSpinner
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var lblEmail: UITextField!
    
    @IBOutlet weak var lblPassword: UITextField!
        
    @IBOutlet weak var lblStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStatus.text = ""
    }
    
    //loads when the app is launched
    override func viewDidAppear(_ animated: Bool) {
        let keyChain = KeychainService().keyChain
        
        if keyChain.get("uid") != nil {
            identifier = keyChain.get("uid")!
            performSegue(withIdentifier: "dashboardSegue", sender: self)
        }
        
        lblPassword.text = ""
    }
    
    
    func addKeyChainAfterLogin(_ uid: String) {
        let keyChain = KeychainService().keyChain
        keyChain.set(uid, forKey: "uid")
    }
    
    @IBAction func loginAction(_ sender: Any) {
        let email = lblEmail.text!
        let password = lblPassword.text!
                
        if email == "" || password == "" || password.count < 6 {
            lblStatus.text = "Please enter a valid email / Password"
            return
        }
        
        if email.isEmail == false {
            lblStatus.text = "Please enter a valid email"
            return
        }
        
        SwiftSpinner.show("Loggin you in")
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            SwiftSpinner.hide()
            guard let self = self else {return}
            
            if error != nil {
                self.lblStatus.text = error?.localizedDescription
                return
            }
            
            let ref = Database.database().reference()
            
            
            //before loggin in, add the credentials in the keychain so that the user need not login repeatedly
            
            let uid = Auth.auth().currentUser!.uid
            
            self.addKeyChainAfterLogin(uid)
            identifier = uid
            var userExists = ""
            ref.child("users").observe(.value) { (snapshot) in
                for child in snapshot.children {
                    let childSnapshot = child as! DataSnapshot
                    _ = childSnapshot.key as String
                    let dictionary = childSnapshot.value as? [String:Any]
                    let userEmail = dictionary?["username"] as? String
                    
                    if userEmail == email {
                        userExists = userEmail!
                        userEmailId = email
                    }
                }
                
                
                if userExists == "" {
                    ref.child("users/\(uid)").setValue(["username":"\(email)", "cart":""])
                    userEmailId = email
                }
            }
            
            
            self.performSegue(withIdentifier: "dashboardSegue", sender: self)
        }
        
    }
}

