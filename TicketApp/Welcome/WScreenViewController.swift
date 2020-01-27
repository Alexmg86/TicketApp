//
//  WScreenViewController.swift
//  Ticket
//
//  Created by Алексей Морозов on 16.01.2020.
//  Copyright © 2020 Aleksey Morozov. All rights reserved.
//

import UIKit

class WScreenViewController: UIViewController {

    @IBOutlet weak var wLabel: UILabel!
    @IBOutlet weak var wImage: UIImageView!
    @IBOutlet weak var wControl: UIPageControl!
    @IBOutlet weak var wClose: UIButton!
    
    var wLabelText = ""
    var wImageIcon = ""
    var currentPage = 0
    var numberOfPages = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        wLabel.text = wLabelText
        wImage.image = UIImage(named: wImageIcon)
        wControl.numberOfPages = numberOfPages
        wControl.currentPage = currentPage
        wClose.isHidden = true
        if currentPage == numberOfPages - 1 {
            wClose.isHidden = false
        }
        
    }
    
    @IBAction func closePresentation(_ sender: UIButton) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "presentationShowed")
        dismiss(animated: true, completion: nil)
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
