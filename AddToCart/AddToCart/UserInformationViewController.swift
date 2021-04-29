//
//  UserInformationViewController.swift
//  AddToCart
//
//  Created by bharathi madhu on 4/28/21.
//

import UIKit

class UserInformationViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtPincode: UITextField!
    
    @IBOutlet weak var txtAddress: UITextField!
    
    @IBOutlet weak var txtState: UITextField!
    
    @IBOutlet weak var txtPhone: UITextField!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        txtName?.delegate = self
        txtPhone?.delegate = self
        txtAddress?.delegate = self
        txtPincode?.delegate = self
        txtState?.delegate = self
        btnSubmit?.isUserInteractionEnabled = false
        btnSubmit?.alpha = 0.5

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let textName = txtName.text! as String
        let textAddress = txtAddress.text! as String
        let textPincode = txtPincode.text! as String
        let textState = txtState.text! as String
        let textPhone = txtPhone.text! as String


        if textName != "" && textAddress != "" && textState != "" && textPincode != "" && textPhone != ""{
                btnSubmit?.isUserInteractionEnabled = true
                btnSubmit?.alpha = 1.0
            } else {
                btnSubmit?.isUserInteractionEnabled = false
                btnSubmit?.alpha = 0.5
            }
            return true
        }
}
