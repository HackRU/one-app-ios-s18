//
//  API.swift
//  OneAppiOS
//
//  Created by Qasim Abbas on 4/8/18.
//  Copyright © 2018 Qasim Abbas. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_Synchronous
import NVActivityIndicatorView

//API URLS
//TEST API
//var baseURL = "https://7c5l6v7ip3.execute-api.us-west-2.amazonaws.com/lcs-test"

//PRODUCTION API
var baseURL = "https://m7cwj1fy7c.execute-api.us-west-2.amazonaws.com/mlhtest"

//MISC URL
var miscURL = "http://hackru-misc.s3-website-us-west-2.amazonaws.com"

public class Authenticator {
    let jsonObject: NSMutableDictionary = NSMutableDictionary()
    var jsonData: Data = Data()
    var email: String
    var password: String

    public init(email: String, password: String) {

        self.email = email
        self.password = password

        jsonObject.setValue(email, forKey: "email")
        jsonObject.setValue(password, forKey: "password")

        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as Data
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            print("json string = \(jsonString)")
        } catch _ {
            print ("JSON Failure")
        }

    }

    func authenticate() -> Int {

        var request = URLRequest(url: URL(string: baseURL + "/authorize")!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        var status = 0

        Alamofire.request(request).responseJSON { (response) in
            guard let responseJSON = response.result.value as? [String: AnyObject] else {
                return
            }
            print(responseJSON)

            status = responseJSON["statusCode"] as? Int ?? 400

        }
        return status

    }

//    func authenticateSync()-> Int{
//       // let response = Alamofire.request(baseURL + "/authorize", method: .post, parameters: jsonData).responseJSON(options: .allowFragments)
//
//
//        // post request and response json(with default options)
//
//        let auth = baseURL + "/authorize"
//        var status = 0
//        let response = Alamofire.request(auth, method: .post, parameters: ["email": self.email,"password": self.password]).responseJSON(options: .allowFragments)
//
//        if let json = response.result.value {
//            let responseJSON = json as! [String:AnyObject]
//
//            status = responseJSON["statusCode"] as! Int
//
//        }
//         return status
//
//    }

}

extension UIImage {
    func imageWithSize(_ size: CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero

        let aspectWidth: CGFloat = size.width / self.size.width
        let aspectHeight: CGFloat = size.height / self.size.height
        let aspectRatio: CGFloat = min(aspectWidth, aspectHeight)

        scaledImageRect.size.width = self.size.width * aspectRatio
        scaledImageRect.size.height = self.size.height * aspectRatio
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0

        UIGraphicsBeginImageContextWithOptions(size, false, 0)

        self.draw(in: scaledImageRect)

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return scaledImage!
    }
}

extension UIAlertAction {
    convenience init(title: String?, style: UIAlertAction.Style, image: UIImage, handler: ((UIAlertAction) -> Void)? = nil) {
        self.init(title: title, style: style, handler: handler)
        self.actionImage = image

    }

    convenience init?(title: String?, style: UIAlertAction.Style, imageNamed imageName: String, handler: ((UIAlertAction) -> Void)? = nil) {
        if let image = UIImage(named: imageName) {
            self.init(title: title, style: style, image: image, handler: handler)
        } else {
            return nil
        }
    }

    var actionImage: UIImage {
        get {
            return self.value(forKey: "image") as? UIImage ?? UIImage()
        }
        set(image) {
            self.setValue(image.withRenderingMode(.alwaysOriginal), forKey: "image")
        }
    }
}

//extension UIAlertAction {
//
//    /// Image to display left of the action title
//    var actionImage: UIImage? {
//        get {
//            if self.responds(to: Selector(Constants.imageKey)) {
//                return self.value(forKey: Constants.imageKey) as? UIImage
//            }
//            return nil
//        }
//        set {
//            if self.responds(to: Selector(Constants.imageKey)) {
//                self.setValue(newValue, forKey: Constants.imageKey)
//            }
//        }
//    }
//
//    private struct Constants {
//        static var imageKey = "image"
//    }
//}

extension UIImage {

    func maskWithColor( color: UIColor) -> UIImage {

        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!

        color.setFill()

        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)

        let rect = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
        context.draw(self.cgImage!, in: rect)

        context.setBlendMode(CGBlendMode.sourceIn)
        context.addRect(rect)
        context.drawPath(using: CGPathDrawingMode.fill)

        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return coloredImage!
    }
}

let sharedMisc = Sync(miscURL: miscURL)

public class Sync {

    var miscURL: String?
    var locations: [String]?

    init(miscURL: String) {
        self.miscURL = miscURL
    }

    func getMiscData(completionHandler: @escaping () -> Void) {

        let url = URL(string: miscURL ?? "http://hackru-misc.s3-website-us-west-2.amazonaws.com")

        if url != nil {

            let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, _, error) -> Void in
                guard let data = data else {
                    return
                }

                if error == nil {

                    let urlContent = NSString(data: data, encoding: String.Encoding.ascii.rawValue)! as String
                    let arrSeperate = urlContent.components(separatedBy: "\n")
                    print(arrSeperate.count)
                    self.locations = arrSeperate
                    completionHandler()
                }
            })
            task.resume()
        }

    }

//    func getMiscIn(input: String, completionHandler: @escaping () -> AnyObject) {
//
//        let buildURL = miscURL! + input
//        let url = URL(string: buildURL)
//
//        if url != nil {
//
//            let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, _, error) -> Void in
//                guard let data = data else {
//                    return
//                }
//
//                if error == nil {
//
//                    let urlContent = NSString(data: data, encoding: String.Encoding.ascii.rawValue)! as String
//                    let arrSeperate = urlContent.components(separatedBy: "\n")
//                    print(arrSeperate.count)
//                    //completionHandler(arrSeperate)
//
//                }
//            })
//            task.resume()
//        }
//
//    }

    func getMiscScan(input: String, completionHandler: @escaping ([String]) -> Void) {

        let buildURL = miscURL! + input
        let url = URL(string: buildURL)

        if url != nil {

            let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, _, error) -> Void in
                guard let data = data else {
                    return
                }

                if error == nil {

                    let urlContent = NSString(data: data, encoding: String.Encoding.ascii.rawValue)! as String
                    let arrSeperate = urlContent.components(separatedBy: "\n")
                    print(arrSeperate.count)
                    completionHandler(arrSeperate)
                }
            })
            task.resume()
        }

    }

    func getDataFromMiscDirect() {
    }
}
