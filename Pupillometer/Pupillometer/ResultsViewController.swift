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

class ResultsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    
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

            firstImage.image = firstPassed
            secondImage.image = secondPassed
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0,y: 240), animated: true)
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
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        if nameText?.text != "" && genderText?.text != "" {
            let newPerson = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context)
            newPerson.setValue(self.nameText!.text, forKey: "name")
            newPerson.setValue(self.ageText!.text, forKey: "age")
            newPerson.setValue(self.genderText!.text, forKey: "gender")
            newPerson.setValue(self.eyeText!.text, forKey: "eye")
            newPerson.setValue(self.notesText!.text, forKey: "notes")
            newPerson.setValue(self.firstImage!.image, forKey: "firstImage")
            newPerson.setValue(self.secondImage!.image, forKey: "secondImage")

            
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


