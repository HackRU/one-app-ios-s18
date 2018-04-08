//
//  ViewController.swift
//  OneAppiOS
//
//  Created by Qasim Abbas on 11/28/17.
//  Copyright © 2017 Qasim Abbas. All rights reserved.
//

import UIKit
import MaterialComponents

class ViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var btnMLH: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = HackRUColor.blue
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnActionSubmit(_ sender: Any) {
    
        let auth = Authenticator.init(email: txtEmail.text!, password: txtPass.text!)
        
        auth.authenticate()
    
    }

    @IBAction func btnActionMyMLH(_ sender: Any) {
        
        performSegue(withIdentifier: "segueMLH", sender: nil)
    
    }
    
    
    
    
    

}

