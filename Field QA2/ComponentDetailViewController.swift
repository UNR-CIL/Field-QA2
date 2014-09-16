//
//  ComponentDetailViewController.swift
//  Field QA2
//
//  Created by John Jusayan on 9/16/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import UIKit

class ComponentDetailViewController: UIViewController {

    var detailComponentItem : Component? {
        didSet {
            self.installationDate = detailComponentItem?.installationDate
            self.configureView()
        }
    }
    var datePopoverController : UIPopoverController?
    var systemsPopoverController : UIPopoverController?
    var serviceEntriesPopoverController : UIPopoverController?

    @IBOutlet weak var accuracyTextField: UITextField!

    @IBOutlet weak var manufacturerTextField:  UITextField!
    @IBOutlet weak var modelTextField:  UITextField!
    @IBOutlet weak var nameTextField:  UITextField!
    @IBOutlet weak var operatingRanageTextField: UITextField!
    @IBOutlet weak var serialNumberTextField: UITextField!
    @IBOutlet weak var typeNameTextField: UITextField!
    
    var installationDate: NSDate?
    var lastCalibrationDate: NSDate?
    
// var associatedLogicalDevice: NSManagedObject
// var logicalDevice: NSManagedObject
// weak var attachmentData: NSData
// weak var photo: AnyObject

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func configureView() {

    }
}
