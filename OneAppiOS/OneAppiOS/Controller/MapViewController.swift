//
//  MapViewController.swift
//  OneAppiOS
//
//  Created by Qasim Abbas on 4/18/18.
//  Copyright © 2018 Qasim Abbas. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    private let scrollView = ImageScrollView(image: UIImage(named: "layout")!)

    override func viewDidLoad() {
        view.backgroundColor = HackRUColor.blue
        view.addSubview(scrollView)

        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        self.navigationItem.backBarButtonItem?.tintColor = .white

        navigationController?.navigationBar.backItem?.title = "back"

        scrollView.frame = view.frame
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        super.viewDidLoad()

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
