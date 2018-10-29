//
//  Extensions.swift
//  MHacks
//
//  Created by Manav Gabhawala on 12/18/15.
//  Copyright © 2015 MHacks. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

// This file is to make Foundation more Swifty

extension String {
	public var sentenceCapitalizedString: String {
		var formatted = ""
		enumerateSubstrings(in: startIndex..<endIndex, options: NSString.EnumerationOptions.bySentences, { sentence, _, _, _ in
			guard let sentence = sentence
			else {
				return
			}
//            formatted += sentence.replacingCharacters(in: self.startIndex..<self.index(self.startIndex, offsetBy: 1), with: sentence.substring(to: sentence.index(after: sentence.startIndex)).capitalized)
            formatted += sentence.replacingCharacters(in: self.startIndex..<self.index(self.startIndex, offsetBy: 1), with: self.prefix(upTo: sentence.index(after: sentence.startIndex)).capitalized)

		})
		// Add trailing full stop.
		if formatted[formatted.index(before: formatted.endIndex)] != "." {
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

    //Main Color Hex: #7852C9
    static var main: UIColor {
        return UIColor(hex: "444444")
    }

    //Secondary Color Hex: #FFF242
    static var secondary: UIColor {
        return UIColor(hex: "26E8BD")
    }

    //Dark Color Hex: #39275E
    static var dark: UIColor {
         return UIColor(hex: "26E8BD")
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

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0

        var rgbValue: UInt64 = 0

        scanner.scanHexInt64(&rgbValue)

        let red = (rgbValue & 0xff0000) >> 16
        let green = (rgbValue & 0xff00) >> 8
        let blue = rgbValue & 0xff

        self.init(
            red: CGFloat(red) / 0xff,
            green: CGFloat(green) / 0xff,
            blue: CGFloat(blue) / 0xff, alpha: 1
        )
    }
}
