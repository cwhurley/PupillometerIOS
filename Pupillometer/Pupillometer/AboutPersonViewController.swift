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
            aboutTextField.text = "Hi, I'm Arpa. I'm from Bangladesh. I'm studying Bachelor of Information Technology majoring in Application Development. Apart from applications, I'm also passionate about Web Development. I'm also an avid Salsa Dancer."
            roleLabel.text = "Swift Programmer"
        case "Chris":
            nameLabel.text = "Chris Hurley"
            imageView.image = UIImage(named: "chris")
            aboutTextField.text = "I'm currently studing a Bachelor of Information Technology majoring in App Development. I enjoy developing apps with both native studios such as xCode, Android Studio and cross platform apps using the Ionic framework. I also have experience in web development."
            roleLabel.text = "Swift and OpenCV Programmer"
        case "Cameron":
            nameLabel.text = "Cameron Grey- \n Caminiti"
            imageView.image = UIImage(named: "cameron.jpeg")
            aboutTextField.text = "Hey, I'm Cameron, I was born and raised in australia. I'm currently studying a bachelor of IT, majoring in mobile and apps development. Aside from programming, I enjoy having a good chat and I'm always keen to have a good laugh."
            roleLabel.text = "OpenCV Programmer"
        case "Qiuchi":
            nameLabel.text = "Qiuchi Chen"
            imageView.image = UIImage(named: "josh")
            aboutTextField.text = "I am Qiuchi Chen, I am an international student from China. I am studing bachelor of Information Technology majoring in App Development. I am good at design App front end and User interface. I have the skills to woking on Xcode, Android studio. I can do web developing as well."
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
