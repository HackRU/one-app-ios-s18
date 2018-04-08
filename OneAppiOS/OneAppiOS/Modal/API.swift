//
//  API.swift
//  OneAppiOS
//
//  Created by Qasim Abbas on 4/8/18.
//  Copyright © 2018 Qasim Abbas. All rights reserved.
//

import Foundation

var baseURL = "https://m7cwj1fy7c.execute-api.us-west-2.amazonaws.com/mlhtest"



public class Authenticator{
    let jsonObject: NSMutableDictionary = NSMutableDictionary()
    
    public init(email: String, password: String){
        
        jsonObject.setValue(email, forKey: "email")
        jsonObject.setValue(password, forKey: "password")
        
        let jsonData: NSData
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as NSData
            let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
            print("json string = \(jsonString)")
            
        } catch _ {
            print ("JSON Failure")
        }
    }
    
    func authenticate(){
        
    
    }
    
}



