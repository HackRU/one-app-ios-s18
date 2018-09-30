//
//  Extensions.swift
//  MHacks
//
//  Created by Manav Gabhawala on 12/18/15.
//  Copyright © 2015 MHacks. All rights reserved.
//

import Foundation
import UIKit

// This file is to make Foundation more Swifty

extension String {
	public var sentenceCapitalizedString: String {
		var formatted = ""
		enumerateSubstrings(in: startIndex..<endIndex, options: NSString.EnumerationOptions.bySentences, { sentence, sentenceRange, enclosingRange, stop in
			guard let sentence = sentence
			else {
				return
			}
            formatted += sentence.replacingCharacters(in: self.startIndex..<self.index(self.startIndex, offsetBy: 1), with: sentence.substring(to: sentence.index(after: sentence.startIndex)).capitalized)
            
            
		})
		// Add trailing full stop.
		if (formatted[formatted.index(before: formatted.endIndex)] != ".") {
			formatted += "."
		}
		return formatted
	}
}

let groupName = "group.com.HackRU.OneAppiOS"
let defaults = UserDefaults(suiteName: groupName)!
let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupName)!.appendingPathComponent("Library", isDirectory: true).appendingPathComponent("Application Support", isDirectory: true)

let cacheContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupName)!.appendingPathComponent("Library", isDirectory: true).appendingPathComponent("Caches", isDirectory: true)

// MARK: - Keys for User Defaults

let remoteNotificationTokenKey = "remote_notification_token"
let remoteNotificationPreferencesKey = "remote_notification_preferences"

// MARK: - Color constants
struct HackRUColor {
    
   
    
    static var main: UIColor {
        return UIColor(red: 120.0 / 255.0, green: 82.0 / 255.0, blue: 201.0 / 255.0, alpha: 1.0)
    }
    
    static var secondary: UIColor {
        return UIColor(red: 57.0 / 255.0, green: 39.0 / 255.0, blue: 94.0 / 255.0, alpha: 1.0)
    }
    
    static var dark: UIColor {
        return UIColor(red: 31.0 / 255.0, green: 74.0 / 255.0, blue: 181.0 / 255.0, alpha: 1.0)
    }
    
    
    
    
    
	static var blue: UIColor {
        
		return UIColor(red: 31.0 / 255.0, green: 74.0 / 255.0, blue: 181.0 / 255.0, alpha: 1.0)
	}
    static var lightBlue: UIColor {
        return UIColor(red: 35.0 / 255.0, green: 169.0 / 255.0, blue: 225.0 / 255.0, alpha: 1.0)
    }

    static var cloudBlue: UIColor {

        return UIColor(red: 232.0 / 255.0, green: 246.0 / 255.0, blue: 252.0 / 255.0, alpha: 1.0)

    }

	static var red: UIColor {
		return UIColor.red
	}
	static var yellow: UIColor {
		return UIColor(red: 255.0 / 255.0, green: 202.0 / 255.0, blue: 11.0 / 255.0, alpha: 1.0)
	}
	static var orange: UIColor {
		return UIColor(red: 241.0 / 255.0, green: 103.0 / 255.0, blue: 88.0 / 255.0, alpha: 1.0)
	}
	static var purple: UIColor {
		return UIColor(red: 93.0 / 255.0, green: 62.0 / 255.0, blue: 110.0 / 255.0, alpha: 1.0)
	}
	static var plain: UIColor {
		#if os(watchOS)
		return UIColor.white
		#else
		return UIColor.gray
		#endif
	}
}
