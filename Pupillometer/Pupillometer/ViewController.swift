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
    
    @IBOutlet var cameraView: UIView!
    @IBOutlet weak var myImg: UIImageView!
    @IBOutlet weak var myImg2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        frontCamera(frontCamera)
        
        if captureDevice != nil {
            beginSession()
        }

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
        }
        
    }
    
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
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    device.torchMode = .on
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

    @IBAction func startButton(_ sender: Any) {
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo){
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(imageDataSampleBuffer, error) in let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                let image = UIImage(data: imageData!)
                print("image taken: \(String(describing: image))")
                let test = UIImageView(image: image)
                test.frame = self.cameraView.frame
                //self.cameraView.addSubview(test)
                self.myImg.image = image
                
                let when = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
                DispatchQueue.main.asyncAfter(deadline: when) {
                self.toggleTorch(on: true)
                
                    
                    let when = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
                    DispatchQueue.main.asyncAfter(deadline: when) {
                self.toggleTorch(on: false)
                }
                }
            })
        }
        let when = DispatchTime.now() + 5 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
        
        if let videoConnection = self.stillImageOutput.connection(withMediaType: AVMediaTypeVideo){
            self.stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: {(imageDataSampleBuffer, error) in let imageData2 = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                let image2 = UIImage(data: imageData2!)
                print("image taken: \(String(describing: image2))")
                let test2 = UIImageView(image: image2)
                test2.frame = self.cameraView.frame
                //self.cameraView.addSubview(test)
                self.myImg2.image = image2
                
                self.performSegue(withIdentifier: "segue", sender: self)
            })
        }
        
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let EditImageViewController = segue.destination as! EditImageViewController
        EditImageViewController.firstPassed = myImg.image!
        EditImageViewController.secondPassed = myImg2.image!
    }
    
    

}

