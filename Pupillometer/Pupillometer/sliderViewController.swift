//
//  sliderViewController.swift
//  Pupillometer
//
//  Created by Chris Hurley on 3/9/17.
//  Copyright © 2017 Chris Hurley. All rights reserved.
//

import UIKit

class sliderViewController: UIViewController, UIScrollViewDelegate {
    
    var firstPassed = UIImage()
    var secondPassed = UIImage()
    
    var firstImage = UIImageView()
    var secondImage = UIImageView()
    
    var fromPage = 2
    
    @IBOutlet weak var firstScrollView: UIScrollView!
    @IBOutlet weak var secondScrollView: UIScrollView!
    
    var area = 0.0
    var thresholds = 0.0
    var circularity = 0.0
    var inertia = 0.0
    var convexity = 0.0
    
    var firstResult = 0.0
    var secondResult = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        firstImage.image = firstPassed
        secondImage.image = secondPassed
        
        firstScrollView.tag = 1
        secondScrollView.tag = 2
        
        firstImage.frame = CGRect(x: 0, y: 0, width: firstScrollView.frame.size.width, height: secondScrollView.frame.size.height)
        //firstImage.image = firstPassed
        secondImage.frame = CGRect(x: 0, y: 0, width: secondScrollView.frame.size.width, height: secondScrollView.frame.size.height)
        //secondImage.image = secondPassed
        
        firstScrollView.addSubview(firstImage)
        secondScrollView.addSubview(secondImage)
        
        firstImage.contentMode = UIViewContentMode.center
        secondImage.contentMode = UIViewContentMode.center
        
        firstImage.frame = CGRect(x: 0, y: 0, width: firstPassed.size.width, height: firstPassed.size.height)
        firstScrollView.contentSize = firstPassed.size
        //firstScroll.center =
        secondImage.frame = CGRect(x: 0, y: 0, width: secondPassed.size.width, height: secondPassed.size.height)
        secondScrollView.contentSize = secondPassed.size
        
        let scrollViewFrame1 = firstScrollView.frame
        let scaleWidth1 = scrollViewFrame1.size.width / firstScrollView.contentSize.width
        let scaleHeight1 = scrollViewFrame1.size.height / firstScrollView.contentSize.height
        let minScale1 = min(scaleHeight1, scaleWidth1)
        
        let scrollViewFrame = secondScrollView.frame
        let scaleWidth = scrollViewFrame.size.width / secondScrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / secondScrollView.contentSize.height
        let minScale = min(scaleHeight, scaleWidth)
        
        
        firstScrollView.minimumZoomScale = minScale1
        firstScrollView.maximumZoomScale = 1
        firstScrollView.zoomScale = minScale1
        
        
        
        secondScrollView.minimumZoomScale = minScale
        secondScrollView.maximumZoomScale = 1
        secondScrollView.zoomScale = minScale
        
        centerScrollViewContents1()
        centerScrollViewContents2()
        

        // Do any additional setup after loading the view.
        


        // Do any additional setup after loading the view.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView.tag == 1 {
            firstScrollView.delegate = self
            return firstImage
        }
        else{
            secondScrollView.delegate = self
            return secondImage
        }
    }
    
    func centerScrollViewContents1(){
        
        
        let boundsSize = firstScrollView.bounds.size
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
    
    func centerScrollViewContents2(){
        
        
        let boundsSize = secondScrollView.bounds.size
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
        
        centerScrollViewContents1()
        
        centerScrollViewContents2()
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func circularity1Slider(_ sender: UISlider) {
        circularity = Double(Float(sender.value))
        let circularity2 = Double(OpenCVWrapper.setCir(Double(circularity)))
        
        
        firstImage.image = firstPassed
        firstImage.image = OpenCVWrapper.makeGray(from: firstImage.image)
        firstResult = OpenCVWrapper.firstResult()

    }
    @IBAction func convexity1Slider(_ sender: UISlider) {
        convexity = Double(Float(sender.value))

        let convexity2 = Double(OpenCVWrapper.setConv(Double(convexity)))
        
        
        firstImage.image = firstPassed
        firstImage.image = OpenCVWrapper.makeGray(from: firstImage.image)
        firstResult = OpenCVWrapper.firstResult()

    }
    @IBAction func inertia1Slider(_ sender: UISlider) {
        inertia = Double(Float(sender.value))

        let inertia2 = Double(OpenCVWrapper.setIner(Double(inertia)))
        
        
        firstImage.image = firstPassed
        firstImage.image = OpenCVWrapper.makeGray(from: firstImage.image)
        firstResult = OpenCVWrapper.firstResult()

    }
    
    @IBAction func circularity2Slider(_ sender: UISlider) {
        circularity = Double(Float(sender.value))
        let circularity2 = Double(OpenCVWrapper.setCir(Double(circularity)))
        
        
        secondImage.image = secondPassed
        secondImage.image = OpenCVWrapper.makeGray(from: secondImage.image)
        secondResult = OpenCVWrapper.firstResult()

    }
    @IBAction func convexity2Slider(_ sender: UISlider) {
        convexity = Double(Float(sender.value))

        let convexity2 = Double(OpenCVWrapper.setConv(Double(convexity)))
        
        
        secondImage.image = secondPassed
        secondImage.image = OpenCVWrapper.makeGray(from: secondImage.image)
        secondResult = OpenCVWrapper.firstResult()

    }
    @IBAction func inertia2Slider(_ sender: UISlider) {
        inertia = Double(Float(sender.value))

        let inertia2 = Double(OpenCVWrapper.setIner(Double(inertia)))
        
        
        secondImage.image = secondPassed
        secondImage.image = OpenCVWrapper.makeGray(from: secondImage.image)
        secondResult = OpenCVWrapper.firstResult()

    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "back", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "back")
        {
            let ResultsViewController = segue.destination as! ResultsViewController
            ResultsViewController.firstPassed = firstImage.image!
            ResultsViewController.secondPassed = secondImage.image!
            ResultsViewController.firstResultsPassed = firstResult
            ResultsViewController.secondResultsPassed = secondResult
            ResultsViewController.fromPage = fromPage
            
        }
        
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
