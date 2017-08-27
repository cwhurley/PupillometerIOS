//
//  PersonPageViewController.swift
//  Pupillometer
//
//  Created by Chris Hurley on 20/8/17.
//  Copyright © 2017 Chris Hurley. All rights reserved.
//
//https://stackoverflow.com/questions/40887721/sending-an-email-from-swift-3
//https://stackoverflow.com/questions/34929932/round-up-double-to-2-decimal-places

import Foundation
import UIKit
import MessageUI

class PersonPageViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var eyeLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var notesLabel: UILabel!
    @IBOutlet var firstImage: UIImageView!
    @IBOutlet var secondImage: UIImageView!
    @IBOutlet weak var resultsLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var differenceLabel: UILabel!
    var personData: Person!
    var email = ""
    var subject = ""
    var first = ""
    var second = ""
    var diff = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        first = String(format: "%.2f", personData.firstResult)
        second = String(format: "%.2f", personData.secondResult)
        diff = String(format: "%.2f", personData.difference)
        
        nameLabel.text = personData.name
        genderLabel.text = personData.gender
        eyeLabel.text = personData.eye
        ageLabel.text = personData.age
        notesLabel.text = personData.notes
        resultsLabel.text = "First: " + first + "\nSecond: " + second
        differenceLabel.text = diff
        firstImage.image = personData.firstImage as! UIImage
        secondImage.image = personData.secondImage as! UIImage
        
        

        // Do any additional setup after loading the view.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x>0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    override var prefersStatusBarHidden: Bool  {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients([""])
        composeVC.setSubject("")
        composeVC.setMessageBody(
            "To \n \n Name: \(personData.name!) \n Age: \(personData.age!) \n Gender: \(personData.gender!) \n Eye: \(personData.eye!) \n First: \(first) \n Second: \(second) \n Difference: \(diff) \n Notes: \(personData.notes!)" ,
            isHTML: false)
        //let imageData: NSData = UIImagePNGRepresentation(firstImage.image!)! as NSData
        //composeVC.addAttachmentData(imageData as Data, mimeType: "image/png", fileName: firstImage)
        //let imageData: NSData = UIImagePNGRepresentation(firstImage.image!)! as NSData
       // email.addAttachmentData(imageData, mimeType: "image/png", fileName: firstImage)
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
        
        
        
        
//        let mailComposeViewController = configuredMailComposeViewController()
//        if MFMailComposeViewController.canSendMail() {
//            self.present(mailComposeViewController, animated: true, completion: nil)
//        let alertController = UIAlertController(title: "Send Email", message: "Send this persons data through email", preferredStyle: .alert)
        
//        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
//            alert -> Void in
//            
//            let emailTextField = alertController.textFields![0] as UITextField
//            let subjectTextField = alertController.textFields![1] as UITextField
//            
//            self.email = emailTextField.text!
//            self.subject = subjectTextField.text!
//            
//        })
        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
//            (action : UIAlertAction!) -> Void in
//            
//        })
//        
//        alertController.addTextField { (textField : UITextField!) -> Void in
//            textField.placeholder = "Recipients Email"
//        }
//        alertController.addTextField { (textField : UITextField!) -> Void in
//            textField.placeholder = "Subject Title"
//        }
//        
//        alertController.addAction(saveAction)
//        alertController.addAction(cancelAction)
        
//        self.present(alertController, animated: true, completion: nil)
//    
//        } else {
//            self.showSendMailErrorAlert()
//        }
//    }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
//    func configuredMailComposeViewController() -> MFMailComposeViewController {
//        let mailComposerVC = MFMailComposeViewController()
//        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
//        
//        mailComposerVC.setToRecipients([email])
//        mailComposerVC.setSubject(subject)
//        mailComposerVC.setMessageBody(personData.name!, isHTML: false)
//        
//        return mailComposerVC
//    }
    
//    func showSendMailErrorAlert() {
//        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
//        sendMailErrorAlert.show()
//    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
//    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
//        controller.dismiss(animated: true, completion: nil)
//        
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
