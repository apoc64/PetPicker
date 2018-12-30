//
//  NewUserViewController.swift
//  PetPicker
//
//  Created by Tyler Westlie  on 10/15/18.
//  Copyright © 2018 Steven Schwedt. All rights reserved.
//

import UIKit

class NewUserViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPass: UITextField!
    @IBOutlet weak var confirmUserPass: UITextField!
    @IBOutlet weak var userPic: UITextField!
    @IBOutlet weak var userDesc: UITextView!
    @IBOutlet weak var userSpecies: UIPickerView!
    @IBOutlet weak var userRole: UISwitch!
    
    // add validation to enable button
    
    @IBAction func userSave(_ sender: UIButton) {
        guard userPass.text == confirmUserPass.text else {
            print("password incorrect")
            return
        }
        let roleString = userRole.isOn ? "owner" : "adopter"
        let userData = ["user": ["name": userName.text!, "password": userPass.text!, "description": userDesc.text!, "pic": userPic.text!, "role": roleString]]
        PPApi.shared.createUser(data: userData, completion: { (_) in
            self.loginSegue()
        })
    }
    
    func loginSegue() {
        performSegue(withIdentifier: "successfulLogin", sender: nil)
    }
    
    // Prepare - pass logged in user to swipt VC?
}
