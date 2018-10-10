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
    var currentPet: Pet!
    var pp: PPApi!
    
    func addPets(newPets: [Pet]){
        pets.append(contentsOf: newPets)
        setPetForCard()
    }
    
    func setPetForCard() {
        currentPet = pets.removeFirst()
        // Set top card
        cardImage.sd_setImage(with: URL(string: currentPet.pic), placeholderImage: UIImage(named: "placeholder.png"))
        cardName.text = currentPet.name
        cardDescription.text = currentPet.description
        
        let pet = pets.first!
        print("Setting bg card")
        bgCardImage.sd_setImage(with: URL(string: pet.pic), placeholderImage: UIImage(named: "placeholder.png"))
        bgCardName.text = pet.name
        bgCardDescription.text = pet.description
    }
    
    func likePet() {
        print("like")
        pp.likePet(user_id: currentUser!.id, pet_id: currentPet.id)
        resetCard(duration: 0)
        setPetForCard()
    }
    
    func nopePet() {
        print("nope")
        pp.nopePet(user_id: currentUser!.id, pet_id: currentPet.id)
        resetCard(duration: 0)
        setPetForCard()
    }

    // Bottom Card
    @IBOutlet weak var bgCard: UIView!
    @IBOutlet weak var bgCardImage: UIImageView!
    @IBOutlet weak var bgCardName: UILabel!
    @IBOutlet weak var bgCardDescription: UILabel!
    
    // Top card
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardDescription: UILabel!
    
    var divisor: CGFloat!
    
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        card.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor)
        
        if sender.state == UIGestureRecognizer.State.ended {
            if card.center.x < 75 {
                // move to left - nope
                UIView.animate(withDuration: 0.2, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.alpha = 0
                }, completion: { _ in
                    self.nopePet()
                })
                return
            } else if card.center.x > (view.frame.width - 75) {
                // move right - like
                UIView.animate(withDuration: 0.2, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                }, completion: { _ in
                    self.likePet()
                })
                return
            }
            resetCard(duration: 0.2)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pp = PPApi(sendingVC: self)
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
    
    func resetCard(duration: Double) {
        UIView.animate(withDuration: duration, animations: {
            self.card.center = self.view.center
            self.card.alpha = 1
            self.card.transform = .identity
        })
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
