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
    
    // Variables
    var passedName = String()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch passedName {
        case "Arpa":
            nameLabel.text = "Arpa"
            imageView.image = UIImage(named: "Arpa")
        case "Chris":
            nameLabel.text = "Chris Hurley"
            imageView.image = UIImage(named: "chris")

        case "Cameron":
            nameLabel.text = "Cameron"
        case "Qiuchi":
            nameLabel.text = "Qiuchi"
            imageView.image = UIImage(named: "josh")

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
