//
//  ViewController.swift
//  PetPicker
//
//  Created by Steven Schwedt on 10/2/18.
//  Copyright © 2018 Steven Schwedt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func login(_ sender: UIButton) {
   
        if let name = userName.text {
            if let pass = password.text {
                let pp = PPApi()
                let user = pp.login(name: name, password: pass)
                print(user)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        
        let id = defaults.integer(forKey: "user_id")
        print(id)
        if id > 0 {
            print("I should segue")
            self.performSegue(withIdentifier: "successfulLogin", sender: nil)
        }
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
}

