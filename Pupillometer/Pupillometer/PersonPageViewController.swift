//
//  PersonPageViewController.swift
//  Pupillometer
//
//  Created by Chris Hurley on 20/8/17.
//  Copyright © 2017 Chris Hurley. All rights reserved.
//

import UIKit

class PersonPageViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var eyeLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var notesLabel: UILabel!
    @IBOutlet var firstImage: UIImageView!
    @IBOutlet var secondImage: UIImageView!
    
    var personData: Person!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = personData.name
        genderLabel.text = personData.gender
        eyeLabel.text = personData.eye
        ageLabel.text = personData.age
        notesLabel.text = personData.notes
        firstImage.image = personData.firstImage as! UIImage
        secondImage.image = personData.secondImage as! UIImage
        
        

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

}
