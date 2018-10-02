//
//  SplashViewController.swift
//  OneAppiOS
//
//  Created by Qasim Abbas on 4/10/18.
//  Copyright © 2018 Qasim Abbas. All rights reserved.
//

import UIKit
import RippleEffectView

class SplashViewController: UIViewController {

    var CIFilterNames = [
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone"
    ]

    var rippleEffectView: RippleEffectView?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black

        rippleEffectView = RippleEffectView()

        var img = UIImage(named: "wave")

        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: img!)
        let filter = CIFilter(name: "CIPhotoEffectFade" )
        filter!.setDefaults()
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        guard let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as? CIImage else {
            return
        }
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        img = UIImage(cgImage: filteredImageRef!)
        rippleEffectView?.tileImage = img

        rippleEffectView?.magnitude = -0.4
        rippleEffectView?.cellSize = CGSize(width: 50, height: 50)
        rippleEffectView?.rippleType = .oneWave
        rippleEffectView?.animationDuration = 5.0

        view.addSubview((rippleEffectView)!)

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        rippleEffectView?.startAnimating()
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
