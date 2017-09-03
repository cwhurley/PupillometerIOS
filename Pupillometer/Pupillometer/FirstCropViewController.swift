//
//  FirstCropViewController.swift
//  Pupillometer
//
//  Created by Chris Hurley on 8/8/17.
//  Copyright © 2017 Chris Hurley. All rights reserved.
//

import UIKit

class FirstCropViewController: UIViewController, UIScrollViewDelegate {
    var firstPassed = UIImage()
    var secondPassed = UIImage()
    var firstImage = UIImageView()
    var secondImage = UIImageView()

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        firstImage.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        firstImage.image = firstPassed
        secondImage.image = secondPassed
        
        scrollView.addSubview(firstImage)
        

    
        firstImage.contentMode = UIViewContentMode.center

        
        firstImage.frame = CGRect(x: 0, y: 0, width: firstPassed.size.width, height: firstPassed.size.height)
        scrollView.contentSize = firstPassed.size
        
        
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleHeight, scaleWidth)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 1
        scrollView.zoomScale = minScale
        
        centerScrollViewContents()
        //firstImage.image = OpenCVWrapper.makeGray(from: firstImage.image)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func centerScrollViewContents(){
        let boundsSize = scrollView.bounds.size
        var contentsFrame = firstImage.frame
        
        if contentsFrame.size.width < boundsSize.width{
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2
        }else{
            contentsFrame.origin.x = 0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2
        }else{
            contentsFrame.origin.y = 0
        }
        
        firstImage.frame = contentsFrame
        
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return firstImage
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        UIGraphicsBeginImageContextWithOptions(scrollView.bounds.size, true, UIScreen.main.scale)
        let offset = scrollView.contentOffset
        
        UIGraphicsGetCurrentContext()?.translateBy(x: -offset.x, y: -offset.y)
        scrollView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        firstImage.image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        
            self.performSegue(withIdentifier: "second", sender: self)
        
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "second")
        {
        let SecondCropViewController = segue.destination as! SecondCropViewController
        SecondCropViewController.firstPassed = firstImage.image!
        SecondCropViewController.secondPassed = secondImage.image!
        }
        
    }
    


}
