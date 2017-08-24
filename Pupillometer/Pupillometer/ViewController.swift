//
//  ViewController.swift
//  Pupillometer
//
//  Created by Chris Hurley on 12/7/17.
//  Copyright © 2017 Chris Hurley. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var captureSession = AVCaptureSession()
    var previewLayer = AVCaptureVideoPreviewLayer()
    var captureDevice: AVCaptureDevice?
    var frontCamera: Bool = true
    var stillImageOutput: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
    let minimumZoom: CGFloat = 1.0
    let maximumZoom: CGFloat = 3.0
    var lastZoomFactor: CGFloat = 1.0
    
    var seconds = 60 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet var cameraView: UIView!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerLabel.isHidden = true
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        frontCamera(frontCamera)
        lowLight(on: true)
        if captureDevice != nil {
            beginSession()
        }

    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        seconds -= 1     //This will decrement(count down)the seconds.
        timerLabel.text = "\(seconds)" //This will update the label.
    }
    
    func beginSession(){
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraView.layer.addSublayer(previewLayer)
        previewLayer.frame = self.cameraView.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        captureSession.startRunning()
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        if captureSession.canAddOutput(stillImageOutput){
            captureSession.addOutput(stillImageOutput)
            //captureSession.= OpenCVWrapper.makeGray(from: captureSession.image)

        }
        
    }
    
    // Front camera function
    func frontCamera(_ front:Bool){
        let devices = AVCaptureDevice.devices()

        do {
            try captureSession.removeInput(AVCaptureDeviceInput(device: captureDevice))
        }
        catch {
            print("error")
        }
        
        for device in devices!{
            
            if((device as AnyObject).hasMediaType(AVMediaTypeVideo)){
                if front{
                    if (device as AnyObject).position == AVCaptureDevicePosition.back {
                        captureDevice = device as? AVCaptureDevice
                        
                        do {
                            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
                            
                        }
                        catch {
                            
                        }
                        break
                    }
                    
                }
            }
        }
    }
    
    func lowLight(on: Bool) {
        guard let device2 = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else { return }
        
        if device2.hasTorch {
            do {
                try device2.lockForConfiguration()
                
                if on == true {
                    //device2.torchMode = .on
                    try  device2.setTorchModeOnWithLevel(0.1)
                    //device.setTorchModeOnWithLevel(Float(lightLevel)/Float(maxLightLevel))
                    
                } else {
                    device2.torchMode = .on
                }
                
                device2.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    
    // torch function
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .on
                   //try  device.setTorchModeOnWithLevel(0.1)
                    //device.setTorchModeOnWithLevel(Float(lightLevel)/Float(maxLightLevel))

                } else {
                    device.torchMode = .off
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        DispatchQueue.main.asyncAfter(deadline: when) {
            
        // Take second image
        if let videoConnection = self.stillImageOutput.connection(withMediaType: AVMediaTypeVideo){
            self.stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(imageDataSampleBuffer, error) in let imageData2 = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                let imageTwo = UIImage(data: imageData2!)
                print("image taken: \(String(describing: imageTwo))")
                self.secondImage.image = imageTwo
                
                self.performSegue(withIdentifier: "first", sender: self)
            })
        }
        
        }
    }
    
    // Send both images to the EditImageViewController page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let FirstCropViewController = segue.destination as! FirstCropViewController
        FirstCropViewController.firstPassed = firstImage.image!
        FirstCropViewController.secondPassed = secondImage.image!
    }
    
    
    // Camera zoom in function
    @IBAction func testThing(_ pinch: UIPinchGestureRecognizer) {
        guard let device = captureDevice else { return }
        
        // Return zoom value between the minimum and maximum zoom values
        func minMaxZoom(_ factor: CGFloat) -> CGFloat {
            return min(min(max(factor, minimumZoom), maximumZoom), device.activeFormat.videoMaxZoomFactor)
        }
        
        func update(scale factor: CGFloat) {
            do {
                try device.lockForConfiguration()
                defer { device.unlockForConfiguration() }
                device.videoZoomFactor = factor
            } catch {
                print("\(error.localizedDescription)")
            }
        }
        
        let newScaleFactor = minMaxZoom(pinch.scale * lastZoomFactor)
        
        switch pinch.state {
        case .began: fallthrough
        case .changed: update(scale: newScaleFactor)
        case .ended:
            lastZoomFactor = minMaxZoom(newScaleFactor)
            update(scale: lastZoomFactor)
        default: break
        }
        
    }
    
    

}

