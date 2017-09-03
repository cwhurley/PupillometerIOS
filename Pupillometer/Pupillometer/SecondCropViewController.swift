//
//  SecondCropViewController.swift
//  Pupillometer
//
//  Created by Chris Hurley on 8/8/17.
//  Copyright © 2017 Chris Hurley. All rights reserved.
//

import UIKit

class SecondCropViewController: UIViewController, UIScrollViewDelegate {
    var firstPassed = UIImage()
    var secondPassed = UIImage()
    var firstImage = UIImageView()
    var secondImage = UIImageView()
    var fromPage = 1
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        secondImage.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        firstImage.image = firstPassed
        secondImage.image = secondPassed
        
        scrollView.addSubview(secondImage)
        
        
        
        secondImage.contentMode = UIViewContentMode.center
        
        
        secondImage.frame = CGRect(x: 0, y: 0, width: secondPassed.size.width, height: secondPassed.size.height)
        scrollView.contentSize = secondPassed.size
        
        
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleHeight, scaleWidth)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 1
        scrollView.zoomScale = minScale
        
        centerScrollViewContents()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func centerScrollViewContents(){
        let boundsSize = scrollView.bounds.size
        var contentsFrame = secondImage.frame
        
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
        
        secondImage.frame = contentsFrame
        
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return secondImage
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        UIGraphicsBeginImageContextWithOptions(scrollView.bounds.size, true, UIScreen.main.scale)
        let offset = scrollView.contentOffset
        
        UIGraphicsGetCurrentContext()?.translateBy(x: -offset.x, y: -offset.y)
        scrollView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        secondImage.image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()

        self.performSegue(withIdentifier: "results", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "results")
        {
        let ResultsViewController = segue.destination as! ResultsViewController
        ResultsViewController.firstPassed = firstImage.image!
        ResultsViewController.secondPassed = secondImage.image!
            fromPage = 1
            ResultsViewController.fromPage = fromPage
        }
    }
}
