//
//  SystemsDetailViewController.swift
//  Field QA2
//
//  Created by John Jusayan on 8/18/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import UIKit

class SystemDetailViewController: UIViewController, UIPopoverControllerDelegate {

    var detailSystemItem : System? {
        didSet {
            self.installationDate = detailSystemItem?.installationDate
            self.configureView()
        }
    }
    var datePopoverController : UIPopoverController?
    var componentsPopoverController : UIPopoverController?
    
    @IBOutlet weak var installationDateButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    
    var installationDate : NSDate?
    
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
        self.datePopoverController = UIPopoverController(contentViewController: datePickerViewController)
        
        self.datePopoverController!.delegate = self
        self.datePopoverController!.presentPopoverFromRect(installationDateButton.bounds, inView: installationDateButton, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
    }

    func popoverControllerShouldDismissPopover(popoverController: UIPopoverController) -> Bool {
        if popoverController == self.datePopoverController {
            let datePickerViewController = popoverController.contentViewController as DatePickerViewController
            installationDate = datePickerViewController.datePicker.date
            self.updateInstallationDateButtonTitle()
        }
        else if popoverController == self.componentsPopoverController {
            
        }
        return true
    }
    
    @IBAction func saveBarButtonTapped(sender: AnyObject) {
        if let name = self.nameTextField.text {
            detailSystemItem!.name = name
        }
        else {
            detailSystemItem!.name = nil
        }
        if let notes = self.notesTextView.text {
            detailSystemItem!.details = notes
        }
        else {
            detailSystemItem!.details = nil
        }
        if let locationDescription = self.locationTextField.text {
            detailSystemItem!.installationLocation = locationDescription
        }
        else {
            detailSystemItem!.installationLocation = nil
        }
        
        let doubleNumberFormatter = NSNumberFormatter()
        doubleNumberFormatter.numberStyle = NSNumberFormatterStyle.NoStyle
        
        if let latitudeString = self.latitudeTextField.text {
            if let latitude = doubleNumberFormatter.numberFromString(latitudeString) {
                detailSystemItem!.latitude = latitude
            }
            else {
                detailSystemItem!.latitude = nil
            }

        }
        else {
            detailSystemItem!.latitude = nil
        }
        
        if let longitudeString = self.longitudeTextField.text {
            if let longitude = doubleNumberFormatter.numberFromString(longitudeString) {
                detailSystemItem!.longitude = longitude
            }
            else {
                detailSystemItem!.longitude = nil
            }
            
        }
        else {
            detailSystemItem!.longitude = nil
        }
        
        if let installationDate = self.installationDate {
            detailSystemItem!.installationDate = installationDate
        }
        else {
            detailSystemItem!.installationDate = nil
        }
        
        var error : NSError?
        self.detailSystemItem?.managedObjectContext!.save(&error)
    }
    
    func configureView() {
        if let name = detailSystemItem!.name {
            self.nameTextField?.text = name
        }
        else {
            self.nameTextField?.text = nil
        }
        if let notes = detailSystemItem!.details {
            self.notesTextView?.text = notes
        }
        else {
            self.notesTextView?.text = nil
        }
        if let locationDescription =  detailSystemItem!.installationLocation {
            self.locationTextField?.text = locationDescription
        }
        else {
            self.locationTextField?.text = nil
        }
        
        let doubleNumberFormatter = NSNumberFormatter()
        doubleNumberFormatter.numberStyle = NSNumberFormatterStyle.NoStyle
        
        if let latitudeNumber = detailSystemItem!.latitude {
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
        
        if let longitudeNumber = detailSystemItem!.longitude {
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
        
        self.updateInstallationDateButtonTitle()
    }
    
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "ComponentsViewControllerPopover") {
            if let componentsViewController = segue.destinationViewController as? ComponentsViewController {
                let predicate = NSPredicate(format: "system == %@", self.detailSystemItem!)
                componentsViewController.componentsPredicate = predicate
            }
        }
    }
}
