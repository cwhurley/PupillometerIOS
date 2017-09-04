//
//  HowToViewController.swift
//  Pupillometer
//
//  Created by Chris Hurley on 28/8/17.
//  Copyright © 2017 Chris Hurley. All rights reserved.
//

import UIKit

class HowToViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var expandTableView: UITableView!
    var selectedIndex = -1
    var dataArray : [[String:String]] =
        [
        ["Step" : "Step 1", "Title" : "Find the correct location", "Image" : "loading6sp.png"],
        ["Step" : "Step 2", "Title" : "Line up the eye", "Image" : "STEP_2.PNG"],
        ["Step" : "Step 3", "Title" : "Take a long blink", "Image" : "STEP_3.PNG"],
        ["Step" : "Step 4", "Title" : "Press start", "Image" : "STEP_4.PNG"],
        ["Step" : "Step 5", "Title" : "Check the image", "Image" : "STEP_5.PNG"],
        ["Step" : "Step 6", "Title" : "Press done if happy", "Image" : "STEP_6.PNG"],
        ["Step" : "Step 7", "Title" : "Enter patients information", "Image" : "STEP_7.PNG"],
        ["Step" : "Records", "Title" : "Records Table", "Image" : "STEP_8.PNG"],
        ["Step" : "Email", "Title" : "How to Email", "Image" : "STEP_9.PNG"],
        ["Step" : "Delete", "Title" : "Deleting a Record", "Image" : "STEP_10.PNG"]
        ]
    
    var summaryArray =
        [
        "Find a well-lit area. It's important that there is enough light in the room so that the camera can clearly see the difference between iris and pupil. However, you must also be careful as too much light can also cause strong reflections in darker eyes or light sources can be too prominent in the pupil. An example of this is shown under Step 5.",
        "Line up the circle on the camera view with the patient’s iris.",
        "As the patient will need to keep their eye open for 5 seconds, it's best they take a long blink until you say ready. Then ask that they keep their eye open wide until you say done.",
        "Press the start button and wait until the timer has run out and the next page has opened.",
        "Check the image for anything disrupting the clarity of the pupil. This could be anything from seeing too much of a reflection in the patient’s eye to a light disrupting the circle of the pupil as shown in the image below.",
        "If you are happy with the images, press done and continue to the results page. If not, then tap the reset button.",
        "The results page displays both images along with the results. The two numbers directly under the images are the diameters of the above image. The third number between the images is the difference between the diameters. Enter the patient’s information into the form if you wish to save the information to your phone.",
        "This table will show the list of saved patient information stored on your phone.",
        "There is an email function that once pressed will open the default email app on your IPhone. It will bring across all the patients information. You can then fill in the sections as necessary.",
        "By swiping across on someone’s name you will show the delete button. By taping this you will completely remove this information from your phone."
        ]
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        expandTableView.estimatedRowHeight = 40
        expandTableView.rowHeight = UITableViewAutomaticDimension
        self.expandTableView.backgroundColor = UIColor.clear
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! customCell
        cell.selectionStyle = .none
        let obj = dataArray[indexPath.row]
        cell.nameLabel.text = obj["Step"]
        cell.titleLabel.text = obj["Title"]
        let imageName = obj["Image"]
        let image = UIImage(named: imageName!)
        cell.imageOne.image = image
        cell.summaryLabel.text = summaryArray[indexPath.row]
        cell.summaryLabel.frame = self.cellSummaryLabelFrame(cell: cell, selectedIndexPath: indexPath)
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(selectedIndex == indexPath.row) {
            //return 100;
            return self.calculateHeight(selectedIndexPath: indexPath)
        } else {
            return 40;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(selectedIndex == indexPath.row) {
            selectedIndex = -1
        } else {
            selectedIndex = indexPath.row
        }
        self.expandTableView.beginUpdates()
        //self.expandTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic )
        self.expandTableView.endUpdates()
    }
    
    func calculateHeight(selectedIndexPath: IndexPath) -> CGFloat {
        let cell = self.expandTableView.cellForRow(at: selectedIndexPath) as! customCell
        cell.summaryLabel.frame = self.cellSummaryLabelFrame(cell: cell, selectedIndexPath: selectedIndexPath)
        return 40 + 10 + cell.summaryLabel.frame.size.height + 10 + cell.imageOne.frame.size.height + 80
    }
    
    func cellSummaryLabelFrame(cell: customCell, selectedIndexPath: IndexPath) -> CGRect {
        cell.summaryLabel.text = summaryArray[selectedIndexPath.row]
        cell.summaryLabel.numberOfLines = 0
        var labelFrame = cell.summaryLabel.frame
        let maxSize = CGSize.init(width: cell.summaryLabel.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
        let requiredSize = cell.summaryLabel.sizeThatFits(maxSize)
        labelFrame.size.height = requiredSize.height
        return labelFrame
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
}
