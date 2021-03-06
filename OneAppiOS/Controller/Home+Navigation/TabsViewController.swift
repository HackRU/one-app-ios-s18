//
//  TabsViewController.swift
//  OneAppiOS
//
//  Created by Qasim Abbas on 4/8/18.
//  Copyright © 2018 Qasim Abbas. All rights reserved.
//

import UIKit
import Floaty
import QRCode
import Alamofire
import SwiftyJSON
import FoldingTabBar

class TabsViewController: UITabBarController {
    var organizer: Bool = Bool()
    let jsonObject: NSMutableDictionary = NSMutableDictionary()
    var jsonData: Data = Data()
    var floaty: Floaty = Floaty()

    func setFloaty() {
        let size = CGFloat(56)

        floaty = Floaty(frame: CGRect(x: (UIScreen.main.bounds.size.width) - size - 14, y: UIScreen.main.bounds.size.height - (size * 2) - self.tabBar.bounds.height, width: size, height: size))
        floaty.openAnimationType = .slideUp
        floaty.buttonColor = HackRUColor.main
        floaty.buttonImage = UIImage(named: "baseline_menu_white")
//        floaty.buttonImage?.scale = 0.5
//        floaty.buttonImage?.size = CGSize(width: 56, height: 56)
        floaty.plusColor = .white
        floaty.itemButtonColor = HackRUColor.main
        //organizer = true

        if organizer {

            floaty.addItem("Scanner", icon: UIImage(named: "ic_camera")?.maskWithColor(color: .white), handler: { _ in

                let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "ScannerViewController")
                self.navigationController?.pushViewController(mainViewController!, animated: true)
            })

        }

        floaty.addItem("QR", icon: UIImage(named: "ic_action_qrcode"), handler: { _ in

            let alert = UIAlertController(title: UserDefaults.standard.value(forKey: "email") as? String, message: "", preferredStyle: .alert)

            var qrCode = QRCode(UserDefaults.standard.value(forKey: "email") as? String ?? "team@hackru.org")
            qrCode?.color = CIColor.init(color: HackRUColor.dark)
            qrCode?.backgroundColor = CIColor.white

            qrCode?.size = CGSize(width: alert.view.bounds.width * 0.65, height: alert.view.bounds.width * 0.65)

            //qrCode?.image // UIImage (green QRCode color and black background)

            let actionAlert = UIAlertAction(title: "QR", style: .default, handler: nil)

            actionAlert.actionImage = (qrCode?.image)!

          //  var imageView = UIImageView(frame: CGRect(220, 10, 40, 40))

            //alert.view.addSubview(imageView)

            alert.addAction(actionAlert)

            alert.view.backgroundColor = UIColor.white

            self.present(alert, animated: true, completion: nil)

        })

        floaty.addItem("Map", icon: UIImage(named: "ic_map")?.maskWithColor(color: .white), handler: { _ in
            let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "Map")

            self.navigationController?.pushViewController(mainViewController!, animated: true)
        })

        floaty.addItem("Logout", icon: UIImage(named: "logout")?.maskWithColor(color: .white), handler: { _ in
            let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                   let user = UserDefaults.standard

                user.set(nil, forKey: "auth")
                user.set(nil, forKey: "email")

                guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Login") as? ViewController else {
                    return
                }
                self.present(viewController, animated: true, completion: nil)

            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)
        })

        self.view.addSubview(floaty)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationBar.backItem?.backBarButtonItem?.tintColor = .white
        self.navigationItem.backBarButtonItem?.tintColor = .white

        self.selectedIndex = 1

        let user = UserDefaults.standard
        print("TOKEN \(user.value(forKey: "auth") ?? "NONE")")

        if user.string(forKey: "auth") == nil {

            guard let viewController = storyboard?.instantiateViewController(withIdentifier: "Login") as? ViewController else {
                print("Didn't assign View Controller")
                return
            }

            present(viewController, animated: true, completion: nil)

        } else if (user.string(forKey: "organizer") == nil) || (!organizer) {

            createPOSTBody()

            var request = URLRequest(url: URL(string: baseURL + "/read")!)

            //print(request.url?.absoluteString)

            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            setFloaty()

            Alamofire.request(request).responseJSON { (response) in

                print("RESPONSE")
                //print(response.result.value)

                if let body = JSON(response.result.value!)["body"].array {
                    for item in body {
                        if let role = item["role"].dictionary {
                            if (role["director"]?.bool)! || (role["organizer"]?.bool)! {
                                print("DIRECTOR OR ORGANIZER")

                                self.organizer = true
                                self.floaty.removeFromSuperview()
                                self.setFloaty()

                            } else {
                                self.organizer = false
                            }
                        }
                    }
                }
            }
        }

        self.tabBar.unselectedItemTintColor = .white
        self.tabBar.selectedItem?.badgeColor = HackRUColor.dark
        self.tabBar.barTintColor = HackRUColor.main

        for item in self.tabBar.items! {
                item.image = item.image?.maskWithColor(color: .white)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createPOSTBody() {
        guard let emailString = UserDefaults.standard.object(forKey: "email") as? String else {
            return
        }

        let queryObject: NSMutableDictionary = NSMutableDictionary()
        queryObject.setValue(emailString, forKey: "email")
        //            var queryData: Data = Data()
        //            do {
        //                queryData = try JSONSerialization.data(withJSONObject: queryObject, options: JSONSerialization.WritingOptions()) as Data
        //                let jsonString = NSString(data: queryData, encoding: String.Encoding.utf8.rawValue)!
        //                print("json string = \(jsonString)")
        //
        //            } catch _ {
        //                print ("JSON Failure")
        //            }

        jsonObject.setValue(UserDefaults.standard.object(forKey: "auth") as? String, forKey: "token")
        jsonObject.setValue(UserDefaults.standard.object(forKey: "email") as? String, forKey: "email")
        jsonObject.setValue(queryObject, forKey: "query")

        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as Data
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)!
            print("json string = \(jsonString)")

        } catch _ {
            print ("JSON Failure")
        }
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
