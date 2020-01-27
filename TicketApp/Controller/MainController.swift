//
//  MainController.swift
//  Ticket
//
//  Created by Алексей Морозов on 17.01.2020.
//  Copyright © 2020 Aleksey Morozov. All rights reserved.
//

import UIKit

class MainController: UITabBarController {
    
    let userDefaults = UserDefaults.standard
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        starPresentation()
    }

    func starPresentation() {
        let isShowed = userDefaults.bool(forKey: "presentationShowed")
        if isShowed == false {
            if let welcomeController = storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController {
                    welcomeController.modalPresentationStyle = .fullScreen
                    present(welcomeController, animated: true, completion: nil)
            }
        }
//        userDefaults.set(false, forKey: "presentationShowed")
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
