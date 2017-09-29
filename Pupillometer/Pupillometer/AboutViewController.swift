//
//  AboutViewController.swift
//  Pupillometer
//
//  Created by Chris Hurley on 8/9/17.
//  Copyright © 2017 Chris Hurley. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    // Variables
    var passingName = String()
    
    // Outlets

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Opens about page with selected persons information
    @IBAction func arpaButton(_ sender: UIButton) {
        passingName = "Arpa"
        self.performSegue(withIdentifier: "person", sender: self)
    }
    
    // Opens about page with selected persons information
    @IBAction func chrisButton(_ sender: UIButton) {
        passingName = "Chris"
        self.performSegue(withIdentifier: "person", sender: self)
    }
    
    // Opens about page with selected persons information
    @IBAction func cameronButton(_ sender: UIButton) {
        passingName = "Cameron"
        self.performSegue(withIdentifier: "person", sender: self)
    }
    
    // Opens about page with selected persons information
    @IBAction func qiuchiButton(_ sender: UIButton) {
        passingName = "Qiuchi"
        self.performSegue(withIdentifier: "person", sender: self)
    }
    
    // Handles sending the name to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "person")
        {
        let AboutPersonViewController = segue.destination as! AboutPersonViewController
        AboutPersonViewController.passedName = passingName
        }

    }

}
