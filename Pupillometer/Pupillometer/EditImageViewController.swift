//
//  EditImageViewController.swift
//  Pupillometer
//
//  Created by Chris Hurley on 30/7/17.
//  Copyright © 2017 Chris Hurley. All rights reserved.
//

import UIKit

class EditImageViewController: UIViewController {
    
    
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    
    var firstPassed = UIImage()
    var secondPassed = UIImage()
    

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
    


}
