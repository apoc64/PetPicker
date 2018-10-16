//
//  ProfieViewController.swift
//  PetPicker
//
//  Created by Steven Schwedt on 10/4/18.
//  Copyright © 2018 Steven Schwedt. All rights reserved.
//

import UIKit
import SDWebImage

class ProfieViewController: UIViewController {
    var user: User!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var roleSwitch: UISwitch!
    @IBOutlet weak var speciesPicker: UIPickerView!
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: "user")
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        user.description = descriptionView.text
        if roleSwitch.isOn {
            user.role = "owner"
        } else {
            user.role = "adopter"
        }
        let data = ["user": ["name": user.name, "description": user.description, "role": user.role]]
        
        let pp = PPApi(sendingVC: self)
        pp.updateUserApi(data: data, id: user.id)
        user.setAsDefault()
        performSegue(withIdentifier: "savedProfile", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = user.name
        picImageView.sd_setImage(with: URL(string: user.pic), placeholderImage: UIImage(named: "placeholder.png"))
        descriptionView.text = user.description
        if user.role == "owner" {
            roleSwitch.isOn = true
        }
        
    }
    

    
//    MARK: - Navigation
    
//    In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        Get the new view controller using segue.destination.
//        Pass the selected object to the new view controller.
        if let navVC = segue.destination as? UINavigationController {
            let swipeVC = navVC.viewControllers.first as! SwipeViewController
            swipeVC.currentUser = user
        }
    }
    
    
}
