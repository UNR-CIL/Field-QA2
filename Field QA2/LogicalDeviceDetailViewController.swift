//
//  LogicalDeviceDetailViewController.swift
//  Field QA2
//
//  Created by John Jusayan on 9/16/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import UIKit

class LogicalDeviceDetailViewController: UIViewController {
    
    var detailLogicalDeviceItem : LogicalDevice? {
        didSet {
            // Set date properties here
            self.configureView()
        }
    }
    
    @IBOutlet weak var unitDescriptionTextField: UITextField!
    @IBOutlet weak var typeNameTextField: UITextField!
    @IBOutlet weak var purposeTextField: UITextField!
    @IBOutlet weak var installationLocationTextField: UITextField!
    @IBOutlet weak var installationDetailsTextView: UITextView!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var heightFromGroundTextField: UITextField!
    @IBOutlet weak var centerOffsetTextField: UITextField!
    @IBOutlet weak var dataIntervalTextField: UITextField!
    @IBOutlet weak var dataStreamDetails: UITextField!
    
    @IBOutlet weak var systemButton: UIButton!
    @IBOutlet weak var installationDateButton: UIButton!
    @IBOutlet weak var componentsButton: UIButton!
    
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
