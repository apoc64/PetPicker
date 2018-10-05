//
//  SwipeViewController.swift
//  PetPicker
//
//  Created by Tyler Westlie  on 10/2/18.
//  Copyright © 2018 Steven Schwedt. All rights reserved.
//

import UIKit

class SwipeViewController: UIViewController {
    
    var currentUser: User!

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
        divisor = (view.frame.width / 2) / 0.5
        // Do any additional setup after loading the view.
        print("Current User: \(String(describing: currentUser)), \(String(describing: currentUser.name)), \(String(describing: currentUser.id))")
    }
    
    func resetCard() {
        UIView.animate(withDuration: 0.2, animations: {
            self.card.center = self.view.center
            self.card.alpha = 1
            self.card.transform = .identity
        })
        cardName.text = ""
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
