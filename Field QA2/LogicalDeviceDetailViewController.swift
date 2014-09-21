//
//  LogicalDeviceDetailViewController.swift
//  Field QA2
//
//  Created by John Jusayan on 9/16/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import UIKit

class LogicalDeviceDetailViewController: UIViewController, UIPopoverControllerDelegate {
    
    var detailLogicalDeviceItem : LogicalDevice? {
        didSet {
            self.installationDate = detailLogicalDeviceItem?.installationDate
            self.configureView()
        }
    }
    var installationDatePopoverController: UIPopoverController?
    var systemPopoverController: UIPopoverController?
    var serviceEntriesPopoverController: UIPopoverController?
    
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
    @IBOutlet weak var dataStreamDetailsTextField: UITextField!
    
    @IBOutlet weak var systemButton: UIButton!
    @IBOutlet weak var installationDateButton: UIButton!
    @IBOutlet weak var componentsButton: UIButton!
    
    
    
    var installationDate: NSDate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func installationDateButtonTapped(sender: AnyObject) {
        let datePickerStoryboard = UIStoryboard(name: "DatePicker", bundle: nil)
        let datePickerViewController = datePickerStoryboard.instantiateViewControllerWithIdentifier("DatePickerViewController") as DatePickerViewController
        self.installationDatePopoverController = UIPopoverController(contentViewController: datePickerViewController)
        
        self.installationDatePopoverController!.delegate = self
        self.installationDatePopoverController!.presentPopoverFromRect(installationDateButton.bounds, inView: installationDateButton, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
    }
    
    func popoverControllerShouldDismissPopover(popoverController: UIPopoverController) -> Bool {
        if popoverController == self.installationDatePopoverController {
            let datePickerViewController = popoverController.contentViewController as DatePickerViewController
            installationDate = datePickerViewController.datePicker.date
            self.updateInstallationDateButtonTitle()
        }
        else if popoverController == self.systemPopoverController {

        }
        return true
    }
    
    @IBAction func saveBarButtonTapped(sender: AnyObject) {
        if let unitDescription = self.unitDescriptionTextField.text {
            detailLogicalDeviceItem!.unitDescription = unitDescription
        }
        else {
            detailLogicalDeviceItem!.unitDescription = nil
        }
        if let typeName = self.typeNameTextField.text {
            detailLogicalDeviceItem!.typeName = typeName
        }
        else {
            detailLogicalDeviceItem!.typeName = nil
        }
        if let purpose = self.purposeTextField.text {
            detailLogicalDeviceItem!.purpose = purpose
        }
        else {
            detailLogicalDeviceItem!.purpose = nil
        }
        
        if let installationLocation = self.installationLocationTextField.text {
            detailLogicalDeviceItem!.installationLocation = installationLocation
        }
        else {
            detailLogicalDeviceItem!.installationLocation = nil
        }
        if let installationDetails = self.installationDetailsTextView.text {
            detailLogicalDeviceItem!.installationDetails = installationDetails
        }
        else {
            detailLogicalDeviceItem!.installationDetails = nil
        }
        
        let doubleNumberFormatter = NSNumberFormatter()
        doubleNumberFormatter.numberStyle = NSNumberFormatterStyle.NoStyle
        
        if let latitudeString = self.latitudeTextField.text {
            if let latitude = doubleNumberFormatter.numberFromString(latitudeString) {
                detailLogicalDeviceItem!.latitude = latitude
            }
            else {
                detailLogicalDeviceItem!.latitude = nil
            }
            
        }
        else {
            detailLogicalDeviceItem!.latitude = nil
        }
        
        if let longitudeString = self.longitudeTextField.text {
            if let longitude = doubleNumberFormatter.numberFromString(longitudeString) {
                detailLogicalDeviceItem!.longitude = longitude
            }
            else {
                detailLogicalDeviceItem!.longitude = nil
            }
            
        }
        else {
            detailLogicalDeviceItem!.longitude = nil
        }
        
        if let heightString = self.heightFromGroundTextField.text {
            if let height = doubleNumberFormatter.numberFromString(heightString) {
                detailLogicalDeviceItem!.heightFromGround = height
            }
            else {
                detailLogicalDeviceItem!.heightFromGround = nil
            }
        }
        else {
            detailLogicalDeviceItem!.heightFromGround = nil
        }
        if let centerOffsetString = self.centerOffsetTextField.text {
            if let centerOffset = doubleNumberFormatter.numberFromString(centerOffsetString) {
                detailLogicalDeviceItem!.centerOffset = centerOffset
            }
            else {
                detailLogicalDeviceItem!.centerOffset = nil
            }
        }
        else {
            detailLogicalDeviceItem!.centerOffset = nil
        }
        
        if let dataInterval = self.dataIntervalTextField.text {
            detailLogicalDeviceItem!.dataInterval = dataInterval
        }
        else {
            detailLogicalDeviceItem!.dataInterval = nil
        }
        if let dataStreamDetails = self.dataStreamDetailsTextField.text {
            detailLogicalDeviceItem!.dataStreamDetails = dataStreamDetails
        }
        else {
            detailLogicalDeviceItem!.dataStreamDetails = nil
        }
        
        var error : NSError?
        self.detailLogicalDeviceItem?.managedObjectContext.save(&error)
    }
    
    func configureView() {
        if let unitDescription = detailLogicalDeviceItem!.unitDescription {
            self.unitDescriptionTextField?.text = unitDescription
        }
        else {
            self.unitDescriptionTextField?.text = nil
        }
        if let typeName = detailLogicalDeviceItem!.typeName {
            self.typeNameTextField?.text = typeName
        }
        else {
            self.typeNameTextField?.text = nil
        }
        if let purpose = detailLogicalDeviceItem!.purpose {
            self.purposeTextField?.text = purpose
        }
        else {
            self.purposeTextField?.text = nil
        }
        
        if let installationLocation = detailLogicalDeviceItem!.installationLocation {
            unitDescriptionTextField?.text = installationLocation
        }
        else {
            unitDescriptionTextField?.text = nil
        }
        if let installationDetails = detailLogicalDeviceItem!.installationDetails {
            installationDetailsTextView?.text = installationDetails
        }
        else {
            installationDetailsTextView?.text = nil
        }
        
        let doubleNumberFormatter = NSNumberFormatter()
        doubleNumberFormatter.numberStyle = NSNumberFormatterStyle.NoStyle
        
        if let latitudeNumber = detailLogicalDeviceItem!.latitude {
            if let latitudeString = doubleNumberFormatter.stringFromNumber(latitudeNumber) {
                self.latitudeTextField?.text = latitudeString
            }
            else {
                self.latitudeTextField?.text = nil
            }
        }
        else {
            self.latitudeTextField?.text = nil
        }
        
        if let longitudeNumber = detailLogicalDeviceItem!.longitude {
            if let longitudeString = doubleNumberFormatter.stringFromNumber(longitudeNumber) {
                self.longitudeTextField?.text = longitudeString
            }
            else {
                self.longitudeTextField?.text = nil
            }
        }
        else {
            self.longitudeTextField?.text = nil
        }
        
        if let heightNumber = detailLogicalDeviceItem!.heightFromGround {
            if let heightString = doubleNumberFormatter.stringFromNumber(heightNumber) {
                self.heightFromGroundTextField?.text = heightString
            }
            else {
                self.heightFromGroundTextField?.text = nil
            }
        }
        else {
            self.heightFromGroundTextField?.text = nil
        }
        
        if let centerOffsetNumber = detailLogicalDeviceItem!.centerOffset {
            if let centerOffsetString = doubleNumberFormatter.stringFromNumber(centerOffsetNumber) {
                self.centerOffsetTextField?.text = centerOffsetString
            }
            else {
                self.centerOffsetTextField?.text = nil
            }
        }
        else {
            self.centerOffsetTextField?.text = nil
        }
        
        if let dataInterval = detailLogicalDeviceItem!.dataInterval {
            self.dataIntervalTextField?.text = dataInterval
        }
        else {
            self.dataIntervalTextField?.text = nil
        }
        if let dataStreamDetails = detailLogicalDeviceItem!.dataStreamDetails {
            self.dataStreamDetailsTextField?.text = dataStreamDetails
        }
        else {
            self.dataStreamDetailsTextField?.text = nil
        }
        
        self.updateInstallationDateButtonTitle()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateInstallationDateButtonTitle() {
        if let installationDate = self.installationDate {
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = .ShortStyle
            dateFormatter.dateStyle = .MediumStyle
            
            self.installationDateButton?.setTitle(dateFormatter.stringFromDate(installationDate), forState: .Normal)
            
        }
        else {
            self.installationDateButton?.setTitle("Installation Date", forState: .Normal)
        }
    }

}
