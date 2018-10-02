//
//  CountdownViewController.swift
//  MHacks
//
//  Created by Russell Ladd on 11/12/14.
//  Copyright (c) 2014 MHacks. All rights reserved.
//

import UIKit
import Floaty
import Firebase
import SwiftyJSON

class CountdownViewController: UIViewController {

	@IBOutlet weak var progressIndicator: CircularProgressIndicator!
	@IBOutlet weak var countdownLabel: UILabel!
	@IBOutlet weak var startLabel: UILabel!
	@IBOutlet weak var endLabel: UILabel!

    var configuration: Configuration?
     var ref: DatabaseReference!

	// Delays the initial filling animation by second
	var firstAppearanceDate: Date?

	// MARK: - Lifecycle

	override func viewDidLoad() {

       //setFloaty()

        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes

        self.navigationController?.navigationItem.title = "HackRU"

        ref = Database.database().reference()
        ref.observe(.value, with: { snapshot in
            print(snapshot.value!)

            let swiftJson = JSON(snapshot.value!)

            super.viewDidLoad()

            if let deadline = swiftJson["deadline"].int {
                //Configuration.endDateEpoch = deadline/1000
                print(deadline)
                Configuration.endDateEpoch = deadline/1000

               // Configuration.startDateEpoch = Configuration.endDateEpoch!-86400
                Configuration.startDateEpoch = Date().timeIntervalSince1970.exponent
                if(Configuration.endDateEpoch! - Configuration.startDateEpoch! > 86400) {
                    Configuration.startDateEpoch = Configuration.endDateEpoch!-86400
                }

                self.configuration = Configuration()

                self.tabBarItem.badgeColor = .white

                // Uncomment this for screenshots
                //progressIndicator.progressColor = UIColor.clear
                //progressIndicator.progressColor = MHacksColor.blue

                self.countdownLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 120.0, weight: UIFont.Weight.thin)

                //APIManager.shared.updateConfiguration()
            }

        })

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
//        NotificationCenter.default.addObserver(self, selector: #selector(CountdownViewController.updateCountdownViews(_:)), name: APIManager.ConfigurationUpdatedNotification, object: nil)
//        APIManager.shared.updateConfiguration()

		if firstAppearanceDate == nil {
			firstAppearanceDate = Date()
		}

		beginUpdatingCountdownViews()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		stopUpdatingCountdownViews()
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Model Update

	var timer: Timer?

	func beginUpdatingCountdownViews() {

		updateCountdownViews()
		// FIXME: Use swift method instead?

        progressIndicator.progressColor = HackRUColor.main

		let nextSecond = (Calendar.current as NSCalendar).nextDate(after: Date(), matching: .nanosecond, value: 0, options: .matchNextTime)!

		let timer = Timer(fireAt: nextSecond, interval: 1.0, target: self, selector: #selector(CountdownViewController.timerFire(_:)), userInfo: nil, repeats: true)

		RunLoop.main.add(timer, forMode: RunLoop.Mode.default)

		self.timer = timer
	}

    @objc func timerFire(_ timer: Timer) {
		updateCountdownViews()
	}

	func stopUpdatingCountdownViews() {
		timer?.invalidate()
		timer = nil
	}

	// MARK: - UI Update

    @objc func updateCountdownViews(_: Notification) {

		DispatchQueue.main.async {
			self.updateCountdownViews()
		}
	}

	func updateCountdownViews() {

		if let firstAppearanceDate = firstAppearanceDate, firstAppearanceDate.timeIntervalSinceNow < -0.5 {
            progressIndicator.setProgress((configuration?.progress()) ?? 0.0, animated: true)

		}

		countdownLabel.text = configuration?.timeRemainingDescription
		startLabel.text = configuration?.startDateDescription
		endLabel.text = configuration?.endDateDescription
    }
}
