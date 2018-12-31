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
    private var pets: [Pet] = []
    private var currentPet: Pet? // make not !
    private var pp: PPApi!
    private var divisor: CGFloat! // for animation - set in VDL
    private var outOfPets = false
    private var stopAnimation = false
    private var nextTimeEnd = false
    private var isFirstSwipe = true
    
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
           let uniquePets = checkDuplicatePet(newPets: newPets)
            print("Adding \(uniquePets.count) pets")
            pets.append(contentsOf: uniquePets)
        } else {
            outOfPets = true
            print("API is out of pets")
            if isFirstSwipe {
                nextTimeEnd = true
                noPets()
            }
        }
        setPetsForCards()
    }
    
    func checkDuplicatePet(newPets: [Pet]) -> [Pet] {
        let petIds = pets.map({
            (value: Pet) -> Int in
            return value.id
        })
        print(petIds)
        return newPets
//        newPets.filter {$0.id}
    }
    
    func setPetsForCards() {
//        guard var currentPet = currentPet else { return }
//        print(currentPet.name)
        print("you have \(pets.count) left")
        if !pets.isEmpty {
            currentPet = pets.removeFirst()
            if let currentPet = currentPet {
            setPetForCard(pet: currentPet, cName: cardName, cImage: cardImage, cDescr: cardDescription)
            }
        } else {
            print("pets is empty")
        }
        // used to crash - ???:
        if let bgPet = pets.first {
            setPetForCard(pet: bgPet, cName: bgCardName, cImage: bgCardImage, cDescr: bgCardDescription)
        } else if !outOfPets {
            NetworkingManager.shared.getPets(id: currentUser!.id, completion: { (pets) in
                self.addPets(newPets: pets)
            })
            print("Getting more pets")
        } else {
            noPets()
        }
    }
    
    func noPets() {
        if nextTimeEnd {
            print("I'm really out of pets this time")
            cardName.text = "No More Pets 🤮"
            cardImage.image = UIImage(named: "pizzacat")
            cardDescription.text = "You're a pet swipin' machine!!!"
            stopAnimation = true
        } else {
            print("I'm ALMOST out of pets this time")
            bgCardName.text = "No More Pets 🤮"
            bgCardImage.image = UIImage(named: "pizzacat")
            bgCardDescription.text = "You're a pet swipin' machine!!!"
            nextTimeEnd = true 
        }
    }
    
    func setPetForCard(pet: Pet, cName: UILabel, cImage: UIImageView, cDescr: UILabel) {
        cImage.sd_setImage(with: URL(string: pet.pic), placeholderImage: UIImage(named: "placeholder.png"))
        cName.text = pet.name
        cDescr.text = pet.description
    }
    
    func likePet() { // Called from animation
        guard let currentPet = currentPet else { return }
        NetworkingManager.shared.likePet(user_id: currentUser!.id, pet_id: currentPet.id, completion: nil) // can crash on place holder
        resetCard(duration: 0)
        setPetsForCards()
    }
    
    func nopePet() { // Called from animation
        guard let currentPet = currentPet else { return }
        NetworkingManager.shared.nopePet(user_id: currentUser!.id, pet_id: currentPet.id, completion: nil) // can crash on place holder
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
        guard !stopAnimation else { return }
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
        divisor = (view.frame.width / 2) / 0.5
        if let user = currentUser  {
            print("Current user: \(String(describing: user)), \(String(describing: user.name)), \(String(describing: user.id))")
        } else {
            currentUser = User.getUserFromDefault()
        }
        NetworkingManager.shared.getPets(id: currentUser!.id, completion: { (pets) in
            self.addPets(newPets: pets)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(currentUser?.name ?? "no user name")
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MatchesTableViewController {
            vc.currentUser = currentUser
        } else if let vc = segue.destination as? ProfieViewController {
            vc.user = currentUser
        }
    }
}
