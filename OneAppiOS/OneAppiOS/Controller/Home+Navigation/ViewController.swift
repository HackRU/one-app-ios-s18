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
import SwiftyJSON
import NVActivityIndicatorView

//login controller
class ViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    let jsonObject: NSMutableDictionary = NSMutableDictionary()
    var jsonData: Data = Data()
    @IBOutlet weak var txtEmail: UITextView!
    @IBOutlet weak var txtPass: UITextView!

    @IBOutlet weak var btnSubmit: MDCRaisedButton!
    var indicate: NVActivityIndicatorView?
    @IBOutlet weak var btnMLH: UIButton!
    
    //when it actually loads into memory
    override func viewDidLoad() {

        //loading general view before details
        super.viewDidLoad()

        //protocol - like interfaces
        //conform to UITextViewDelegate, UITextFieldDelegate and can use those methods
        txtPass.delegate = self
        txtEmail.delegate = self

        self.view.backgroundColor = HackRUColor.main

        btnSubmit.backgroundColor = HackRUColor.main
        btnSubmit.titleLabel?.font = txtEmail.font?.withSize(14)
        btnSubmit.titleLabel?.textColor = HackRUColor.dark

        //btnSubmit.layer.borderWidth = 1
        //btnMLH.layer.borderWidth = 1

        //btnSubmit.layer.borderColor = HackRUColor.main.cgColor
        btnMLH.layer.borderColor = HackRUColor.main.cgColor

        // Do any additional setup after loading the view, typically from a nib.
    }
  
    //hides keyboard on return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //first responder = text field that is the active one
        txtEmail.resignFirstResponder()
        txtPass.resignFirstResponder()

        textField.resignFirstResponder()

        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //press submit
    @IBAction func btnActionSubmit(_ sender: Any) {
        auth()
    }

    //first entry into page = both resigned
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.phase == .began {
                txtPass.resignFirstResponder()
                txtEmail.resignFirstResponder()
            }
        }
    }

    //taking email and password and make json messsage
    func setJson() {

        jsonObject.setValue(txtEmail.text, forKey: "email")
        jsonObject.setValue(txtPass.text, forKey: "password")

        //converting to json
        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as Data
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            print("json string = \(jsonString)")
        } catch _ {
            print ("JSON Failure")
        }

    }

    
    func auth() {
        setJson()

//        let centerFrame = CGRect(x: UIScreen.main.bounds.size.width*0.25, y: 0, width: self.view.bounds.width/2, height: self.view.bounds.height * 0.75)
//        indicate = NVActivityIndicatorView(frame: centerFrame, type: NVActivityIndicatorType.orbit, color: HackRUColor.main, padding: 2)
//
//        self.view.addSubview(indicate ?? NVActivityIndicatorView(frame: centerFrame, type: NVActivityIndicatorType.orbit, color: HackRUColor.main, padding: 2))
//
//        indicate?.startAnimating()

        //url request object - post request: server expecting info from us
        var request = URLRequest(url: URL(string: baseURL + "/authorize")!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //json object
        request.httpBody = jsonData

        //completion handler
        Alamofire.request(request).responseJSON { (response) in
            //got response from server
            
            let swiftJsonVar = JSON(response.result.value!)
            print(swiftJsonVar)
            if let status = swiftJsonVar["statusCode"].int {
                if status as Int? == 200 {
                    print("success!")

                    if let body = JSON(parseJSON: swiftJsonVar["body"].string!).dictionary!["auth"] {

                        //user default settings - entire app can access (cool)
                        //remembers the user even when app closed (super cool)
                        let user = UserDefaults.standard

                        //token: auth2.0, key tied to it
                        if let auth = body["token"].string {
                                print(auth)
                            user.set(auth, forKey: "auth")
                        }

                        if let email = body["email"].string {
                            print(email)
                            user.set(email, forKey: "email")
                        }
                            self.performSegue(withIdentifier: "segueHome", sender: nil)

                    }
                } else if status as Int? == 403 {
                    //error alert
                    if let body = swiftJsonVar["body"].string {
                        let messageConstruction = body + " Please make sure you have an account on HackRU.org"

                        let alert = UIAlertController(title: "Oops Invalid Email/Password!", message: messageConstruction, preferredStyle: .alert)

                        alert.addAction(UIAlertAction(title: "HackRU.org", style: .default, handler: { _ in
                           // UIApplication.shared.openURL(URL(string: "https://hackru.org")!)
                            UIApplication.shared.open(URL(string: "https://hackru.org/dashboard.html")!, options: [:], completionHandler: nil)
                        }))
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                        self.present(alert, animated: true, completion: nil)

                    }
                }
            }

        }

    }

    //hidden right now -> not using it right now
    @IBAction func btnActionMyMLH(_ sender: Any) {

        performSegue(withIdentifier: "segueMLH", sender: nil)

    }

}
