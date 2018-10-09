//
//  SwipeViewController.swift
//  PetPicker
//
//  Created by Tyler Westlie  on 10/2/18.
//  Copyright © 2018 Steven Schwedt. All rights reserved.
//

import UIKit
import SDWebImage


class SwipeViewController: UIViewController {
    
    var currentUser: User?
    var pets: [Pet] = []

    @IBOutlet weak var card: UIView!
    @IBOutlet weak var cardName: UILabel!
    var divisor: CGFloat!
    
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardDescription: UILabel!
    
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        card.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor)
        
        if sender.state == UIGestureRecognizer.State.ended {
            if card.center.x < 75 {
                // move to left
                UIView.animate(withDuration: 0.2, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.alpha = 0
                }, completion: { _ in
                    self.cardName.text = "Nope!"
                })
                return
            } else if card.center.x > (view.frame.width - 75) {
                // move right
                UIView.animate(withDuration: 0.2, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                }, completion: { _ in
                    self.cardName.text = "Like!"
                })
                return
            }
            
            resetCard()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let pp = PPApi(sendingVC: self)
        divisor = (view.frame.width / 2) / 0.5
        // Do any additional setup after loading the view.
        if let user = currentUser  {
        print("Current user: \(String(describing: user)), \(String(describing: user.name)), \(String(describing: user.id))")
        } else {
            currentUser = User.getUserFromDefault()
        }
        
        
        pp.getPets(id: currentUser!.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(currentUser?.name ?? "no user name")
    }
    
    func resetCard() {
        UIView.animate(withDuration: 0.2, animations: {
            self.card.center = self.view.center
            self.card.alpha = 1
            self.card.transform = .identity
        })
        cardName.text = ""
    }
    
    func addPets(newPets: [Pet]){
        pets.append(contentsOf: newPets)
        print(pets.first?.name)
        cardImage.sd_setImage(with: URL(string: pets.first!.pic), placeholderImage: UIImage(named: "placeholder.png"))
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
