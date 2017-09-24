//
//  FirstCropViewController.swift
//  Pupillometer
//
//  Created by Chris Hurley on 8/8/17.
//  Copyright © 2017 Chris Hurley. All rights reserved.
//

import UIKit
import CoreGraphics

class FirstCropViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // Variables
    var firstPassed = UIImage()
    var secondPassed = UIImage()
    var secondImage = UIImageView()
    var stringPassed = String()
    var passingImage = UIImage()
    var circleCenter: CGPoint!
    var firstWidth = 0.0
    
    // Outlets
    @IBOutlet weak var circleImage: UIImageView!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var firstImageManual: UIImageView!
    @IBOutlet weak var manualView: UIView!
    @IBOutlet weak var autoView: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if stringPassed == "auto"
        {
            manualView.isHidden = true
            autoView.isHidden = false
            firstImage.image = firstPassed
            passingImage = firstImage.image!
            autoView.center.x = self.view.center.x
            autoView.center.y = self.view.center.y
        }
        else if stringPassed == "manual"
        {
            manualView.isHidden = false
            autoView.isHidden = true
            firstImageManual.image = firstPassed
            passingImage = firstImageManual.image!
            circleImage.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.dragCircle)))
            manualView.center.x = self.view.center.x
            manualView.center.y = self.view.center.y
        }
        secondImage.image = secondPassed

    }
    

    // Function for dragging the circle image around the view
    func dragCircle(gesture: UIPanGestureRecognizer) {
        let target = gesture.view!
        
        switch gesture.state {
        case .began, .ended:
            if (circleImage.frame.origin.y > firstImage.frame.origin.y + firstImage.frame.size.height || circleImage.frame.origin.y < firstImage.frame.origin.y || circleImage.frame.origin.x > firstImage.frame.origin.x + firstImage.frame.size.width || circleImage.frame.origin.x < firstImage.frame.origin.x)
            {
                target.center = CGPoint(x: firstImage.frame.origin.x + (firstImage.frame.size.width / 2), y: firstImage.frame.origin.y + (firstImage.frame.size.height / 2))
            }
            circleCenter = target.center

        case .changed:
            let translation = gesture.translation(in: self.view)
            target.center = CGPoint(x: circleCenter!.x + translation.x, y: circleCenter!.y + translation.y)
        default: break
        }
    }
    
    // Called on when the slider has changed value
    @IBAction func scaleSlider(_ sender: UISlider) {
        circleImage.transform = CGAffineTransform(scaleX: CGFloat(sender.value), y: CGFloat(sender.value))
        firstWidth = Double(circleImage.frame.width)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Next button calls on the next view controller
    @IBAction func nextButton(_ sender: UIButton) {
        
        if stringPassed == "manual"{
            
            UIGraphicsBeginImageContext(firstImage.frame.size)
            manualView.layer.render(in: UIGraphicsGetCurrentContext()!)
            passingImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        self.performSegue(withIdentifier: "second", sender: self)
        
    }
    
    // Sends the data to the next view controller
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "second")
        {
        let SecondCropViewController = segue.destination as! SecondCropViewController
        SecondCropViewController.firstPassed = passingImage
        SecondCropViewController.secondPassed = secondImage.image!
        SecondCropViewController.stringPassed = stringPassed
            SecondCropViewController.firstResult = firstWidth
            
        }
        
    }
    


}
