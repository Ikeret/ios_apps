//
//  GameViewController.swift
//  Truth or Action
//
//  Created by Сергей Коршунов on 29.10.2019.
//

import UIKit

class GameViewController: UIViewController {
    private var _currentPlayer = 0
    var currentPlayer: Int {
        set {
            _currentPlayer = newValue % players.count
        }
        get {
            return _currentPlayer
        }
    }
    
    var isTruth = false
    var isAction = false
    
    @IBOutlet weak var avatarLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var truthButton: UIButton!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var changeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCurrentPlayer()
    }
    
    @IBAction func doneAction(_ sender: Any) {
        stage1()
        isTruth = false
        isAction = false
        currentPlayer += 1
        setupCurrentPlayer()
    }
    
    @IBAction func truthAction(_ sender: Any) {
        isTruth = true
        stage2()
    }
    
    @IBAction func actionAction(_ sender: Any) {
        isAction = true
        stage2()
    }
    
    @IBAction func changeButton(_ sender: Any) {
        showNewText()
    }
    
    func setupCurrentPlayer() {
        navigationItem.title = players[currentPlayer].name
        avatarLabel.text = players[currentPlayer].avatar
    }
    
    func showNewText() {
        if isTruth {
            textLabel.text = truths.randomElement()!
        }
        if isAction {
            textLabel.text = actions.randomElement()!
        }
    }
    
    func stage1() {
        truthButton.isHidden = false
        actionButton.isHidden = false
        doneButton.isHidden = true
        changeButton.isHidden = true
        textLabel.text = "Правда или действие?"
    }
    
    func stage2() {
        truthButton.isHidden = true
        actionButton.isHidden = true
        doneButton.isHidden = false
        changeButton.isHidden = false
        showNewText()
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
