//
//  ResultsViewController.swift
//  Pupillometer
//
//  Created by Chris Hurley on 8/8/17.
//  Copyright © 2017 Chris Hurley. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func detectButton(_ sender: Any) {
            firstImage.image = OpenCVWrapper.makeGray(from: firstImage.image)
            //firstImage.transform = firstImage.transform.rotated(by: CGFloat(M_PI_2))
        secondImage.image = OpenCVWrapper.makeGray(from: secondImage.image)
            //secondImage.transform = secondImage.transform.rotated(by: CGFloat(M_PI_2))
    }

}
