//
//  WelcomeViewController.swift
//  Ticket
//
//  Created by Алексей Морозов on 16.01.2020.
//  Copyright © 2020 Aleksey Morozov. All rights reserved.
//

import UIKit

class WelcomeViewController: UIPageViewController {
    
    let welcomeContent = [
        "Добавляйте свои поездки",
        "Ведите учет билетов",
        "Смотрите статистику \nи экономьте"
    ]
    let welcomeIcons = [
        "w_plus",
        "w_ticket",
        "w_chart"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self

        if let wScreen = showViewControllerAtIndex(0) {
            setViewControllers([wScreen], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func showViewControllerAtIndex(_ index: Int) -> WScreenViewController? {
        guard index >= 0 else { return nil }
        guard index < welcomeContent.count else { return nil }
        guard let wScreen = storyboard?.instantiateViewController(withIdentifier: "WScreenViewController") as? WScreenViewController
            else { return nil }
        
        wScreen.wLabelText = welcomeContent[index]
        wScreen.wImageIcon = welcomeIcons[index]
        wScreen.currentPage = index
        wScreen.numberOfPages = welcomeContent.count
        
        return wScreen
    }

}

extension WelcomeViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var pageNumber = (viewController as! WScreenViewController).currentPage
        pageNumber -= 1
        return showViewControllerAtIndex(pageNumber)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var pageNumber = (viewController as! WScreenViewController).currentPage
        pageNumber += 1
        return showViewControllerAtIndex(pageNumber)
    }
}
