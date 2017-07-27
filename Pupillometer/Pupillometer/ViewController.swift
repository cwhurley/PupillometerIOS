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
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startButton(_ sender: Any) {
    }

}

