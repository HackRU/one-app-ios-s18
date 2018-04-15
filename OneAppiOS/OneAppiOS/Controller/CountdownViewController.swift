//
//  CountdownViewController.swift
//  MHacks
//
//  Created by Russell Ladd on 11/12/14.
//  Copyright (c) 2014 MHacks. All rights reserved.
//

import UIKit
import Floaty

class CountdownViewController: UIViewController {

	@IBOutlet weak var progressIndicator: CircularProgressIndicator!
	@IBOutlet weak var countdownLabel: UILabel!
	@IBOutlet weak var startLabel: UILabel!
	@IBOutlet weak var endLabel: UILabel!
    
    var configuration: Configuration?
	
	// Delays the initial filling animation by second
	var firstAppearanceDate: Date?
	
	// MARK: - Lifecycle
    
    func setFloaty(){
        let floaty = Floaty()
       floaty.openAnimationType = .fade
        floaty.buttonColor = HackRUColor.lightBlue
        floaty.plusColor = .white
        floaty.addItem(title: "Hello, World!")
        
        floaty.addItem("QR", icon: UIImage(named: "qr"), handler: { item in
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            alert.view.sizeThatFits(CGSize(width: self.view.bounds.width, height: self.view.bounds.width))
            //alert.addAction(UIAlertAction(title: "QR", style: .default, image: !))
            
            var img = UIImage(named: "qr")
            img = img?.imageWithSize(CGSize(width: alert.view.bounds.width * 0.6, height: alert.view.bounds.width * 0.6))
            
            alert.addAction(UIAlertAction(title: "QR", style: .default, image: img!))
        
            self.present(alert, animated: true, completion: nil)
        })
        
        self.view.addSubview(floaty)
        
    }
	
	override func viewDidLoad() {
        
       setFloaty()
        
		super.viewDidLoad()
        
        configuration = Configuration()
		
		// Uncomment this for screenshots
		//progressIndicator.progressColor = UIColor.clear
        //progressIndicator.progressColor = MHacksColor.blue
		
        countdownLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 120.0, weight: UIFont.Weight.thin)
    
        
		//APIManager.shared.updateConfiguration()
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
        
        progressIndicator.progressColor = HackRUColor.lightBlue
        
		let nextSecond = (Calendar.current as NSCalendar).nextDate(after: Date(), matching: .nanosecond, value: 0, options: .matchNextTime)!
		
		let timer = Timer(fireAt: nextSecond, interval: 1.0, target: self, selector: #selector(CountdownViewController.timerFire(_:)), userInfo: nil, repeats: true)
		
		RunLoop.main.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
		
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

		if let firstAppearanceDate = firstAppearanceDate , firstAppearanceDate.timeIntervalSinceNow < -0.5 {
            progressIndicator.setProgress((configuration?.progress())!, animated: true)
		}
		
		countdownLabel.text = configuration?.timeRemainingDescription
		startLabel.text = configuration?.startDateDescription
		endLabel.text = configuration?.endDateDescription
    }
}

