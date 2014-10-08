//
//  ComponentDetailViewController.swift
//  Field QA2
//
//  Created by John Jusayan on 9/16/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import UIKit

class ComponentDetailViewController: UIViewController, UIPopoverControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var detailComponentItem : Component? {
        didSet {
            self.installationDate = detailComponentItem?.installationDate
            self.configureView()
        }
    }
    
    var installationDatePopoverController: UIPopoverController?
    var lastCallibrationDatePopoverController: UIPopoverController?
    var logicalDevicePopoverController: UIPopoverController?
    var serviceEntriesPopoverController: UIPopoverController?
    var cameraPopoverController: UIPopoverController?

    var image: UIImage?
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!

    @IBOutlet weak var modelTextField:  UITextField!
    @IBOutlet weak var manufacturerTextField:  UITextField!
    
    @IBOutlet weak var serialNumberTextField: UITextField!
    @IBOutlet weak var typeNameTextField: UITextField!
    
    @IBOutlet weak var accuracyTextField: UITextField!
    @IBOutlet weak var operatingRangeTextField: UITextField!

    @IBOutlet weak var installationDateButton: UIButton!
    @IBOutlet weak var calibrationDateButton: UIButton!
    
    
    @IBOutlet weak var logicalDeviceButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var installationDate: NSDate?
    var lastCalibrationDate: NSDate?
    var associatedLogicalDevice: LogicalDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillChangeFrameNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            let viewHeight = self.view.bounds.size.height
            let userInfo = notification.userInfo as NSDictionary!
            let keyboardValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as NSValue
            let keyboardRect = keyboardValue.CGRectValue()
            let keyboardHeight = keyboardRect.size.height
            
            self.bottomConstraint.constant =  keyboardHeight
        }
        
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
    
    @IBAction func calibrationDateButtonTapped(sender: AnyObject) {
        let datePickerStoryboard = UIStoryboard(name: "DatePicker", bundle: nil)
        let datePickerViewController = datePickerStoryboard.instantiateViewControllerWithIdentifier("DatePickerViewController") as DatePickerViewController
        self.lastCallibrationDatePopoverController = UIPopoverController(contentViewController: datePickerViewController)
        
        self.lastCallibrationDatePopoverController!.delegate = self
        self.lastCallibrationDatePopoverController!.presentPopoverFromRect(installationDateButton.bounds, inView: calibrationDateButton, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
    }
    
    @IBAction func logicalDeviceButtonTapped(sender: AnyObject) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let systemsViewController = mainStoryboard.instantiateViewControllerWithIdentifier("AssociatedLogicalDeviceViewController") as LogicalDevicesViewController
        self.logicalDevicePopoverController = UIPopoverController(contentViewController: systemsViewController)
        
        self.logicalDevicePopoverController!.delegate = self
        self.logicalDevicePopoverController!.presentPopoverFromRect(logicalDeviceButton.bounds, inView: logicalDeviceButton, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
    }
    
    func popoverControllerShouldDismissPopover(popoverController: UIPopoverController) -> Bool {
        if popoverController == self.installationDatePopoverController {
            let datePickerViewController = popoverController.contentViewController as DatePickerViewController
            installationDate = datePickerViewController.datePicker.date
            self.updateInstallationDateButtonTitle()
        }
        else if popoverController == self.lastCallibrationDatePopoverController {
            let datePickerViewController = popoverController.contentViewController as DatePickerViewController
            lastCalibrationDate = datePickerViewController.datePicker.date
            self.updateLastCalibrationDateButtonTitle()
        }
        else if popoverController == self.logicalDevicePopoverController {
            let logicalDevicesViewController = popoverController.contentViewController as LogicalDevicesViewController
            associatedLogicalDevice = logicalDevicesViewController.currentlySelectedLogicalDevice
        }
        return true
    }
    
    @IBAction func saveBarButtonTapped(sender: AnyObject) {
        if let name = self.nameTextField.text {
            detailComponentItem!.name = name
        }
        else {
            detailComponentItem!.name = nil
        }
        if let notes = self.notesTextView.text {
            detailComponentItem!.details = notes
        }
        else {
            detailComponentItem!.details = nil
        }
        
        if let model = self.modelTextField.text {
            detailComponentItem!.model = model
        }
        else {
            detailComponentItem!.model = nil
        }
        if let manufacturer = self.manufacturerTextField.text {
            detailComponentItem!.manufacturer = manufacturer
        }
        else {
            detailComponentItem!.manufacturer = nil
        }
        
        if let serialNumber = self.serialNumberTextField.text {
            detailComponentItem!.serialNumber = serialNumber
        }
        else {
            detailComponentItem!.serialNumber = nil
        }
        if let typeName = self.typeNameTextField.text {
            detailComponentItem!.typeName = typeName
        }
        else {
            detailComponentItem!.typeName = nil
        }
        
        if let accuracy = self.accuracyTextField.text {
            detailComponentItem!.accuracy = accuracy
        }
        else {
            detailComponentItem!.accuracy = nil
        }
        if let operatingRange = self.operatingRangeTextField.text {
            detailComponentItem!.operatingRange = operatingRange
        }
        else {
            detailComponentItem!.operatingRange = nil
        }
        
        if let logicalDevice = self.associatedLogicalDevice {
            detailComponentItem!.logicalDevice = logicalDevice
        }
        
        var error : NSError?
        self.detailComponentItem?.managedObjectContext!.save(&error)
    }

    
    func configureView() {
        if let name = detailComponentItem!.name {
            self.nameTextField?.text = name
        }
        else {
            self.nameTextField?.text = nil
        }
        if let image = detailComponentItem!.photo {
            self.imageView?.image = image as UIImage
        }
        else {
            self.imageView?.image = nil
        }
        
        if let notes = detailComponentItem!.details {
            self.notesTextView?.text = notes
        }
        else {
            self.notesTextView?.text = nil
        }
        
        if let model =  detailComponentItem!.model {
            self.modelTextField?.text = model
        }
        else {
            self.modelTextField?.text = nil
        }
        if let manufacturer =  detailComponentItem!.manufacturer {
            self.manufacturerTextField?.text = manufacturer
        }
        else {
            self.manufacturerTextField?.text = nil
        }
        
        if let serialNumber = detailComponentItem!.model {
            self.serialNumberTextField?.text = serialNumber
        }
        else {
            self.serialNumberTextField?.text = nil
        }
        if let typeName = detailComponentItem!.typeName {
            self.typeNameTextField?.text = typeName
        }
        else {
            self.typeNameTextField?.text = nil
        }
        
        if let accuracy = detailComponentItem!.accuracy {
            self.accuracyTextField?.text = accuracy
        }
        else {
            self.accuracyTextField?.text = nil
        }
        if let operatingRange = detailComponentItem!.operatingRange {
            self.operatingRangeTextField?.text = operatingRange
        }
        else {
            self.operatingRangeTextField?.text = nil
        }

        
        if let logicalDevice = detailComponentItem!.logicalDevice {
            if let unitDescription = logicalDevice.unitDescription {
                self.logicalDeviceButton?.setTitle(logicalDevice.unitDescription, forState: .Normal)
            }
            else {
                self.logicalDeviceButton?.setTitle("Choose Logical Device", forState: .Normal)
            }
        }
        else {
            self.logicalDeviceButton?.setTitle("Choose Logical Device", forState: .Normal)
        }
        self.updateInstallationDateButtonTitle()
        self.updateLastCalibrationDateButtonTitle()
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
    
    func updateLastCalibrationDateButtonTitle() {
        if let lastCalibrationDate = self.lastCalibrationDate {
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = .ShortStyle
            dateFormatter.dateStyle = .MediumStyle
            
            self.calibrationDateButton?.setTitle(dateFormatter.stringFromDate(lastCalibrationDate), forState: .Normal)
            
        }
        else {
            self.calibrationDateButton?.setTitle("Calibration Date", forState: .Normal)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "ComponentsViewControllerPopover") {
            if let componentsViewController = segue.destinationViewController as? ComponentsViewController {

            }
        }
    }
    
    @IBAction func imageViewTapped(sender: UITapGestureRecognizer) {
        var imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
            
            self.presentViewController(imagePickerController, animated: true) { () -> Void in
                
            }
        }
        else {
            imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.cameraPopoverController = UIPopoverController(contentViewController: imagePickerController)
            self.cameraPopoverController?.presentPopoverFromRect(sender.view!.bounds, inView: sender.view!, permittedArrowDirections: .Any, animated: true)
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let image = info[UIImagePickerControllerEditedImage] as UIImage
        self.detailComponentItem?.photo = image
        
        self.imageView.image = self.detailComponentItem?.photo
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
}
