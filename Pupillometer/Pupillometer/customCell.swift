//
//  customCellViewController.swift
//  Pupillometer
//
//  Created by Chris Hurley on 28/8/17.
//  Copyright © 2017 Chris Hurley. All rights reserved.
//

import UIKit

class customCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var heightConstraintSecondView: NSLayoutConstraint!
    @IBOutlet weak var summaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
    }
    
    var showsDetails = false {
        didSet {
            heightConstraintSecondView.priority = showsDetails ? 250 : 999
        }
    }
    
}
