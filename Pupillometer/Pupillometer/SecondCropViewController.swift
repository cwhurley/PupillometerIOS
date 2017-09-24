//
//  SecondCropViewController.swift
//  Pupillometer
//
//  Created by Chris Hurley on 8/8/17.
//  Copyright © 2017 Chris Hurley. All rights reserved.
//

import UIKit

class SecondCropViewController: UIViewController, UIScrollViewDelegate {
    
    // Variables
    var firstPassed = UIImage()
    var secondPassed = UIImage()
    var firstImage = UIImageView()
    var fromPage = 1
    var stringPassed = String()
    var passingImage = UIImage()
    var circleCenter: CGPoint!
    var firstResult = Double()
    var secondResult = Double()
    var secondWidth = Double()
    
    // Outlets
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var autoView: UIView!
    @IBOutlet weak var manualView: UIView!
    @IBOutlet weak var secondImageManual: UIImageView!
    @IBOutlet weak var circleImage: UIImageView!
  
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if stringPassed == "auto"
        {
            manualView.isHidden = true
            autoView.isHidden = false
            secondImage.image = secondPassed
            passingImage = secondImage.image!
            autoView.center.x = self.view.center.x
            autoView.center.y = self.view.center.y
        }
        else if stringPassed == "manual"
        {
            manualView.isHidden = false
            autoView.isHidden = true
            secondImage.image = secondPassed
            secondImageManual.image = secondPassed
            passingImage = secondImageManual.image!
            circleImage.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.dragCircle)))
            manualView.center.x = self.view.center.x
            manualView.center.y = self.view.center.y
            
        }
        firstImage.image = firstPassed
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Called on when the slider has changed value
    @IBAction func scaleSlider(_ sender: UISlider) {
        circleImage.transform = CGAffineTransform(scaleX: CGFloat(sender.value), y: CGFloat(sender.value))
        secondWidth = Double(circleImage.frame.width)
    }
    
    // Function for dragging the circle image around the view
    func dragCircle(gesture: UIPanGestureRecognizer) {
        let target = gesture.view!
        
        switch gesture.state {
        case .began, .ended:
            if (circleImage.frame.origin.y > secondImage.frame.origin.y + secondImage.frame.size.height || circleImage.frame.origin.y < secondImage.frame.origin.y || circleImage.frame.origin.x > secondImage.frame.origin.x + secondImage.frame.size.width || circleImage.frame.origin.x < secondImage.frame.origin.x)
            {
                target.center = CGPoint(x: secondImage.frame.origin.x + (secondImage.frame.size.width / 2), y: secondImage.frame.origin.y + (secondImage.frame.size.height / 2))
            }
            circleCenter = target.center
        case .changed:
            let translation = gesture.translation(in: self.view)
            target.center = CGPoint(x: circleCenter!.x + translation.x, y: circleCenter!.y + translation.y)
        default: break
            
            
        }
    }
    
    // Used for resizing the image
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        
        
        image.draw(in: CGRect(x: 0, y: 0,width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func resizeToScreenSize(image: UIImage)->UIImage{
        
        let screenSize = self.view.bounds.size
        
        
        return resizeImage(image: image, newWidth: screenSize.width)
    }
    
    // Next button calls on the next view controller
    @IBAction func nextButton(_ sender: UIButton) {
        if stringPassed == "manual"{
            
            UIGraphicsBeginImageContext(secondImage.frame.size)
            manualView.layer.render(in: UIGraphicsGetCurrentContext()!)
            secondImage.image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        firstImage.image = resizeImage(image: firstImage.image!, newWidth: 350)
        passingImage = resizeImage(image: secondImage.image!, newWidth: 350)

        self.performSegue(withIdentifier: "results", sender: self)
    }
    
    // Sends the data to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "results")
        {
        let ResultsViewController = segue.destination as! ResultsViewController
        ResultsViewController.firstPassed = firstImage.image!
        ResultsViewController.secondPassed = passingImage
            fromPage = 1
            ResultsViewController.fromPage = fromPage
            ResultsViewController.stringPassed = stringPassed
            ResultsViewController.firstResult = firstResult
            ResultsViewController.secondResult = secondWidth
        }
    }
}
