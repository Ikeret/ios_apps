//
//  MultiplayerViewController.swift
//  Rock Paper Scissors
//
//  Created by Сергей Коршунов on 16/07/2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MultiplayerViewController: UIViewController, MCBrowserViewControllerDelegate {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var user_faceLabel: UILabel!
    @IBOutlet weak var opponent_faceLabel: UILabel!
    
    @IBOutlet weak var first_arm: UIButton!
    @IBOutlet weak var second_arm: UIButton!
    @IBOutlet weak var thid_arm: UIButton!
    @IBOutlet var armsButtons: [UIButton]!
    
    @IBOutlet weak var new_gameButton: UIButton!
    @IBOutlet weak var activeIndicator: UIActivityIndicatorView!
    @IBOutlet weak var connectButton: UIBarButtonItem!
    @IBOutlet weak var disconnectButton: UIBarButtonItem!
    
    var user_score = 0
    var opponent_score = 0
    var user_choice: String?
    var opponent_choice: String?
    var is_searching = false
    
    var appDelegate: AppDelegate!
    var MPCController: MPCHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let avatar = UserDefaults.standard.value(forKey: "UserFace") as? String
        user_faceLabel.text = avatar
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        MPCController = appDelegate.MPChandler
        MPCController.setupPeerWithDisplayName(displayName: avatar!)
        MPCController.setupSession()
        MPCController.advertiseSelf(advertise: true)
        
        let notification1 = NSNotification.Name(rawValue: "MPC_DidChangeStateNotification")
        let notification2 = NSNotification.Name(rawValue: "MPC_DidReciveDataNotification")
        
        NotificationCenter.default.addObserver(self, selector: #selector(peerChangedStateWithNotification), name: notification1, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRecivedDataWithNotification), name: notification2, object: nil)
        
    }

    
    
    func arms(isHidden: Bool) {
        for arm in armsButtons {
            arm.isHidden = isHidden
        }
    }
    
    func arms(isEnabled: Bool) {
        for arm in armsButtons {
            arm.isEnabled = isEnabled
        }
    }
    
    func arms_normal_bgc() {
        for arm in armsButtons {
            arm.backgroundColor = .white
        }
    }
    
    @IBAction func user_choosed(_ sender: UIButton) {
        arms_normal_bgc()
        sender.backgroundColor = .yellow
        user_choice = sender.title(for: .normal)
        
        let message = ["choice" : user_choice!]

        if  let messageData = try? JSONSerialization.data(withJSONObject: message, options: .prettyPrinted) {
            try? MPCController.session.send(messageData, toPeers: MPCController.session.connectedPeers, with: .reliable)
        }
        
        if (opponent_choice != nil) {
            both_choosed()
        }
        else {
            topLabel.text = "Opponent Still Choosing"
        }
    }
    
    func both_choosed() {
        arms_normal_bgc()
        arms(isEnabled: false)
        first_arm.setTitle(user_choice, for: .normal)
        thid_arm.setTitle(opponent_choice, for: .normal)
        if user_choice != opponent_choice {
            if is_user_won() {
                user_score += 1
                second_arm.setTitle(">", for: .normal)
                second_arm.setTitleColor(.green, for: .normal)
                topLabel.text = "You Win!"
                topLabel.textColor = .green
            } else {
                opponent_score += 1
                second_arm.setTitle("<", for: .normal)
                second_arm.setTitleColor(.red, for: .normal)
                topLabel.text = "You Lose!"
                topLabel.textColor = .red
            }
        } else {
            topLabel.text = "Draw!"
            second_arm.setTitle("=", for: .normal)
            second_arm.setTitleColor(.black, for: .normal)
        }
        scoreLabel.text = "\(user_score) : \(opponent_score)"
        scoreLabel.isHidden = false
        new_gameButton.isHidden = false
        user_choice = nil
        opponent_choice = nil
    }
    
    @IBAction func new_game(_ sender: Any) {
        arms(isEnabled: true)
        arms_normal_bgc()
        first_arm.setTitle("✊🏼", for: .normal)
        second_arm.setTitle("🤚🏼", for: .normal)
        thid_arm.setTitle("✌🏼", for: .normal)
        topLabel.textColor = .black
        topLabel.text = "Choose One"
        new_gameButton.isHidden = true
    }
    
    func is_user_won() -> Bool {
        switch user_choice {
        case "✊🏼":
            if opponent_choice == "✌🏼" {
                return true
            }
        case "🤚🏼":
            if opponent_choice == "✊🏼" {
                return true
            }
        case "✌🏼":
            if opponent_choice == "🤚🏼" {
                return true
            }
        default: break
        }
        return false
    }
    
    @objc func peerChangedStateWithNotification(notification: NSNotification) {
        let userInfo = NSDictionary(dictionary: notification.userInfo!)
        let state = userInfo.object(forKey: "state") as! Int
        
        if state == MCSessionState.connected.rawValue {
            connectButton.title = "Connected"
            activeIndicator.stopAnimating()
            topLabel.text = "Choose One"
            scoreLabel.isHidden = true
            opponent_faceLabel.isHidden = false
            opponent_faceLabel.text = (userInfo.object(forKey: "peerID") as? MCPeerID)?.displayName
            arms(isHidden: false)
            disconnectButton.isEnabled = true
        }
        else {
            clean_up()
            disconnectButton.isEnabled = false
        }
    }
    
    @objc func handleRecivedDataWithNotification(notification: NSNotification) {
        let userInfo = NSDictionary(dictionary: notification.userInfo!)
        let recivedData: Data = userInfo["data"] as! Data
        
        let message = try? JSONSerialization.jsonObject(with: recivedData, options: .allowFragments) as? NSDictionary
        let choice = message?.object(forKey: "choice") as? String
        opponent_choice = choice
        if (user_choice != nil) {
            both_choosed()
        }
    }
    
    func clean_up() {
        user_score = 0
        opponent_score = 0
        new_game(true)
        connectButton.title = "Connect"
        activeIndicator.startAnimating()
        topLabel.text = "Waiting for opponent..."
        arms(isHidden: true)
        user_choice = nil
        opponent_choice = nil
    }
    
    @IBAction func connectWithPlayer(_ sender: UIBarButtonItem) {
        if MPCController.session != nil {
            is_searching = true
            MPCController.setupBrowser()
            MPCController.browser.maximumNumberOfPeers = 2
            MPCController.browser.delegate = self
            self.present(MPCController.browser, animated: true, completion: nil)
        }
    }
    
    @IBAction func disconnect(_ sender: UIBarButtonItem) {
        MPCController.session.disconnect()
        disconnectButton.isEnabled = false
        clean_up()
    }
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        MPCController.browser.dismiss(animated: true, completion: nil)
        is_searching = false
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        MPCController.browser.dismiss(animated: true, completion: nil)
        is_searching = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if !is_searching {
            MPCController.advertiseSelf(advertise: false)
            MPCController.session.disconnect()
        }
    }
}
