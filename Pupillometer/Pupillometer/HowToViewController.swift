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
        ["Step" : "Step 1", "Title" : "Find the correct location"],
        ["Step" : "Step 2", "Title" : "Line up the eye"],
        ["Step" : "Step 3", "Title" : "Take a long blink"],
        ["Step" : "Step 4", "Title" : "Press start"],
        ["Step" : "Step 5", "Title" : "Check the image"],
        ["Step" : "Step 6", "Title" : "Press done if happy"],
        ["Step" : "Step 7", "Title" : "Enter persons information"]
        ]
    
    var summaryArray = ["Find a well lit area. ",
                        "Line up the circle on the camera view with the persons iris.",
                        "As the patient will need to keep their eye open for 5 seconds, it's best they take a long blink until you say ready. Then ask that they keep their eye open wide until you say done.",
                        "Press the start button and wait until the timer has run out and the next page has opened.",
                        "Check the image for anything distrupting the clarity of the pupil.",
                        "If you are happy with the images, press done and continue to the results page. If not, then tap the reset button.",
                        "Enter the patients information into the form if you wish to save the information to your phone."
                        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        expandTableView.estimatedRowHeight = 40
        expandTableView.rowHeight = UITableViewAutomaticDimension
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
        cell.matchName.text = obj["Step"]
        cell.score.text = obj["Title"]
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
        return 40 + 35 + 21 + 10 + cell.summaryLabel.frame.size.height + 10
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
    
    
}
