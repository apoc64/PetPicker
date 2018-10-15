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
    @IBAction func userSave(_ sender: UIButton) {
        print("username: \(userName.text)")
        print("pass:\(userPass.text)")
        print("confirm:\(confirmUserPass.text)")
        print("pic:\(userPic.text)")
        print("description: \(userDesc.text)")
        print("role:\(userRole.isOn)")
        print("species:\(userSpecies)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
