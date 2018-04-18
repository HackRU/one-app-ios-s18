//
//  TabsViewController.swift
//  OneAppiOS
//
//  Created by Qasim Abbas on 4/8/18.
//  Copyright © 2018 Qasim Abbas. All rights reserved.
//

import UIKit
import Floaty

class TabsViewController: UITabBarController {
    
    func setFloaty(){
        let size = CGFloat(56)
        
        let floaty = Floaty(frame: CGRect(x: (UIScreen.main.bounds.size.width) - size - 14, y: UIScreen.main.bounds.size.height - (size * 2) - self.tabBar.bounds.height, width: size, height: size))
        floaty.openAnimationType = .pop
        floaty.buttonColor = HackRUColor.lightBlue
        floaty.plusColor = .white
        floaty.itemButtonColor = HackRUColor.lightBlue
    
        floaty.addItem(title: "Hello, World!")
        floaty.addItem(title: "Scanner", handler: {item in
            
            let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "ScannerViewController")
            
            self.navigationController?.pushViewController(mainViewController!, animated: true)
            
            
        })
        
        floaty.addItem("QR", icon: UIImage(named: "ic_action_qrcode"), handler: { item in
            
            
            
            let alert = UIAlertController(title: UserDefaults.standard.value(forKey: "email") as? String, message: "", preferredStyle: .alert)
            alert.view.sizeThatFits(CGSize(width: self.view.bounds.width, height: self.view.bounds.width))
            //alert.addAction(UIAlertAction(title: "QR", style: .default, image: !))
            
            
            var img = UIImage(named: "qr")
            img = img?.imageWithSize(CGSize(width: alert.view.bounds.width * 0.65, height: alert.view.bounds.width * 0.65))
            alert.addAction(UIAlertAction(title: "QR", style: .default, image: img!))
            
            alert.view.backgroundColor = .clear
        
            
            self.present(alert, animated: true, completion: nil)
        })
        
    
        
        
        floaty.addItem("Logout", icon: UIImage(named: "logout")?.maskWithColor(color: .white), handler: { item in
            let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                   let user = UserDefaults.standard
                
                user.set(nil, forKey: "auth")
                user.set(nil, forKey: "email")
 
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! ViewController
                self.present(vc, animated: true, completion: nil)
                
                
            }))
            
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        })
        
        
        self.view.addSubview(floaty)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedIndex = 1
        setFloaty()
        
        let user = UserDefaults.standard
        print("TOKEN \(user.value(forKey: "auth") ?? "NONE")")
        
        if(user.string(forKey: "auth") == nil){
            
            let vc = storyboard?.instantiateViewController(withIdentifier: "Login") as! ViewController
            self.present(vc, animated: true, completion: nil)
        }
        
       
        self.tabBar.unselectedItemTintColor = .white
        self.tabBar.selectedItem?.badgeColor = HackRUColor.blue
        self.tabBar.barTintColor = HackRUColor.lightBlue
        
        for item in self.tabBar.items! {
                item.image = item.image?.maskWithColor(color: .white)
        }
        
        
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
