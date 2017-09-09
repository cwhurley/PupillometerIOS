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
    
    // Variables
    var firstImageDefault = UIImageView()
    var secondimageDefault = UIImageView()
    var firstImage = UIImageView()
    var secondImage = UIImageView()
    var firstResult = 0.0
    var secondResult = 0.0
    var difference = 0.0
    var result = ""
    var stringPassed = String()
    var firstPassed = UIImage()
    var secondPassed = UIImage()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var firstResultsPassed = 0.0
    var secondResultsPassed = 0.0
    var fromPage = Int()
    var pageNumber = Int()

    // Outlets
    @IBOutlet weak var firstScroll: UIScrollView!
    @IBOutlet weak var secondScroll: UIScrollView!
    @IBOutlet var nameText: UITextField!
    @IBOutlet var ageText: UITextField!
    @IBOutlet var genderText: UITextField!
    @IBOutlet var eyeText: UITextField!
    @IBOutlet var notesText: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var firstResultLabel: UILabel!
    @IBOutlet weak var secondResultLabel: UILabel!
    @IBOutlet weak var differenceLabel: UILabel!
    @IBOutlet weak var manuelButton: UIButton!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        result = formatter.string(from: date)
        pageNumber = fromPage
        print(pageNumber)
        detectPupil()
        
        firstScroll.tag = 1
        secondScroll.tag = 2
        
        firstImage.frame = CGRect(x: 0, y: 0, width: firstScroll.frame.size.width, height: firstScroll.frame.size.height)
        secondImage.frame = CGRect(x: 0, y: 0, width: secondScroll.frame.size.width, height: secondScroll.frame.size.height)
        
        firstScroll.addSubview(firstImage)
        secondScroll.addSubview(secondImage)
        
        firstImage.contentMode = UIViewContentMode.center
        secondImage.contentMode = UIViewContentMode.center
        
        firstImage.frame = CGRect(x: 0, y: 0, width: firstPassed.size.width, height: firstPassed.size.height)
        firstScroll.contentSize = firstPassed.size
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
        centerScrollViewContents2()
        }
    
    // Function for handling the scroll view zoom
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView.tag == 1
        {
            firstScroll.delegate = self
            return firstImage
        }
        else
        {
            secondScroll.delegate = self
            return secondImage
        }
    }
    
    // Handles the centering of scrolled image
    func centerScrollViewContents1(){
            let boundsSize = firstScroll.bounds.size
            var contentsFrame = firstImage.frame
            
            if contentsFrame.size.width < boundsSize.width
            {
                contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2
            }
            else
            {
                contentsFrame.origin.x = 0
            }
            
            if contentsFrame.size.height < boundsSize.height
            {
                contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2
            }
            else
            {
                contentsFrame.origin.y = 0
            }
            
            firstImage.frame = contentsFrame
    }
    
    // Handles the centering of scrolled image
    func centerScrollViewContents2(){
            let boundsSize = secondScroll.bounds.size
            var contentsFrame = secondImage.frame
            
            if contentsFrame.size.width < boundsSize.width
            {
                contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2
            }
            else
            {
                contentsFrame.origin.x = 0
            }
            
            if contentsFrame.size.height < boundsSize.height
            {
                contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2
            }
            else
            {
                contentsFrame.origin.y = 0
            }
            
            secondImage.frame = contentsFrame
    }

    // Handles the scrolling of the scroll views
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
      
            centerScrollViewContents1()
     
            centerScrollViewContents2()
        
    }
    
    // Calls on the opencv detection function and adjusts all labels and variables
    func detectPupil() {
        if (stringPassed == "auto")
        {
            if (pageNumber == 1)
            {
            firstImageDefault.image = firstPassed
            secondimageDefault.image = secondPassed
            
            firstImage.image = firstPassed
            secondImage.image = secondPassed
            firstImage.image = OpenCVWrapper.makeGray(from: firstImage.image)
            firstResult = OpenCVWrapper.firstResult()
            secondImage.image = OpenCVWrapper.makeGray(from: secondImage.image)
            secondResult = OpenCVWrapper.secondResult()
            difference = firstResult - secondResult
            
            firstResultLabel.text = String(format: "%.2f", firstResult)
            secondResultLabel.text = String(format: "%.2f", secondResult)
            differenceLabel.text = String(format: "%.2f", difference)
                
            }
            else
            {
            manuelButton.isHidden = true
            firstImage.image = firstPassed
            secondImage.image = secondPassed
            
            firstResultLabel.text = String(format: "%.2f", firstResultsPassed)
            secondResultLabel.text = String(format: "%.2f", secondResultsPassed)
            difference = firstResultsPassed - secondResultsPassed
            differenceLabel.text = String(format: "%.2f", difference)
            }
        }
        else
        {
            manuelButton.isHidden = true
            firstImage.image = firstPassed
            secondImage.image = secondPassed
            firstResultLabel.text = String(format: "%.2f", firstResult)
            secondResultLabel.text = String(format: "%.2f", secondResult)
            difference = firstResult - secondResult
            differenceLabel.text = String(format: "%.2f", difference)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Adjusts the form view if editing has started
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0,y: 200), animated: true)
    }
    
    // Adjusts the form is ediding has stopped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    // Adjusts the form is ediding has stopped
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
    }
    
    // Checks for correct data and saves it if the form has all been filled in
    @IBAction func saveButton(_ sender: Any) {
        
        if nameText?.text != "" && genderText?.text != "" && ageText.text != "" && eyeText.text != "" && notesText.text != ""
        {
            let newPerson = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context)
            newPerson.setValue(self.nameText!.text, forKey: "name")
            newPerson.setValue(self.ageText!.text, forKey: "age")
            newPerson.setValue(self.genderText!.text, forKey: "gender")
            newPerson.setValue(self.eyeText!.text, forKey: "eye")
            newPerson.setValue(self.notesText!.text, forKey: "notes")
            if pageNumber == 1
            {
                newPerson.setValue(self.firstResult, forKey: "firstResult")
                newPerson.setValue(self.secondResult, forKey: "secondResult")
                newPerson.setValue(self.difference, forKey: "difference")
            }
            else
            {
                newPerson.setValue(self.firstResultsPassed, forKey: "firstResult")
                newPerson.setValue(self.secondResultsPassed, forKey: "secondResult")
                newPerson.setValue(self.difference, forKey: "difference")
            }
            newPerson.setValue(self.firstImage.image, forKey: "firstImage")
            newPerson.setValue(self.secondImage.image, forKey: "secondImage")
            newPerson.setValue(self.result, forKey: "date")
            
            do {
                try context.save()
            }
            catch {
                print(error)
            }
            self.performSegue(withIdentifier: "save", sender: self)
        }
        else
        {
            let alertController = UIAlertController(title: "Error", message: "Please fill out all sections.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }

    // Deals with sending the data to the manual page
    @IBAction func manuelButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "manuel", sender: self)
    }
    
    // Sends data to the correct page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "manuel")
        {
            let sliderViewController = segue.destination as! sliderViewController
            sliderViewController.firstPassed = firstImageDefault.image!
            sliderViewController.secondPassed = secondimageDefault.image!
            
        }
        
    }
    
    // Checks for errors in the detection
    override func viewDidAppear(_ animated: Bool) {
        if (firstResult == 0.0 || secondResult == 0.0)
        {
            let resultAlertController = UIAlertController(title: "Error", message: "Nothing was detected in one of the images. Please try the paramater adjuster or try again using the manual option.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            resultAlertController.addAction(defaultAction)
            
            present(resultAlertController, animated: true, completion: nil)
        }    }
        
}


