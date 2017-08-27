//
//  ResultsViewController.swift
//  Pupillometer
//
//  Created by Chris Hurley on 8/8/17.
//  Copyright © 2017 Chris Hurley. All rights reserved.
//
//https://www.youtube.com/watch?v=VuiPGJOEBH4

import UIKit
import CoreData

class ResultsViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    //@IBOutlet weak var firstImage: UIImageView!
   // @IBOutlet weak var secondImage: UIImageView!
    
    @IBOutlet weak var firstScroll: UIScrollView!
    @IBOutlet weak var secondScroll: UIScrollView!
    var firstImage = UIImageView()
    var secondImage = UIImageView()
    @IBOutlet var nameText: UITextField!
    @IBOutlet var ageText: UITextField!
    @IBOutlet var genderText: UITextField!
    @IBOutlet var eyeText: UITextField!
    @IBOutlet var notesText: UITextField!
    
    @IBOutlet var scrollView: UIScrollView!
    
    
    
        var firstPassed = UIImage()
        var secondPassed = UIImage()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstScroll.tag = 1
        secondScroll.tag = 2
        



        firstImage.frame = CGRect(x: 0, y: 0, width: firstScroll.frame.size.width, height: firstScroll.frame.size.height)
        firstImage.image = firstPassed
        secondImage.frame = CGRect(x: 0, y: 0, width: secondScroll.frame.size.width, height: secondScroll.frame.size.height)
        secondImage.image = secondPassed
        
        
        firstScroll.addSubview(firstImage)
        secondScroll.addSubview(secondImage)
        
        
        firstImage.contentMode = UIViewContentMode.center
        secondImage.contentMode = UIViewContentMode.center
        
        firstImage.frame = CGRect(x: 0, y: 0, width: firstPassed.size.width, height: firstPassed.size.height)
        firstScroll.contentSize = firstPassed.size
        //firstScroll.center =
        secondImage.frame = CGRect(x: 0, y: 0, width: secondPassed.size.width, height: secondPassed.size.height)
        secondScroll.contentSize = secondPassed.size
        
        let scrollViewFrame1 = firstScroll.frame
        let scaleWidth1 = scrollViewFrame1.size.width / firstScroll.contentSize.width
        let scaleHeight1 = scrollViewFrame1.size.height / firstScroll.contentSize.height
        let minScale1 = min(scaleHeight1, scaleWidth1)
        
        let scrollViewFrame = secondScroll.frame
        let scaleWidth = scrollViewFrame.size.width / secondScroll.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / secondScroll.contentSize.height
        let minScale = min(scaleHeight, scaleWidth)
        
        
        firstScroll.minimumZoomScale = minScale1
        firstScroll.maximumZoomScale = 1
        firstScroll.zoomScale = minScale1
        

        
        secondScroll.minimumZoomScale = minScale
        secondScroll.maximumZoomScale = 1
        secondScroll.zoomScale = minScale
        
        centerScrollViewContents1()
        centerScrollViewContents2()            //firstImage.image = firstPassed
            //secondImage.image = secondPassed
        // Do any additional setup after loading the view.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView.tag == 1 {
            firstScroll.delegate = self
            return firstImage
        }
        else{
            secondScroll.delegate = self
            return secondImage
        }
    }
    
    func centerScrollViewContents1(){
        
     
            let boundsSize = firstScroll.bounds.size
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
        

            let boundsSize = secondScroll.bounds.size
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0,y: 200), animated: true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
    }
    
    


    @IBAction func detectButton(_ sender: Any) {
            firstImage.image = OpenCVWrapper.makeGray(from: firstImage.image)
            //firstImage.transform = firstImage.transform.rotated(by: CGFloat(M_PI_2))
        secondImage.image = OpenCVWrapper.makeGray(from: secondImage.image)
            //secondImage.transform = secondImage.transform.rotated(by: CGFloat(M_PI_2))
        let test = OpenCVWrapper.results()
        print(test)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        if nameText?.text != "" && genderText?.text != "" {
            let newPerson = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context)
            newPerson.setValue(self.nameText!.text, forKey: "name")
            newPerson.setValue(self.ageText!.text, forKey: "age")
            newPerson.setValue(self.genderText!.text, forKey: "gender")
            newPerson.setValue(self.eyeText!.text, forKey: "eye")
            newPerson.setValue(self.notesText!.text, forKey: "notes")
            newPerson.setValue(self.firstImage.image, forKey: "firstImage")
            newPerson.setValue(self.secondImage.image, forKey: "secondImage")

            
            do {
                try context.save()
                
            }
            catch {
                print(error)
            }
        }
            
        else {
            print("please fill the first and second names")
        }
        
    }

        
}


