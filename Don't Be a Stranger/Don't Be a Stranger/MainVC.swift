//
//  MainVC.swift
//  Don't Be a Stranger
//
//  Created by Сергей Коршунов on 20.10.2019.
//  Copyright © 2019 Сергей Коршунов. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var myBackgroundView: UIView!
    @IBOutlet weak var myCardView: UIView!
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
   
    @IBAction func panRecognizerAction(_ sender: UIPanGestureRecognizer) {
        animation(sender: sender)
    }
    
    @IBAction func rulesButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "nextVC", sender: self)
    }
    @IBAction func refreshButton(_ sender: Any) {
        questionsArray.shuffle()
        questionNumberLabel.alpha = 0
        questionLabel.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.swipePosition = 0
            self.questionNumberLabel.alpha = 1
            self.questionLabel.alpha = 1
        })
        questionLabel.text = questionsArray[swipePosition]
    }
    
    
    var swipePosition = 0
    var gradientLayer = CAGradientLayer()
    
      

        override func viewDidLoad() {
            super.viewDidLoad()
            questionsArray.shuffle()
            questionLabel.text = questionsArray[swipePosition]
            questionNumberLabel.text = NSLocalizedString("Read and answer.", comment: "")

            myCardView.layer.cornerRadius = 8
            myCardView.layer.shadowOffset = CGSize(width: 7, height: 7)
            myCardView.layer.shadowRadius = 5
            myCardView.layer.shadowOpacity = 0.5
            
            myBackgroundView.layer.cornerRadius = 8
            myBackgroundView.layer.shadowOffset = CGSize(width: 7, height: 7)
            myBackgroundView.layer.shadowRadius = 5
            myBackgroundView.layer.shadowOpacity = 0.5
            
            questionLabel.sizeToFit()
            questionNumberLabel.sizeToFit()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        //createGradientLayer()
    }
    
    func animation(sender: UIPanGestureRecognizer) {
        
        let card = sender.view!
        let point = sender.translation(in: view)
        card.center = CGPoint(x: view.center.x + point.x , y: view.center.y + point.y)
        
        if sender.state == UIPanGestureRecognizer.State.ended {
            if card.center.x < 75 {
                //left
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                })
                // puting card back on position
                UIView.animate(withDuration: 0.1, animations: {
                    card.center = self.view.center
                    card.alpha = 1
                    self.swipePosition += 1
                })
                print("+1")
                if swipePosition == questionsArray.count {
                    swipePosition = 0
                    questionsArray.shuffle()
                    questionLabel.text = questionsArray[swipePosition]
                    alertFunc()
                    print("alert")

                }
                questionLabel.text = questionsArray[swipePosition]
                }
            
                if card.center.x > (view.frame.width - 75) {
                //right
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                })
                // puting card back on position
                UIView.animate(withDuration: 0.1, animations: {
                    card.center = self.view.center
                    card.alpha = 1
                    self.swipePosition -= 1
                })
                print("-1")
                if swipePosition == -1 {
                    swipePosition = 0
                    questionLabel.text = questionsArray[swipePosition]
                    

                }
                questionLabel.text = questionsArray[swipePosition]
                }
            }
            UIView.animate(withDuration: 0.5, animations: {
                card.center = self.view.center
                card.alpha = 1
            })
        }
    
    
    func alertFunc() {
        let title = NSLocalizedString("You went through all the questions!", comment: "")
        let message = NSLocalizedString("We hope that you and your interlocutor were able to learn a lot of interesting things.", comment: "")
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        ac.addAction(action)
        present(ac, animated: true)
    }
    
 
    
}

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

