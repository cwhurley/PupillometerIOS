//
//  ImportViewController.swift
//  Pupillometer
//
//  Created by Chris Hurley on 13/8/17.
//  Copyright © 2017 Chris Hurley. All rights reserved.
//

import UIKit

class ImportViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var firstImage: UIImageView!
    
    @IBOutlet weak var secondImage: UIImageView!
    
    var imageNumber = 0
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func importOne(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imageNumber = 1
        self.present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if (imageNumber == 1){
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage { // stores the image in the pickedImage constant and add it to the UIImageView
            firstImage.contentMode = .scaleAspectFit
            firstImage.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
        }
        else
        {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage { // stores the image in the pickedImage constant and add it to the UIImageView
                secondImage.contentMode = .scaleAspectFit
                secondImage.image = pickedImage
            }
            picker.dismiss(animated: true, completion: nil)
            
        }
        
    }

    @IBAction func importTwo(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imageNumber = 2
        self.present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func doneButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "imports", sender: self)    }
    
    // Send both images to the EditImageViewController page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "imports")
        {
        let FirstCropViewController = segue.destination as! FirstCropViewController
        FirstCropViewController.firstPassed = firstImage.image!
        FirstCropViewController.secondPassed = secondImage.image!
        }
    }

}
