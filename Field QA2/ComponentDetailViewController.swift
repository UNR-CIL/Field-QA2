//
//  ComponentDetailViewController.swift
//  Field QA2
//
//  Created by John Jusayan on 9/16/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import UIKit
import CoreData

class ComponentDetailViewController: UITableViewController, UIPopoverControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    var displayMode: DisplayMode = .NotShowingDatePicker

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
    var imageView: UIImageView?
    //@NSManaged var photo: UIImage?
    
    var nameTextField: UITextField?
    //@NSManaged var name: String?
  
    var purposeTextView: UITextView?
    //@NSManaged var purpose: String?
    
    var typeNameTextField: UITextField?
    //@NSManaged var typeName: String?
    
    var unitDescriptionTextView: UITextView?
    //@NSManaged var unitDescription: String?
    
    var modelTextField: UITextField?
    //@NSManaged var model: String?
    
    var serialNumberTextField: UITextField?
    //@NSManaged var serialNumber: String?
    
    var vendorTextField: UITextField?
    //@NSManaged var vendor: String?
    
    var manufacturerTextField: UITextField?
    //@NSManaged var manufacturer: String?
    
    var supplierTextField: UITextField?
    //@NSManaged var supplier: String?
    
    var centerOffset: UITextField?
    //@NSManaged var centerOffset: NSNumber?
    
    var heightFromGroundTextField: UITextField?
    //@NSManaged var heightFromGround: NSNumber?
    
    var installationDate: NSDate?
    var installationDateLabel: UILabel?
    //@NSManaged var installationDate: NSDate?
    var installationDatePicker: UIDatePicker?
    
    
    var installationDetailsTextView: UITextView?
    //@NSManaged var installationDetails: String?
    
    var installationTextField: UITextField?
    //@NSManaged var installationLocation: String?
    
    var wiringNotesTextView: UITextView?
    //@NSManaged var wiringNotes: String?

    var latitudeTextField: UITextField?
    //@NSManaged var latitude: NSNumber?
    
    var longitudeTextField: UITextField?
    //@NSManaged var longitude: NSNumber?
    
    var lastCalibratedDate: NSDate?
    var lastCalibratedDateLabel: UILabel?
    //@NSManaged var lastCalibratedDate: NSDate?
    var lastCalibratedDatePicker: UIDatePicker?
    
    var dataIntervalTextField: UITextField?
    //@NSManaged var dataInterval: String?
    
    var dataStreamDetails: UITextView?
    //@NSManaged var dataStreamDetails: String?
    
    var measurementPropertyTextField: UITextField?
    //@NSManaged var measurementProperty: String?
    
    var minimumOperatingRangeTextField: UITextField?
    //@NSManaged var minimumOperatingRange: NSNumber?
    
    var maximumOperatingRangeTextField: UITextField?
    //@NSManaged var maximumOperatingRange: NSNumber?
    
    var minimumAccuracyBoundTextField: UITextField?
    //@NSManaged var minimumAccuracyBound: NSNumber?
    
    var maximumAccuracyBoundTextField: UITextField?
    //@NSManaged var maxiumumAccuracyBound: NSNumber?
    
    var parentLoggerTextField: UITextField?
    //@NSManaged var parentLogger: String?
    
    var associatedLogicalDevice: LogicalDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillChangeFrameNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            let viewHeight = self.view.bounds.size.height
            let userInfo = notification.userInfo as NSDictionary!
            let keyboardValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as NSValue
            let keyboardRect = keyboardValue.CGRectValue()
            let keyboardHeight = keyboardRect.size.height
            
        }
        
        let addServiceEntryBarButton = UIBarButtonItem(title: "+ Service Entry", style: .Plain, target: self, action: "addServiceEntryToProject:")
        navigationItem.rightBarButtonItems = [addServiceEntryBarButton]
        
        if detailComponentItem?.newlyCreated == true {
            self.setEditing(true, animated: false)
        }
        else {
            self.setEditing(false, animated: false)
        }
        
        self.configureView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Component Details"
        case 1:
            return detailComponentItem?.serviceEntries.count > 0 ? "Service Entries" : nil
        default:
            return nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addServiceEntryToProject(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func installationDateButtonTapped(sender: AnyObject) {
        let datePickerStoryboard = UIStoryboard(name: "DatePicker", bundle: nil)
        let datePickerViewController = datePickerStoryboard.instantiateViewControllerWithIdentifier("DatePickerViewController") as DatePickerViewController
        self.installationDatePopoverController = UIPopoverController(contentViewController: datePickerViewController)
        
        self.installationDatePopoverController!.delegate = self
    }
    
    @IBAction func calibrationDateButtonTapped(sender: AnyObject) {
        let datePickerStoryboard = UIStoryboard(name: "DatePicker", bundle: nil)
        let datePickerViewController = datePickerStoryboard.instantiateViewControllerWithIdentifier("DatePickerViewController") as DatePickerViewController
        self.lastCallibrationDatePopoverController = UIPopoverController(contentViewController: datePickerViewController)
        
        self.lastCallibrationDatePopoverController!.delegate = self
    }
    
    @IBAction func logicalDeviceButtonTapped(sender: AnyObject) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let systemsViewController = mainStoryboard.instantiateViewControllerWithIdentifier("AssociatedLogicalDeviceViewController") as LogicalDevicesViewController
        self.logicalDevicePopoverController = UIPopoverController(contentViewController: systemsViewController)
        
        self.logicalDevicePopoverController!.delegate = self
    }
    
    func popoverControllerShouldDismissPopover(popoverController: UIPopoverController) -> Bool {
        if popoverController == self.installationDatePopoverController {
            let datePickerViewController = popoverController.contentViewController as DatePickerViewController
            installationDate = datePickerViewController.datePicker.date
        }
        else if popoverController == self.lastCallibrationDatePopoverController {
            let datePickerViewController = popoverController.contentViewController as DatePickerViewController
        }
        else if popoverController == self.logicalDevicePopoverController {
            let logicalDevicesViewController = popoverController.contentViewController as LogicalDevicesViewController
            associatedLogicalDevice = logicalDevicesViewController.currentlySelectedLogicalDevice
        }
        return true
    }
    
    @IBAction func saveBarButtonTapped(sender: AnyObject) {

    }

    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            return 52.0
        case (0, 1), (0, 3), (0, 12), (0, 13), (0, 15), (0, 19), (0, 21):
            return 162
        default:
            return 44.0
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 27
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellIdentifier: String? = nil
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cellIdentifier = "PhotoTextFieldCell"
        case (0, 1), (0, 3), (0, 13), (0, 15), (0, 21):
            cellIdentifier = "NotesCell"
        case (0, 11), (0, 18):
            cellIdentifier = "DateDisplayCell"
        case (0, 12),  (0, 19):
            cellIdentifier = "DatePickerCell"
        default:
            cellIdentifier = "TextFieldCell"
        }
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier!, forIndexPath: indexPath) as UITableViewCell
        configureCell(cell, forIndexPath: indexPath)
        
        return cell
    }

    
    func configureCell(cell: UITableViewCell, forIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                nameTextField = cell.textField
                nameTextField?.delegate = self
                cell.titleLabel.text = "Name"
                cell.textField.text = detailComponentItem?.name
                
                cell.photoImageView?.layer.borderColor = UIColor.lightGrayColor().CGColor
                cell.photoImageView?.layer.borderWidth = 1.0
                cell.photoImageView?.layer.cornerRadius = 20
                cell.photoImageView?.layer.masksToBounds = true
                
                if let photo = detailComponentItem?.photo {
                    cell.photoImageView?.image = photo
                }
                else {
                    cell.photoImageView?.image = nil
                }
            }
        case (0, 1):
            if let cell = cell as? NotesCell {
                cell.textView.userInteractionEnabled = self.editing

                purposeTextView = cell.textView
                purposeTextView?.delegate = self
                cell.titleLabel.text = "Purpose"
                cell.textView.text = detailComponentItem?.purpose
            }
        case (0, 2):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                typeNameTextField = cell.textField
                typeNameTextField?.delegate = self
                cell.textField.text = detailComponentItem?.typeName
                cell.titleLabel.text = "Type"
            }
        case (0, 3):
            if let cell = cell as? NotesCell {
                cell.textView.userInteractionEnabled = self.editing

                unitDescriptionTextView = cell.textView
                unitDescriptionTextView?.delegate = self
                cell.titleLabel.text = "Unit Description"
                cell.textView.text = detailComponentItem?.unitDescription
            }
        case (0, 4):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                modelTextField = cell.textField
                modelTextField?.delegate = self
                cell.textField.text = detailComponentItem?.model
                cell.titleLabel.text = "Model"
            }
        case (0, 5):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                serialNumberTextField = cell.textField
                serialNumberTextField?.delegate = self
                cell.textField.text = detailComponentItem?.serialNumber
                cell.titleLabel.text = "Serial"
            }
        case (0, 6):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                vendorTextField = cell.textField
                vendorTextField?.delegate = self
                cell.textField.text = detailComponentItem?.vendor
                cell.titleLabel.text = "Vendor"
            }
        case (0, 7):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                manufacturerTextField = cell.textField
                manufacturerTextField?.delegate = self
                cell.textField.text = detailComponentItem?.manufacturer
                cell.titleLabel.text = "Manufacturer"
            }
        case (0, 8):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                supplierTextField = cell.textField
                supplierTextField?.delegate = self
                cell.textField.text = detailComponentItem?.supplier
                cell.titleLabel.text = "Supplier"
            }
        case (0, 9):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

               centerOffset = cell.textField
               centerOffset?.delegate = self
            
               let numberFormatter = NSNumberFormatter()
                if let offsetNumber = detailComponentItem?.centerOffset {
                    cell.textField.text = numberFormatter.stringFromNumber(offsetNumber)
                }
                else {
                    cell.textField.text = nil
                }
                cell.titleLabel.text = "Center Offset"
            }
        case (0, 10):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                heightFromGroundTextField = cell.textField
                heightFromGroundTextField?.delegate = self
                
                let numberFormatter = NSNumberFormatter()
                if let offsetNumber = detailComponentItem?.heightFromGround {
                    cell.textField.text = numberFormatter.stringFromNumber(offsetNumber)
                }
                else {
                    cell.textField.text = nil
                }
                cell.titleLabel.text = "Height"
            }
        case (0, 11):
            if let cell = cell as? DateDisplayCell {
                installationDateLabel = cell.detailLabel
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.timeStyle = .MediumStyle
                dateFormatter.dateStyle = .MediumStyle
                cell.titleLabel.text = "Installation Date"
                
                if let date = detailComponentItem?.installationDate {
                    cell.detailLabel.text = dateFormatter.stringFromDate(date)
                }
                else {
                    cell.detailLabel.text = ""
                }
            }
        case (0, 12):
            if let cell = cell as? DatePickerCell {
                cell.datePicker.userInteractionEnabled = self.editing

                installationDatePicker = cell.datePicker
                installationDatePicker?.addTarget(self, action: "dateValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
            }
        case (0, 13):
            if let cell = cell as? NotesCell {
                cell.textView.userInteractionEnabled = self.editing

                installationDetailsTextView = cell.textView
                installationDetailsTextView?.delegate = self
                cell.titleLabel.text = "Installation Details"
                cell.textView.text = detailComponentItem?.installationDetails
            }
        case (0, 14):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                installationTextField = cell.textField
                installationTextField?.delegate = self
                cell.textField.text = detailComponentItem?.installationLocation
                cell.titleLabel.text = "Location"
            }
        case (0, 15):
            if let cell = cell as? NotesCell {
                cell.textView.userInteractionEnabled = self.editing

                wiringNotesTextView = cell.textView
                wiringNotesTextView?.delegate = self
                cell.titleLabel.text = "Wiring Notes"
                cell.textView.text = detailComponentItem?.wiringNotes
            }
        case (0, 16):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                latitudeTextField = cell.textField
                latitudeTextField?.keyboardType = .DecimalPad
                latitudeTextField?.delegate = self
                
                let numberFormatter = NSNumberFormatter()
                
                if let latitudeString = detailComponentItem?.latitude {
                    cell.textField.text = numberFormatter.stringFromNumber(latitudeString)
                }
                cell.titleLabel.text = "Latitude"
                
            }
        case (0, 17):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                longitudeTextField = cell.textField
                longitudeTextField?.keyboardType = .DecimalPad
                longitudeTextField?.delegate = self
                
                let numberFormatter = NSNumberFormatter()
                
                if let longitudeString = detailComponentItem?.latitude {
                    cell.textField.text = numberFormatter.stringFromNumber(longitudeString)
                }
                cell.titleLabel.text = "Longitude"
            }
        case (0, 18):
            if let cell = cell as? DateDisplayCell {
                lastCalibratedDateLabel = cell.detailLabel
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.timeStyle = .MediumStyle
                dateFormatter.dateStyle = .MediumStyle
                cell.titleLabel.text = "Last Calibration"
                
                if let date = detailComponentItem?.lastCalibratedDate {
                    cell.detailLabel.text = dateFormatter.stringFromDate(date)
                }
                else {
                    cell.detailLabel.text = ""
                }
            }
        case (0, 19):
            if let cell = cell as? DatePickerCell {
                cell.datePicker.userInteractionEnabled = self.editing

                lastCalibratedDatePicker = cell.datePicker
                lastCalibratedDatePicker?.addTarget(self, action: "dateValueChanged:", forControlEvents: .ValueChanged)
            }
        case (0, 20):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                dataIntervalTextField = cell.textField
                dataIntervalTextField?.delegate = self
                dataIntervalTextField?.text = detailComponentItem?.dataInterval
                cell.titleLabel.text = "Interval"
            }
        case (0, 21):
            if let cell = cell as? NotesCell {
                cell.textView.userInteractionEnabled = self.editing

                dataStreamDetails = cell.textView
                dataStreamDetails?.delegate = self
                cell.titleLabel.text = "Data Stream Details"
                dataStreamDetails?.text = detailComponentItem?.dataStreamDetails
            }
        case (0, 22):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                measurementPropertyTextField = cell.textField
                measurementPropertyTextField?.delegate = self
                measurementPropertyTextField?.text = detailComponentItem?.measurementProperty
                cell.titleLabel.text = "Measurement"
            }
        case (0, 23):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                minimumOperatingRangeTextField = cell.textField
                minimumOperatingRangeTextField?.delegate = self
                
                let numberFormatter = NSNumberFormatter()
                
                if let minimum = detailComponentItem?.minimumOperatingRange {
                    minimumOperatingRangeTextField?.text = numberFormatter.stringFromNumber(minimum)
                }
                
                cell.titleLabel.text = "Min Range"
            }
        case (0, 24):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                maximumOperatingRangeTextField = cell.textField
                maximumOperatingRangeTextField?.delegate = self
                
                let numberFormatter = NSNumberFormatter()
                
                if let maximum = detailComponentItem?.maximumOperatingRange {
                    maximumOperatingRangeTextField?.text = numberFormatter.stringFromNumber(maximum)
                }
                
                cell.titleLabel.text = "Max Range"
            }
        case (0, 25):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                minimumAccuracyBoundTextField = cell.textField
                minimumAccuracyBoundTextField?.delegate = self
                
                let numberFormatter = NSNumberFormatter()
                
                if let minimum = detailComponentItem?.minimumAccuracyBound {
                    minimumAccuracyBoundTextField?.text = numberFormatter.stringFromNumber(minimum)
                }
                
                cell.titleLabel.text = "Min Accuracy"
            }
        case (0, 26):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                maximumAccuracyBoundTextField = cell.textField
                maximumAccuracyBoundTextField = cell.textField
                maximumAccuracyBoundTextField?.delegate = self
                
                let numberFormatter = NSNumberFormatter()
                
                if let maximum = detailComponentItem?.maxiumumAccuracyBound {
                    maximumAccuracyBoundTextField?.text = numberFormatter.stringFromNumber(maximum)
                }
                
                cell.titleLabel.text = "Max Range"
            }
        case (0, 27):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                parentLoggerTextField = cell.textField
                parentLoggerTextField?.delegate = self
                parentLoggerTextField?.text = detailComponentItem?.parentLogger
                cell.titleLabel.text = "Parent Logger"
            }

            
        default:
            println("mode \(displayMode.rawValue) row \(indexPath.row)")
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        
        if textField == nameTextField {
            detailComponentItem?.name = textField.text
        }
        if textField ==  typeNameTextField {
            detailComponentItem?.typeName = textField.text
        }
        if textField ==  modelTextField {
            detailComponentItem?.model = textField.text
        }
        if textField ==  serialNumberTextField {
            detailComponentItem?.serialNumber = textField.text
        }
        if textField ==  vendorTextField {
            detailComponentItem?.vendor = textField.text
        }
        if textField ==  manufacturerTextField {
            detailComponentItem?.manufacturer = textField.text
        }
        if textField ==  supplierTextField {
            detailComponentItem?.supplier = textField.text
        }
        if textField ==  centerOffset {
            let numberFormatter = NSNumberFormatter()
            detailComponentItem?.centerOffset = numberFormatter.numberFromString(textField.text)
        }
        if textField ==  heightFromGroundTextField {
            let numberFormatter = NSNumberFormatter()
            detailComponentItem?.heightFromGround = numberFormatter.numberFromString(textField.text)
        }
        if textField ==  installationTextField {
            detailComponentItem?.installationLocation = textField.text
        }
        if textField ==  latitudeTextField{
            let numberFormatter = NSNumberFormatter()

            detailComponentItem?.latitude = numberFormatter.numberFromString(textField.text)
        }
        if textField ==  longitudeTextField {
            let numberFormatter = NSNumberFormatter()

            detailComponentItem?.longitude = numberFormatter.numberFromString(textField.text)
        }
        if textField ==  dataIntervalTextField {
            detailComponentItem?.dataInterval = textField.text
        }
        if textField ==  measurementPropertyTextField {
            detailComponentItem?.measurementProperty = textField.text
        }
        if textField ==  minimumOperatingRangeTextField {
            let numberFormatter = NSNumberFormatter()

            detailComponentItem?.minimumOperatingRange = numberFormatter.numberFromString(textField.text)
        }
        if textField ==  maximumOperatingRangeTextField{
            let numberFormatter = NSNumberFormatter()

            detailComponentItem?.maximumOperatingRange = numberFormatter.numberFromString(textField.text)
        }
        if textField ==  minimumAccuracyBoundTextField{
            let numberFormatter = NSNumberFormatter()

            detailComponentItem?.minimumAccuracyBound = numberFormatter.numberFromString(textField.text)
        }
        if textField ==  maximumAccuracyBoundTextField{
            let numberFormatter = NSNumberFormatter()

            detailComponentItem?.maxiumumAccuracyBound = numberFormatter.numberFromString(textField.text)
        }
        if textField ==  parentLoggerTextField {
            detailComponentItem?.parentLogger = textField.text
        }
        
        return true
    }
    
    func dateValueChanged(sender: UIDatePicker) {
        
        if sender == self.installationDatePicker {
            detailComponentItem?.installationDate = sender.date
            
            
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 11, inSection: 0)], withRowAnimation: .None)
        }
        else if sender == self.lastCalibratedDatePicker {
            detailComponentItem?.lastCalibratedDate = sender.date
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 18, inSection: 0)], withRowAnimation: .None)

        }
    }
    
    
    // MARK: UITextViewDelegate
    
    func textViewDidChange(textView: UITextView) {
        
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if textView == purposeTextView {
            detailComponentItem?.purpose = textView.text
        }
        if textView == unitDescriptionTextView {
            detailComponentItem?.unitDescription = textView.text
        }
        if textView == installationDetailsTextView {
            detailComponentItem?.installationDetails = textView.text
        }
        
        
        if textView == wiringNotesTextView {
            detailComponentItem?.wiringNotes = textView.text
        }
        
        if textView == dataStreamDetails {
            detailComponentItem?.dataStreamDetails = textView.text
        }
        
        return true
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        
    }
    
    // >>>
    
    func configureView() {

    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "ComponentsViewControllerPopover") {
            if let componentsViewController = segue.destinationViewController as? ComponentsViewController {

            }
        }
    }

    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let image = info[UIImagePickerControllerEditedImage] as UIImage
        self.detailComponentItem?.photo = image
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in

        })
    }
    
    @IBAction func photoImageViewTapped(sender: UITapGestureRecognizer) {
        NSLog("Tapped!")
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
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.reloadData()
    }
}
