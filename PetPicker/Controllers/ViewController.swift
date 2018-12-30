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
            let pp = PPApi.shared
            pp.loginUser(name: name, password: pass, completion: { (user) in
                self.loginSegue(user: user)
            })
        }
    }

    func loginSegue(user: User) {
        loggedInUser = user
        performSegue(withIdentifier: "successfulLogin", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navVC = segue.destination as? UINavigationController {
        let swipeVC = navVC.viewControllers.first as! SwipeViewController
            swipeVC.currentUser = loggedInUser
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let user = User.getUserFromDefault()
        if user.id > 0 {
            self.loginSegue(user: user)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

