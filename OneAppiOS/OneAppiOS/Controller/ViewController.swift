//
//  ViewController.swift
//  OneAppiOS
//
//  Created by Qasim Abbas on 11/28/17.
//  Copyright © 2017 Qasim Abbas. All rights reserved.
//

import UIKit
import MaterialComponents
import Alamofire

class ViewController: UIViewController {

    
    let jsonObject: NSMutableDictionary = NSMutableDictionary()
    var jsonData: Data = Data()
    @IBOutlet weak var txtEmail: UITextView!
    @IBOutlet weak var txtPass: UITextView!
    
    @IBOutlet weak var btnSubmit: MDCRaisedButton!
    
    @IBOutlet weak var btnMLH: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = HackRUColor.lightBlue
        
        btnSubmit.backgroundColor = HackRUColor.lightBlue
        btnSubmit.titleLabel?.font = txtEmail.font?.withSize(14)
        btnSubmit.titleLabel?.textColor = HackRUColor.blue
        
        //btnSubmit.layer.borderWidth = 1
        //btnMLH.layer.borderWidth = 1
        
        //btnSubmit.layer.borderColor = HackRUColor.lightBlue.cgColor
        btnMLH.layer.borderColor = HackRUColor.lightBlue.cgColor
        txtPass.isSecureTextEntry = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnActionSubmit(_ sender: Any) {
        auth()
        
    }
    
    func setJson(){
        
        jsonObject.setValue(txtEmail.text , forKey: "email")
        jsonObject.setValue(txtPass.text, forKey: "password")
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as Data
            let jsonString = NSString(data: jsonData , encoding: String.Encoding.utf8.rawValue)! as String
            print("json string = \(jsonString)")
        } catch _ {
            print ("JSON Failure")
        }
        
    }
    
    func auth() {
        setJson()
        
        var request = URLRequest(url: URL(string: baseURL + "/authorize")!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        Alamofire.request(request).responseJSON { (response) in
            
            
            let responseJSON = response.result.value as! [String:AnyObject]
            print(responseJSON)
        
        }
       
        
    }

    

    @IBAction func btnActionMyMLH(_ sender: Any) {
        
        performSegue(withIdentifier: "segueMLH", sender: nil)
    
    }
    
    
    
    
    
    

}

