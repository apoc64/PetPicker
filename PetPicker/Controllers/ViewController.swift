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
        
        if let name = userName.text, let pass = password.text {
            let pp = PPApi(sendingVC: self)
            pp.login(name: name, password: pass)
        }
    }
    
    func loginSegue() {
        performSegue(withIdentifier: "successfulLogin", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // check to see if logged in already
        let defaults = UserDefaults.standard
        
        let id = defaults.integer(forKey: "user_id")
        print(id)
        if id > 0 {
            print("I should segue")
            self.loginSegue()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
}

