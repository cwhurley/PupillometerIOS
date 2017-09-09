//
//  ViewController.swift
//  Pupillometer
//
//  Created by Chris Hurley on 12/7/17.
//  Copyright © 2017 Chris Hurley. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIScrollViewDelegate {
    
    // Variables
    var captureSession = AVCaptureSession()
    var previewLayer = AVCaptureVideoPreviewLayer()
    var captureDevice: AVCaptureDevice?
    var frontCamera: Bool = true
    var stillImageOutput: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
    let minimumZoom: CGFloat = 1.0
    let maximumZoom: CGFloat = 3.0
    var lastZoomFactor: CGFloat = 1.0
    var stringPassing = "auto"
    var firstImage = UIImageView()
    var secondImage = UIImageView()
    var seconds = 6
    var timer = Timer()
    var isTimerRunning = false
    
    // Outlets
    @IBOutlet weak var firstScrollView: UIScrollView!
    @IBOutlet weak var secondScrollView: UIScrollView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet var cameraView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstScrollView.isHidden = true
        secondScrollView.isHidden = true
        timerLabel.isHidden = true
        firstImage.isHidden = true
        secondImage.isHidden = true
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        frontCamera(frontCamera)
        if captureDevice != nil
        {
            beginSession()
        }
    }
    
    // Timer function
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    // Segment controller for user to select either auto or manual
    @IBAction func detectionType(_ sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            stringPassing = "auto"
            
        case 1:
            stringPassing = "manual"
        default:
            break;
        }
        
    }
    
    // Help button that calls UIAlert
    @IBAction func helpButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Help", message: "If this is the first time using our app or you are unsure about a specific function, please head over to our How To Use page.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Thanks!", style: .default, handler: nil)
        
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)    }
    
    // Updating timer function
    func updateTimer() {
        seconds -= 1
        timerLabel.text = "\(seconds)"
    }
    
    // For beggining the camera session
    func beginSession(){
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraView.layer.addSublayer(previewLayer)
        previewLayer.frame = self.cameraView.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        captureSession.startRunning()
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        if captureSession.canAddOutput(stillImageOutput)
        {
            captureSession.addOutput(stillImageOutput)
        }
    }
    
    // Front camera function
    func frontCamera(_ front:Bool){
        let devices = AVCaptureDevice.devices()

        do
        {
            try captureSession.removeInput(AVCaptureDeviceInput(device: captureDevice))
        }
        catch
        {
            print("error")
        }
        
        for device in devices!
        {
            if((device as AnyObject).hasMediaType(AVMediaTypeVideo))
            {
                if front
                {
                    if (device as AnyObject).position == AVCaptureDevicePosition.back
                    {
                        captureDevice = device as? AVCaptureDevice
                        do
                        {
                            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
                        }
                        catch
                        {
                            
                        }
                        break
                    }
                }
            }
        }
    }
    
    // torch function
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else { return }
        
        if device.hasTorch
        {
            do
            {
                try device.lockForConfiguration()
                if on == true
                {
                    device.torchMode = .on
                }
                else
                {
                    device.torchMode = .off
                }
                device.unlockForConfiguration()
            }
            catch
            {
                print("Torch could not be used")
            }
        }
        else
        {
            print("Torch is not available")
        }
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Start button process
    @IBAction func startButton(_ sender: Any) {
        
        self.runTimer()
        startButton.isHidden = true
        timerLabel.isHidden = false
        
        // Take first image
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo){
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(imageDataSampleBuffer, error) in let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)

                let imageOne = UIImage(data: imageData!)
                print("image taken: \(String(describing: imageOne))")
                self.firstImage.image = imageOne
                
                // After 0.5 seconds, turn the torch on
                let when = DispatchTime.now() + 0.5
                DispatchQueue.main.asyncAfter(deadline: when) {
                self.toggleTorch(on: true)
                
                    // After 0.5 seconds, turn the torch off
                    let when = DispatchTime.now() + 0.5
                    DispatchQueue.main.asyncAfter(deadline: when) {
                self.toggleTorch(on: false)
                }
                }
            })
        }
        
        // After 5 seconds...
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when)
        {
            
        // Take second image
        if let videoConnection = self.stillImageOutput.connection(withMediaType: AVMediaTypeVideo)
        {
            self.stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(imageDataSampleBuffer, error) in let imageData2 = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                let imageTwo = UIImage(data: imageData2!)
                print("image taken: \(String(describing: imageTwo))")
                self.secondImage.image = imageTwo
                
                self.performSegue(withIdentifier: "first", sender: self)
            })
        }
        }
        
        
        
        firstScrollView.tag = 1
        secondScrollView.tag = 2
        
        firstImage.frame = CGRect(x: 0, y: 0, width: firstScrollView.frame.size.width, height: secondScrollView.frame.size.height)
        
        secondImage.frame = CGRect(x: 0, y: 0, width: secondScrollView.frame.size.width, height: secondScrollView.frame.size.height)
        
        
        firstScrollView.addSubview(firstImage)
        secondScrollView.addSubview(secondImage)
        
        firstImage.contentMode = UIViewContentMode.center
        secondImage.contentMode = UIViewContentMode.center
        
        firstImage.frame = CGRect(x: 0, y: 0, width: firstImage.frame.size.width, height: firstImage.frame.size.height)
        firstScrollView.contentSize = firstImage.frame.size
        //firstScroll.center =
        secondImage.frame = CGRect(x: 0, y: 0, width: secondImage.frame.size.width, height: secondImage.frame.size.height)
        secondScrollView.contentSize = secondImage.frame.size
        
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
        
        UIGraphicsBeginImageContextWithOptions(firstScrollView.bounds.size, true, UIScreen.main.scale)
        var offset = firstScrollView.contentOffset
        
        UIGraphicsGetCurrentContext()?.translateBy(x: -offset.x, y: -offset.y)
        firstScrollView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        firstImage.image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContextWithOptions(secondScrollView.bounds.size, true, UIScreen.main.scale)
        offset = secondScrollView.contentOffset
        
        UIGraphicsGetCurrentContext()?.translateBy(x: -offset.x, y: -offset.y)
        secondScrollView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        secondImage.image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
    }
    
    // For scroll view
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
    
    // For scroll view
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
    
    // Send both images to the FirstCropViewController page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let FirstCropViewController = segue.destination as! FirstCropViewController
        FirstCropViewController.firstPassed = firstImage.image!
        FirstCropViewController.secondPassed = secondImage.image!
        FirstCropViewController.stringPassed = stringPassing
    }
    
    // Camera zoom in function
    @IBAction func cameraZoom(_ pinch: UIPinchGestureRecognizer) {
        guard let device = captureDevice else { return }
        
        // Return zoom value between the minimum and maximum zoom values
        func minMaxZoom(_ factor: CGFloat) -> CGFloat
        {
            return min(min(max(factor, minimumZoom), maximumZoom), device.activeFormat.videoMaxZoomFactor)
        }
        
        func update(scale factor: CGFloat)
        {
            do
            {
                try device.lockForConfiguration()
                defer { device.unlockForConfiguration()
                }
                device.videoZoomFactor = factor
            }
            catch
            {
                print("\(error.localizedDescription)")
            }
        }
        
        let newScaleFactor = minMaxZoom(pinch.scale * lastZoomFactor)
        
        switch pinch.state
        {
        case .began: fallthrough
        case .changed: update(scale: newScaleFactor)
        case .ended:
            lastZoomFactor = minMaxZoom(newScaleFactor)
            update(scale: lastZoomFactor)
        default: break
        }
    }
}

