//
//  SegmentedControlCell.swift
//  Field QA2
//
//  Created by John Jusayan on 7/11/15.
//  Copyright © 2015 University of Nevada, Reno. All rights reserved.
//

import UIKit

class SegmentedControlCell: UITableViewCell {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func selectedValueChanged(sender: UISegmentedControl) {

        NSNotificationCenter.defaultCenter().postNotificationName("SegmentedValueChanged", object: nil, userInfo: ["segmentedControl": sender])
            
            
            //.postNotificationName("SegmentedValueChanged", object: nil)
    }
}
