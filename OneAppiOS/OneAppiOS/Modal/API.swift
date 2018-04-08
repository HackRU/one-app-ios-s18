//
//  API.swift
//  OneAppiOS
//
//  Created by Qasim Abbas on 4/8/18.
//  Copyright © 2018 Qasim Abbas. All rights reserved.
//

import Foundation
import Alamofire

var baseURL = ""



public class Authenticator{
    let jsonObject: NSMutableDictionary = NSMutableDictionary()
    var jsonData: Data = Data()
    
    public init(email: String, password: String){
        
        jsonObject.setValue(email, forKey: "email")
        jsonObject.setValue(password, forKey: "password")
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as Data
            let jsonString = NSString(data: jsonData , encoding: String.Encoding.utf8.rawValue)! as String
            print("json string = \(jsonString)")
        } catch _ {
            print ("JSON Failure")
        }
        
    }
    
    func authenticate(){
        
        var request = URLRequest(url: URL(string: baseURL + "/authorize")!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        Alamofire.request(request).responseJSON { (response) in
            
            print(response)
            
        }
    
    }
    
}



