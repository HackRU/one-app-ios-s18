//
//  HomeNavigationViewController.swift
//  OneAppiOS
//
//  Created by Qasim Abbas on 4/17/18.
//  Copyright © 2018 Qasim Abbas. All rights reserved.
//

import UIKit

class HomeNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = HackRUColor.main

        //self.navigationItem.title = "HackRU"
        self.navigationController?.title = "HackRU"
        self.navigationBar.backItem?.backBarButtonItem?.tintColor = .white

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
