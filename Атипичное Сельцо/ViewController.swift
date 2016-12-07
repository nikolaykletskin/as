//
//  ViewController.swift
//  Атипичное Сельцо
//
//  Created by Nikolay Kletskin on 9/26/16.
//  Copyright © 2016 Nikolay Kletskin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tabBar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.nDarkColor()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor.nDarkFourColor()
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.nCoolGreyColor()]
        tabBar.isTranslucent = false
        tabBar.barTintColor = UIColor.nDarkTwoColor()
        tabBar.tintColor = UIColor.nBrightSkyBlueColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

