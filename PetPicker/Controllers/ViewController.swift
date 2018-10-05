//
//  ViewController.swift
//  PetPicker
//
//  Created by Steven Schwedt on 10/2/18.
//  Copyright © 2018 Steven Schwedt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var loggedInUser: User!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func login(_ sender: UIButton) {
        if let name = userName.text, let pass = password.text {
            let pp = PPApi(sendingVC: self)
            pp.login(name: name, password: pass)
        }
    }
    
    func loginSegue(user: User) {
        loggedInUser = user
        performSegue(withIdentifier: "successfulLogin", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let vc = segue.destination as! SwipeViewController
        // Pass the selected object to the new view controller.
        vc.currentUser = loggedInUser
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        // check to see if logged in already
//        let defaults = UserDefaults.standard
//        let id = defaults.integer(forKey: "user_id")
//        // get actual user object
//        let user = User(data: ["id": id])
////        print(user)
       let user = User.getUserFromDefault()
        if user.id > 0 {
            print("I should segue")
            self.loginSegue(user: user)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

