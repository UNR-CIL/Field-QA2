//
//  ComponentDetailViewController.swift
//  Field QA2
//
//  Created by John Jusayan on 9/16/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import UIKit

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
    
    var dateIntervalTextField: UITextField?
    //@NSManaged var dataInterval: String?
    
    var dataStreamDetails: UITextView?
    //@NSManaged var dataStreamDetails: String?
    
    var measuremetPropertyTextField: UITextField?
    //@NSManaged var measurementProperty: String?
    
    var minimumOpeatingRangeTextField: UITextField?
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

    // >>>
    
    /*

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
    
    var dateIntervalTextField: UITextField?
    //@NSManaged var dataInterval: String?
    
    var dataStreamDetails: UITextView?
    //@NSManaged var dataStreamDetails: String?
    
    var measuremetPropertyTextField: UITextField?
    //@NSManaged var measurementProperty: String?
    
    var minimumOpeatingRangeTextField: UITextField?
    //@NSManaged var minimumOperatingRange: NSNumber?
    
    var maximumOperatingRangeTextField: UITextField?
    //@NSManaged var maximumOperatingRange: NSNumber?
    
    var minimumAccuracyBoundTextField: UITextField?
    //@NSManaged var minimumAccuracyBound: NSNumber?
    
    var maximumAccuracyBoundTextField: UITextField?
    //@NSManaged var maxiumumAccuracyBound: NSNumber?
    
    var parentLoggerTextField: UITextField?
    //@NSManaged var parentLogger: String?
    
    */
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 162.0
        }
        if displayMode == DisplayMode.ShowingFirstDatePicker {
            if indexPath.row == 6 {
                return 162.0
            }
        }
        return 44.0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return displayMode == .ShowingFirstDatePicker ? 26 : 24
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellIdentifier: String? = nil
        
        switch indexPath.row {
        case 1:
            cellIdentifier = "NotesCell"
        case 5:
            cellIdentifier = "DateDisplayCell"
        case 6:
            cellIdentifier = "DatePickerCell"
        default:
            cellIdentifier = "TextFieldCell"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier!, forIndexPath: indexPath) as UITableViewCell
        configureCell(cell, forIndexPath: indexPath)
        
        return cell
    }
    
    /*

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var modelTextField:  UITextField!
    @IBOutlet weak var manufacturerTextField:  UITextField!
    
    @IBOutlet weak var serialNumberTextField: UITextField!
    @IBOutlet weak var typeNameTextField: UITextField!
    
    @IBOutlet weak var accuracyTextField: UITextField!
    @IBOutlet weak var operatingRangeTextField: UITextField!



*/
    
    func configureCell(cell: UITableViewCell, forIndexPath indexPath: NSIndexPath) {
        switch (displayMode, indexPath.row) {
        case (_, 0):
            if let cell: TextFieldCell = cell as? TextFieldCell {
                nameTextField = cell.textField
                nameTextField?.delegate = self
                cell.titleLabel.text = "Name"
                cell.textField.text = detailComponentItem?.name
            }
            /*
            
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
            
            var dateIntervalTextField: UITextField?
            //@NSManaged var dataInterval: String?
            
            var dataStreamDetails: UITextView?
            //@NSManaged var dataStreamDetails: String?
            
            var measuremetPropertyTextField: UITextField?
            //@NSManaged var measurementProperty: String?
            
            var minimumOpeatingRangeTextField: UITextField?
            //@NSManaged var minimumOperatingRange: NSNumber?
            
            var maximumOperatingRangeTextField: UITextField?
            //@NSManaged var maximumOperatingRange: NSNumber?
            
            var minimumAccuracyBoundTextField: UITextField?
            //@NSManaged var minimumAccuracyBound: NSNumber?
            
            var maximumAccuracyBoundTextField: UITextField?
            //@NSManaged var maxiumumAccuracyBound: NSNumber?
            
            var parentLoggerTextField: UITextField?
            //@NSManaged var parentLogger: String?
            
            */

            
        /*
        case (_, 5):
            if let cell: DateDisplayCell = cell as? DateDisplayCell {
                dateLabel = cell.detailLabel
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
        case (.ShowingFirstDatePicker, 6):
            if let cell: DatePickerCell = cell as? DatePickerCell {
                datePicker = cell.datePicker
                datePicker?.addTarget(self, action: "dateValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
                
            }
          */
            
        default:
            println("mode \(displayMode.rawValue) row \(indexPath.row)")
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if (indexPath.row == 5) {
            if displayMode == DisplayMode.NotShowingDatePicker {
                displayMode = .ShowingFirstDatePicker
            }
            else {
                displayMode = .NotShowingDatePicker
            }
            tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
            
        }
    }
    
    /*
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var installationDateButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    
    */
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        println("textField ended \(textField.text)")
        
        if textField == nameTextField {
            detailComponentItem?.name = textField.text
        }

        return true
    }
    
    func dateValueChanged(sender: UIDatePicker) {
        detailComponentItem?.installationDate = sender.date
    }
    
    
    // MARK: UITextViewDelegate
    
    func textViewDidChange(textView: UITextView) {
        
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if textView == unitDescriptionTextView {
            detailComponentItem?.unitDescription = textView.text
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
        
        //self.imageView.image = self.detailComponentItem?.photo
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
}
