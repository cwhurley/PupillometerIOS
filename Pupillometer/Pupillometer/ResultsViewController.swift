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

class ResultsViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UIPickerViewDataSource,UIPickerViewDelegate {
    
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
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var genderText: UITextField!
    @IBOutlet weak var eyeText: UITextField!
    @IBOutlet var notesText: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var firstResultLabel: UILabel!
    @IBOutlet weak var secondResultLabel: UILabel!
    @IBOutlet weak var differenceLabel: UILabel!
    @IBOutlet weak var manuelButton: UIButton!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let GenderOption = ["Male", "Female", "Other"]
    
    let AgeOption = ["1", "2", "3", "4", "5", "6", "7", "8", "9","10", "11", "12", "13", "14", "15", "16", "17", "18","19", "20", "21", "22", "23", "24", "25", "26", "27","28", "29", "30", "31", "32", "33", "34", "35", "36","37", "38", "39", "40", "41", "42", "43", "44", "45","46", "47", "48", "49", "50", "51", "52", "53", "54","55", "56", "57", "58", "59", "60", "61", "62", "63","64", "65", "66", "67", "68", "69", "70", "71", "72","73", "74", "75", "76", "77", "78", "79", "80", "81","82", "83", "84", "85", "86", "87", "88", "89", "90","91", "92", "93", "94", "95", "96", "97", "98", "99","100"]
    
    let EyeOption = ["Left", "Right"]
  
    override func viewDidLoad() {
        super.viewDidLoad()

        let GenderPickerView = UIPickerView()
        GenderPickerView.delegate = self
        GenderPickerView.tag = 1
        genderText.inputView = GenderPickerView
        
        let AgePickerView = UIPickerView()
        AgePickerView.delegate = self
        AgePickerView.tag = 2
        ageText.inputView = AgePickerView
        
        let EyePickerView = UIPickerView()
        EyePickerView.delegate = self
        EyePickerView.tag = 3
        eyeText.inputView = EyePickerView
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.white
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(ResultsViewController.donePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.font = UIFont(name: "Helvetica", size: 12)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([flexSpace,textBtn,flexSpace,doneButton], animated: true)
        ageText.inputAccessoryView = toolBar
        genderText.inputAccessoryView = toolBar
        eyeText.inputAccessoryView = toolBar

        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        result = formatter.string(from: date)
        pageNumber = fromPage
        let test = stringPassed
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
        
        let firstXCenter = firstPassed.size.width / 2
        let firstYCenter = firstPassed.size.height / 2
        let secondXCenter = secondPassed.size.width / 2
        let secondYCenter = secondPassed.size.height / 2
        
        firstScroll.contentOffset = CGPoint(x: firstXCenter / 2, y: firstYCenter / 2)
        secondScroll.contentOffset = CGPoint(x: secondXCenter / 2, y: secondYCenter / 2)
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
                firstResult = firstResult * 0.2645833333333
            secondImage.image = OpenCVWrapper.makeGray(from: secondImage.image)
            secondResult = OpenCVWrapper.secondResult()
                secondResult = secondResult * 0.2645833333333
            difference = firstResult - secondResult
                
            
            firstResultLabel.text = String(format: "%.2f mm", firstResult)
            secondResultLabel.text = String(format: "%.2f mm", secondResult)
            differenceLabel.text = String(format: "%.2f mm", difference)
            
                
            }
            else if (pageNumber == 2)
            {
                print("this means that the page thing is working")
            manuelButton.isHidden = true
            firstImage.image = firstPassed
            secondImage.image = secondPassed
            firstResultsPassed = firstResultsPassed * 0.2645833333333
            secondResultsPassed = secondResultsPassed * 0.2645833333333
            
            firstResultLabel.text = String(format: "%.2f mm", firstResultsPassed)
            secondResultLabel.text = String(format: "%.2f mm", secondResultsPassed)
            difference = firstResultsPassed - secondResultsPassed
            differenceLabel.text = String(format: "%.2f mm", difference)
            }
        }
        else
        {
            firstResult = firstResult * 0.2645833333333
            secondResult = secondResult * 0.2645833333333
            manuelButton.isHidden = true
            firstImage.image = firstPassed
            secondImage.image = secondPassed
            firstResultLabel.text = String(format: "%.2f mm", firstResult)
            secondResultLabel.text = String(format: "%.2f mm", secondResult)
            difference = firstResult - secondResult
            differenceLabel.text = String(format: "%.2f mm", difference)
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
    
    // picker view settings
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 1 {
            return GenderOption.count
        }
        if pickerView.tag == 2 {
            return AgeOption.count
        }
        if pickerView.tag == 3 {
            return EyeOption.count
        }
    
        return 0
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 1 {
            return GenderOption[row]
        }
        if pickerView.tag == 2 {
            return AgeOption[row]
        }
        if pickerView.tag == 3 {
            return EyeOption[row]
        }
        
        return nil
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 1 {
            genderText.text = GenderOption[row]
        }
        if pickerView.tag == 2 {
            ageText.text = AgeOption[row]
        }
        if pickerView.tag == 3 {
            eyeText.text = EyeOption[row]
        }
    }

    
    
    func donePressed(_ sender: UIBarButtonItem) {
            genderText.resignFirstResponder()
            ageText.resignFirstResponder()
            eyeText.resignFirstResponder()
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
            sliderViewController.stringPassed = stringPassed
            
        }
        
    }
    
    // Checks for errors in the detection
    override func viewDidAppear(_ animated: Bool) {
        if (pageNumber == 1 && (firstResult == 0.0 || secondResult == 0.0))
        {
            let resultAlertController = UIAlertController(title: "Error", message: "Nothing was detected in one of the images. Please try the paramater adjuster or try again using the manual option.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            resultAlertController.addAction(defaultAction)
            
            present(resultAlertController, animated: true, completion: nil)
        }
        else if (pageNumber == 2 && (firstResultsPassed == 0.0 || secondResultsPassed == 0.0)){
            
            let resultAlertController = UIAlertController(title: "Error", message: "Nothing was detected in one of the images. Please try again using the manual option.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            resultAlertController.addAction(defaultAction)
            
            present(resultAlertController, animated: true, completion: nil)
        }
        
    }
        
}

