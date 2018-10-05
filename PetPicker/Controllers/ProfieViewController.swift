//
//  ProfieViewController.swift
//  PetPicker
//
//  Created by Steven Schwedt on 10/4/18.
//  Copyright © 2018 Steven Schwedt. All rights reserved.
//

import UIKit

class ProfieViewController: UIViewController {

    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: "user")
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
