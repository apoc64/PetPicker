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
    
    // MARK: - Instance Variables
    var currentUser: User?
    var pets: [Pet] = []
    var currentPet: Pet! // make not !
    var pp: PPApi!
    var divisor: CGFloat! // for animation - set in VDL
    var outOfPets: Bool = false
    
    // MARK: - IB Outlets
    // Bottom Card:
    @IBOutlet weak var bgCard: UIView!
    @IBOutlet weak var bgCardImage: UIImageView!
    @IBOutlet weak var bgCardName: UILabel!
    @IBOutlet weak var bgCardDescription: UILabel!
    // Top card:
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardDescription: UILabel!
    
    // MARK: - Pet Methods
    func addPets(newPets: [Pet]){ // called from ppAPI
        if newPets.count > 1 {
            print("Adding \(newPets.count) pets")
            pets.append(contentsOf: newPets)
            setPetsForCards()
        } else {
            outOfPets = true
            print("API is out of pets")
        }
    }
    
    func setPetsForCards() {
        if !pets.isEmpty {
            currentPet = pets.removeFirst()
            setPetForCard(pet: currentPet, cName: cardName, cImage: cardImage, cDescr: cardDescription)
        } else {
            print("pets is empty")
        }
        // used to crash - ???:
        if let bgPet = pets.first {
            setPetForCard(pet: bgPet, cName: bgCardName, cImage: bgCardImage, cDescr: bgCardDescription)
        } else if !outOfPets {
            pp.getPets(id: currentUser!.id)
            print("Getting more pets")
        } else {
            print("I'm really out of pets this time")
        }
    }
    
    func setPetForCard(pet: Pet, cName: UILabel, cImage: UIImageView, cDescr: UILabel) {
        cImage.sd_setImage(with: URL(string: pet.pic), placeholderImage: UIImage(named: "placeholder.png"))
        cName.text = pet.name
        cDescr.text = pet.description
    }
    
    func likePet() { // Called from animation
        pp.likePet(user_id: currentUser!.id, pet_id: currentPet.id) // can crash on place holder
        resetCard(duration: 0)
        setPetsForCards()
    }
    
    func nopePet() { // Called from animation
        pp.nopePet(user_id: currentUser!.id, pet_id: currentPet.id)
        resetCard(duration: 0)
        setPetsForCards()
    }
    
    // MARK: - Animation Methods
    func resetCard(duration: Double) {
        UIView.animate(withDuration: duration, animations: {
            self.card.center = self.view.center
            self.card.alpha = 1
            self.card.transform = .identity
        })
    }
    
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y) // move card
        
        card.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor) // rotate card
        
        if sender.state == UIGestureRecognizer.State.ended { // user lifts up finger
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
            } // end if/else - card is close to edge - nike or nope
            resetCard(duration: 0.2)
        } // end if user lifts finger
    } // end pan gesture recognizer
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        pp = PPApi(sendingVC: self)
        divisor = (view.frame.width / 2) / 0.5
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? MatchesTableViewController
        vc?.currentUser = currentUser
    }
}
