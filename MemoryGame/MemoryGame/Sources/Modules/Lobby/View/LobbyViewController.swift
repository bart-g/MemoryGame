//
//  LobbyViewController.swift
//  MemoryGame
//
//  Created by Bartosz Górka on 26/08/2021.
//

import UIKit

final class LobbyViewController: UIViewController {

    @IBOutlet private weak var threeTimesFourButton: UIButton!
    @IBOutlet private weak var fiveTimesTwoButton: UIButton!
    @IBOutlet private weak var fourTimesFourButton: UIButton!
    @IBOutlet private weak var fourTimesFiveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }
    
    @IBAction private func threeTimesFourButtonAction(_ sender: Any) {
        
    }
    
    @IBAction private func fiveTimesTwoButtonAction(_ sender: Any) {
        
    }
    
    @IBAction private func fourTimesFourButtonAction(_ sender: Any) {
        
    }
    
    @IBAction private func fourTimesFiveButtonAction(_ sender: Any) {
        
    }
    
    private func setUp() {
        navigationController?.isNavigationBarHidden = true
    }
}

struct LobbyViewControllerAssembler {
    func assemble() -> UIViewController {
        let lobbyViewController = LobbyViewController()
        let navigationController = UINavigationController(rootViewController: lobbyViewController)
        
        return navigationController
    }
 }
