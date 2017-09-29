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
    @IBOutlet weak var eyeOutline: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstScrollView.isHidden = true
        secondScrollView.isHidden = true
        timerLabel.isHidden = true
        firstImage.isHidden = true
        secondImage.isHidden = true
        eyeOutline.isHidden = true
        startButton.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        frontCamera(frontCamera)

    }
    override func viewDidDisappear(_ animated: Bool) {
        eyeOutline.isHidden = true
        startButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if captureDevice != nil
        {
            beginSession()
        }
        eyeOutline.isHidden = false
        startButton.isHidden = false
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
        let cameraViewBounds = CGRect(x: 0, y: 0, width: cameraView.frame.width, height: cameraView.frame.height)
        previewLayer.frame = cameraViewBounds
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
        self.tabBarController?.tabBar.isHidden = true
        
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

