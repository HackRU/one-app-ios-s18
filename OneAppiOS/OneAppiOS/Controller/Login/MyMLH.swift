//
//  MyMLH.swift
//  OneAppiOS
//
//  Created by Qasim Abbas on 4/8/18.
//  Copyright © 2018 Qasim Abbas. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON

class MyMLH: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://my.mlh.io/oauth/authorize?client_id=bab4ace712bb186d8866ff4776baf96b2c4e9c64d729fb7f88e87357e4badcba&redirect_uri=https://m7cwj1fy7c.execute-api.us-west-2.amazonaws.com/mlhtest/mlhcallback&response_type=code&scope=email+education+birthday")

        let requestURL = URLRequest(url: url!)
        webView.load(requestURL)

        webView.navigationDelegate = self

        // Do any additional setup after loading the view.
    }

    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print(webView.url!)

        if(webView.url?.absoluteString.contains("https://hackru.org/dashboard.html?authdata"))! {

            let stringURL = webView.url?.absoluteString
            var cleanUp = stringURL?.removingPercentEncoding

           // print(cleanUp ?? "no cleanup")
            let subJson = cleanUp?.suffix(from: (cleanUp?.index(of: "{"))!)
            cleanUp = String(subJson!)

            print(cleanUp!)

            if let body = JSON(parseJSON: cleanUp!).dictionary!["token"] {

                let user = UserDefaults.standard

                if let auth = body["token"].string {
                    print(auth)
                    user.set(auth, forKey: "token")
                }

                if let email = body["email"].string {
                    print(email)
                    user.set(email, forKey: "email")
                }

                performSegue(withIdentifier: "segueLoggedIn", sender: nil)
            }

        }
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

            let myFileURL = Bundle.main.url(forResource: "login", withExtension: "js")!
            guard let myText = try? String(contentsOf: myFileURL) else {
                return
            }
            print(myText)

            webView.evaluateJavaScript(myText) { (result, error) in
                if error != nil {
                    print(result ?? "none")
                }
            }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

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
