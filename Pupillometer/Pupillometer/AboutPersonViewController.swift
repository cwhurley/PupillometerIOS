//
//  AboutPersonViewController.swift
//  Pupillometer
//
//  Created by Chris Hurley on 8/9/17.
//  Copyright © 2017 Chris Hurley. All rights reserved.
//

import UIKit

class AboutPersonViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutTextField: UITextView!
    @IBOutlet weak var roleLabel: UILabel!
    
    // Variables
    var passedName = String()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch passedName {
        case "Arpa":
            nameLabel.text = "Arpa Barua Sumi"
            imageView.image = UIImage(named: "Arpa")
            aboutTextField.text = ""
            roleLabel.text = "Swift Programmer"
        case "Chris":
            nameLabel.text = "Chris Hurley"
            imageView.image = UIImage(named: "chris")
            aboutTextField.text = ""
            roleLabel.text = "Swift and OpenCV Programmer"
        case "Cameron":
            nameLabel.text = "Cameron Grey- \n Caminiti"
            aboutTextField.text = ""
            roleLabel.text = "OpenCV Programmer"
        case "Qiuchi":
            nameLabel.text = "Qiuchi Chen"
            imageView.image = UIImage(named: "josh")
            aboutTextField.text = ""
            roleLabel.text = "UI Designer"
        default:
            break
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
