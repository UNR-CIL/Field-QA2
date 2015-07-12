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

    var installationDate: NSDate?
    var lastCalibratedDate: NSDate?

    var associatedLogicalDevice: LogicalDevice?
    
    var yearAndDayInstallationDate: NSDate?
    var timeInstallationDate: NSDate?
    var yearAndDayLastCalibratedDate: NSDate?
    var timeLastCalibratedDate: NSDate?

    var tableItems = [
        (propertyName: "name", title: "Name", cellIdentifier: "PhotoTextFieldCell", valueType: "text"),
        (propertyName: "purpose", title: "Purpose", cellIdentifier: "NotesCell", valueType: "text"),
        (propertyName: "typeName", title: "Type", cellIdentifier: "TextFieldCell", valueType: "text"),
        (propertyName: "unitDescription", title: "Unit Description", cellIdentifier: "NotesCell", valueType: "text"),
        (propertyName: "model", title: "Model", cellIdentifier: "TextFieldCell", valueType: "text"),
        (propertyName: "serialNumber", title: "Serial", cellIdentifier: "TextFieldCell", valueType: "text"),
        (propertyName: "vendor", title: "Vendor", cellIdentifier: "TextFieldCell", valueType: "text"),
        (propertyName: "manufacturer", title: "Manufacturer", cellIdentifier: "TextFieldCell", valueType: "text"),
        (propertyName: "supplier", title: "Supplier", cellIdentifier: "TextFieldCell", valueType: "text"),
        (propertyName: "centerOffset", title: "Center Offset", cellIdentifier: "TextFieldCell", valueType: "number"),
        (propertyName: "heightFromGround", title: "Height", cellIdentifier: "TextFieldCell",valueType: "number"),
        (propertyName: "installationDate", title: "Installation Date", cellIdentifier: "DateDisplayCell", valueType: "date"),
        (propertyName: "installationDate", title: "", cellIdentifier: "DatePickerCell", valueType: "date"),
        (propertyName: "installationDate", title: "", cellIdentifier: "DatePickerCell", valueType: "date"),
        (propertyName: "installationDetails", title: "Installation Details", cellIdentifier: "NotesCell", valueType: "text"),
        (propertyName: "wiringNotes", title: "Wiring Notes", cellIdentifier: "NotesCell", valueType: "text"),
        (propertyName: "installationLocation", title: "Location", cellIdentifier: "TextFieldCell", valueType: "text"),
        (propertyName: "latitude", title: "Latitude", cellIdentifier: "TextFieldCell", valueType: "number"),
        (propertyName: "latitude", title: "Longitude", cellIdentifier: "TextFieldCell", valueType: "number"),
        (propertyName: "lastCalibratedDate", title: "Last Calibration", cellIdentifier: "DateDisplayCell", valueType: "text"),
        (propertyName: "calibrationStatus", title: "", cellIdentifier: "SegmentedControlCell", valueType: "number"),
        (propertyName: "lastCalibratedDate", title: "", cellIdentifier: "DatePickerCell", valueType: "date"),
        (propertyName: "lastCalibratedDate", title: "", cellIdentifier: "DatePickerCell", valueType: "date"),
        (propertyName: "dataInterval", title: "Interval", cellIdentifier: "TextFieldCell", valueType: "text"),
        (propertyName: "dataStreamDetails", title: "Data Stream Details", cellIdentifier: "NotesCell", valueType: "text"),
        (propertyName: "measurementProperty", title: "Measurement", cellIdentifier: "TextFieldCell", valueType: "text"),
        (propertyName: "minimumOperatingRange", title: "Min Range", cellIdentifier: "TextFieldCell", valueType: "number"),
        (propertyName: "maximumOperatingRange", title: "Max Range", cellIdentifier: "TextFieldCell", valueType: "number"),
        (propertyName: "minimumAccuracyBound", title: "Min Accuracy", cellIdentifier: "TextFieldCell", valueType: "text"),
        (propertyName: "maximumAccuracyBound", title: "Max Accuracy", cellIdentifier: "TextFieldCell", valueType: "text"),
        (propertyName: "parentLogger", title: "Parent Logger", cellIdentifier: "TextFieldCell", valueType: "text")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillChangeFrameNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            _ = self.view.bounds.size.height
            let userInfo = notification.userInfo as NSDictionary!
            let keyboardValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
            let keyboardRect = keyboardValue.CGRectValue()
            _ = keyboardRect.size.height
            
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName("SegmentedValueChanged", object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            if let segmentedControl = notification.userInfo?["segmentedControl"] as? UISegmentedControl {
                self.detailComponentItem?.calibrationStatus = segmentedControl.selectedSegmentIndex
            }
        }
        
        
        let addServiceEntryBarButton = UIBarButtonItem(title: "+ Service Entry", style: .Plain, target: self, action: "addServiceEntryToComponent:")
        navigationItem.rightBarButtonItems = [addServiceEntryBarButton]
        
        if detailComponentItem?.newlyCreated == true {
            self.setEditing(true, animated: false)

            if let parentSystem = detailComponentItem?.system {
                if detailComponentItem?.installationDate == nil {
                    detailComponentItem?.installationDate = parentSystem.installationDate
                }
                if detailComponentItem?.installationLocation == nil {
                    detailComponentItem?.installationLocation = parentSystem.installationLocation
                }
                if detailComponentItem?.latitude == nil {
                    detailComponentItem?.latitude = parentSystem.latitude
                }
                if detailComponentItem?.longitude == nil {
                    detailComponentItem?.longitude = parentSystem.longitude
                }
            }

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
    
    func addServiceEntryToComponent(sender: UIBarButtonItem) {
        if let context = detailComponentItem?.managedObjectContext {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let serviceEntryDetailViewController = storyboard.instantiateViewControllerWithIdentifier("ServiceEntryDetailViewController") as! ServiceEntryDetailViewController
            serviceEntryDetailViewController.presentedAsFormStyle = true
            
            let navigationController = UINavigationController(rootViewController: serviceEntryDetailViewController)
            navigationController.modalPresentationStyle = .FormSheet
            self.presentViewController(navigationController, animated: true, completion: nil)
            
            let newServiceEntry = NSEntityDescription.insertNewObjectForEntityForName("ServiceEntry", inManagedObjectContext: context) as! ServiceEntry
            newServiceEntry.component = detailComponentItem
            newServiceEntry.newlyCreated = true
            serviceEntryDetailViewController.detailServiceEntryItem = newServiceEntry
            
            do {
                try context.save()
            }
            catch {
                abort()
            }
        }

    }
    
    @IBAction func installationDateButtonTapped(sender: AnyObject) {
        let datePickerStoryboard = UIStoryboard(name: "DatePicker", bundle: nil)
        let datePickerViewController = datePickerStoryboard.instantiateViewControllerWithIdentifier("DatePickerViewController") as! DatePickerViewController
        self.installationDatePopoverController = UIPopoverController(contentViewController: datePickerViewController)
        
        self.installationDatePopoverController!.delegate = self
    }
    
    @IBAction func calibrationDateButtonTapped(sender: AnyObject) {
        let datePickerStoryboard = UIStoryboard(name: "DatePicker", bundle: nil)
        let datePickerViewController = datePickerStoryboard.instantiateViewControllerWithIdentifier("DatePickerViewController") as! DatePickerViewController
        self.lastCallibrationDatePopoverController = UIPopoverController(contentViewController: datePickerViewController)
        
        self.lastCallibrationDatePopoverController!.delegate = self
    }
    
    @IBAction func logicalDeviceButtonTapped(sender: AnyObject) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let systemsViewController = mainStoryboard.instantiateViewControllerWithIdentifier("AssociatedLogicalDeviceViewController") as! LogicalDevicesViewController
        self.logicalDevicePopoverController = UIPopoverController(contentViewController: systemsViewController)
        
        self.logicalDevicePopoverController!.delegate = self
    }
    
    func popoverControllerShouldDismissPopover(popoverController: UIPopoverController) -> Bool {
        if popoverController == self.installationDatePopoverController {
            let datePickerViewController = popoverController.contentViewController as! DatePickerViewController
            installationDate = datePickerViewController.datePicker.date
        }
        else if popoverController == self.lastCallibrationDatePopoverController {
            _ = popoverController.contentViewController as? DatePickerViewController
        }
        else if popoverController == self.logicalDevicePopoverController {
            let logicalDevicesViewController = popoverController.contentViewController as! LogicalDevicesViewController
            associatedLogicalDevice = logicalDevicesViewController.currentlySelectedLogicalDevice
        }
        return true
    }
    
    @IBAction func saveBarButtonTapped(sender: AnyObject) {

    }

    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (tableItems[indexPath.row].cellIdentifier) {
        case "PhotoTextFieldCell":
            return 52.0
        case "NotesCell", "DatePickerCell":
            return 162.0
        default:
            return 44.0
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = tableItems[indexPath.row].cellIdentifier
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        configureCell(cell, forIndexPath: indexPath)
        
        return cell
    }
    
    // TODO: Re-write using the tableItems array for configuration
    func configureCell(cell: UITableViewCell, forIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing
                
                cell.textField.delegate = self
                cell.titleLabel.text = tableItems[0].title
                cell.textField.text = detailComponentItem?.valueForKey(tableItems[0].propertyName) as! String?
                
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
                
                cell.textView?.delegate = self
                cell.titleLabel.text = tableItems[1].title
                cell.textView.text = detailComponentItem?.valueForKey(tableItems[1].propertyName) as! String?
            }
        case (0, 2):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                cell.textField?.delegate = self
                cell.textField.text = detailComponentItem?.typeName
                cell.titleLabel.text = "Type"
            }
        case (0, 3):
            if let cell = cell as? NotesCell {
                cell.textView.userInteractionEnabled = self.editing
    
                cell.textView?.delegate = self
                

                cell.titleLabel.text = "Unit Description"
                cell.textView.text = detailComponentItem?.unitDescription
            }
        case (0, 4):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                cell.textField?.delegate = self
                cell.textField.text = detailComponentItem?.model
                cell.titleLabel.text = "Model"
            }
        case (0, 5):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                cell.textField?.delegate = self
                cell.textField.text = detailComponentItem?.serialNumber
                cell.titleLabel.text = "Serial"
            }
        case (0, 6):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                cell.textField?.delegate = self
                cell.textField.text = detailComponentItem?.vendor
                cell.titleLabel.text = "Vendor"
            }
        case (0, 7):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                cell.textField?.delegate = self
                cell.textField.text = detailComponentItem?.manufacturer
                cell.titleLabel.text = "Manufacturer"
            }
        case (0, 8):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                cell.textField?.delegate = self
                cell.textField.text = detailComponentItem?.supplier
                cell.titleLabel.text = "Supplier"
            }
        case (0, 9):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

               cell.textField?.delegate = self
            
               let numberFormatter = NSNumberFormatter()
                if let offsetNumber = detailComponentItem?.centerOffset {
                    cell.textField.text = numberFormatter.stringFromNumber(offsetNumber)
                }
                else {
                    cell.textField.text = nil
                }
                cell.titleLabel.text = "Center Offset"
                cell.textField.keyboardType = UIKeyboardType.NumberPad
            }
        case (0, 10):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                cell.textField?.delegate = self
                
                let numberFormatter = NSNumberFormatter()
                if let offsetNumber = detailComponentItem?.heightFromGround {
                    cell.textField.text = numberFormatter.stringFromNumber(offsetNumber)
                }
                else {
                    cell.textField.text = nil
                }
                cell.titleLabel.text = "Height"
                cell.textField.keyboardType = UIKeyboardType.NumberPad
            }
        case (0, 11):
            if let cell = cell as? DateDisplayCell {
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

                cell.datePicker?.datePickerMode = .Date
                cell.datePicker?.addTarget(self, action: "dateValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
                
                cell.datePicker?.tag = 1
                
                if let date = detailComponentItem?.installationDate {
                    let calendar = NSCalendar.currentCalendar()
                    let dateComponents = calendar.components([.Year, .Month, .Day], fromDate: date)
                    let normalizedDate = calendar.dateFromComponents(dateComponents)
                    cell.datePicker?.date = normalizedDate ?? NSDate()
                }

            }
        case (0, 13):
            if let cell = cell as? DatePickerCell {
                cell.datePicker.userInteractionEnabled = self.editing
                
                cell.datePicker?.datePickerMode = .Time
                cell.datePicker?.addTarget(self, action: "dateValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
                cell.datePicker?.tag = 2
                
                if let date = detailComponentItem?.installationDate {
                    let calendar = NSCalendar.currentCalendar()
                    let dateComponents = calendar.components([.Hour, .Minute] , fromDate: date)
                    let normalizedDate = calendar.dateFromComponents(dateComponents)
                    cell.datePicker?.date = normalizedDate ?? NSDate()
                }
            }
        case (0, 14):
            if let cell = cell as? NotesCell {
                cell.textView.userInteractionEnabled = self.editing

                cell.textView?.delegate = self
                cell.titleLabel.text = "Installation Details"
                cell.textView.text = detailComponentItem?.installationDetails
            }
        case (0, 15):
            if let cell = cell as? NotesCell {
                cell.textView.userInteractionEnabled = self.editing
                
                cell.textView?.delegate = self
                cell.titleLabel.text = "Wiring Notes"
                cell.textView.text = detailComponentItem?.wiringNotes
            }
 
        case (0, 16):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing
                
                cell.textField?.delegate = self
                cell.textField.text = detailComponentItem?.installationLocation
                cell.titleLabel.text = "Location"
            }

        case (0, 17):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                cell.textField?.keyboardType = .DecimalPad
                cell.textField?.delegate = self
                
                let numberFormatter = NSNumberFormatter()
                numberFormatter.minimumFractionDigits = 6

                if let latitudeNumber = detailComponentItem?.latitude {
                    cell.textField.text = numberFormatter.stringFromNumber(latitudeNumber)
                }
                
                if detailComponentItem?.latitude == nil || detailComponentItem?.latitude?.integerValue == 0 {
                    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    if let locationManager = appDelegate.locationManager, location = locationManager.location {
                        let latitude = location.coordinate.latitude
                        cell.textField.text = numberFormatter.stringFromNumber(latitude)
                    }
                }
                else {
                    cell.textField.text = nil
                }
                
                cell.titleLabel.text = "Latitude"
                
            }
        case (0, 18):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                cell.textField?.keyboardType = .DecimalPad
                cell.textField?.delegate = self
                
                let numberFormatter = NSNumberFormatter()
                numberFormatter.minimumFractionDigits = 6

                if let longitudeNumber = detailComponentItem?.longitude {
                    cell.textField.text = numberFormatter.stringFromNumber(longitudeNumber)
                }
                
                if detailComponentItem?.longitude == nil || detailComponentItem?.longitude?.integerValue == 0 {
                    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    if let locationManager = appDelegate.locationManager, location = locationManager.location {
                        let longitude = location.coordinate.longitude
                        cell.textField.text = numberFormatter.stringFromNumber(longitude)
                    }
                }
                else {
                    cell.textField.text = nil
                }
                
                cell.titleLabel.text = "Longitude"
            }
        case (0, 19):
            if let cell = cell as? DateDisplayCell {
                
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
        case (0, 20):
            if let cell = cell as? SegmentedControlCell, selectedIndex = detailComponentItem?.calibrationStatus?.integerValue {
                cell.segmentedControl.selectedSegmentIndex = selectedIndex
            }
        case (0, 21):
            if let cell = cell as? DatePickerCell {
                cell.datePicker.userInteractionEnabled = self.editing

                cell.datePicker?.datePickerMode = .Date
                cell.datePicker?.addTarget(self, action: "dateValueChanged:", forControlEvents: .ValueChanged)
                
                if let date = detailComponentItem?.lastCalibratedDate {
                    let calendar = NSCalendar.currentCalendar()
                    let dateComponents = calendar.components([.Year, .Month, .Day], fromDate: date)
                    let normalizedDate = calendar.dateFromComponents(dateComponents)
                    cell.datePicker?.date = normalizedDate ?? NSDate()
                }
            }
        case (0, 22):
            if let cell = cell as? DatePickerCell {
                cell.datePicker.userInteractionEnabled = self.editing
                
                cell.datePicker?.datePickerMode = .Time
                cell.datePicker?.addTarget(self, action: "dateValueChanged:", forControlEvents: .ValueChanged)
                
                if let date = detailComponentItem?.lastCalibratedDate {
                    let calendar = NSCalendar.currentCalendar()
                    let dateComponents = calendar.components([.Hour, .Minute] , fromDate: date)
                    let normalizedDate = calendar.dateFromComponents(dateComponents)
                    cell.datePicker?.date = normalizedDate ?? NSDate()
                }
            }
        case (0, 23):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                cell.textField?.delegate = self
                cell.textField?.text = detailComponentItem?.dataInterval
                cell.titleLabel.text = "Interval"
            }
        case (0, 24):
            if let cell = cell as? NotesCell {
                cell.textView.userInteractionEnabled = self.editing

                cell.textView?.delegate = self
                cell.titleLabel.text = "Data Stream Details"
                cell.textView?.text = detailComponentItem?.dataStreamDetails
            }
        case (0, 25):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                cell.textField?.delegate = self
                cell.textField?.text = detailComponentItem?.measurementProperty
                cell.titleLabel.text = "Measurement"
            }
        case (0, 26):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                cell.textField?.delegate = self
                
                let numberFormatter = NSNumberFormatter()
                
                if let minimum = detailComponentItem?.minimumOperatingRange {
                    cell.textField?.text = numberFormatter.stringFromNumber(minimum)
                }
                
                cell.titleLabel.text = "Min Range"
            }
        case (0, 27):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                cell.textField?.delegate = self
                
                let numberFormatter = NSNumberFormatter()
                
                if let maximum = detailComponentItem?.maximumOperatingRange {
                    cell.textField?.text = numberFormatter.stringFromNumber(maximum)
                }
                
                cell.titleLabel.text = "Max Range"
            }
        case (0, 28):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                cell.textField?.delegate = self
                
                let numberFormatter = NSNumberFormatter()
                
                if let minimum = detailComponentItem?.minimumAccuracyBound {
                    cell.textField?.text = numberFormatter.stringFromNumber(minimum)
                }
                
                cell.titleLabel.text = "Min Accuracy"
            }
        case (0, 29):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                cell.textField?.delegate = self
                
                let numberFormatter = NSNumberFormatter()
                
                if let maximum = detailComponentItem?.maximumAccuracyBound {
                    cell.textField?.text = numberFormatter.stringFromNumber(maximum)
                }
                
                cell.titleLabel.text = "Max Accuracy"
            }
        case (0, 30):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                cell.textField?.delegate = self
                cell.textField?.text = detailComponentItem?.parentLogger
                cell.titleLabel.text = "Parent Logger"
            }

            
        default:
            print("mode \(displayMode.rawValue) row \(indexPath.row)")
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if let contentView = textField.superview, tableViewCell = contentView.superview, indexPath = tableView.indexPathForCell(tableViewCell as! UITableViewCell) {
            let tableItem = tableItems[indexPath.row]
            
            if tableItem.valueType == "number" {
                let numberFormatter = NSNumberFormatter()
                detailComponentItem?.setValue(numberFormatter.numberFromString(textField.text ?? ""), forKey: tableItem.propertyName)
            }
            else if tableItem.valueType == "text" {
                detailComponentItem?.setValue(textField.text ?? "", forKey: tableItem.propertyName)
            }
        }
        
        return true
    }
    
    func dateValueChanged(sender: UIDatePicker) {
        if let contentView = sender.superview, tableViewCell = contentView.superview, indexPath = tableView.indexPathForCell(tableViewCell as! UITableViewCell) {
            switch (indexPath.row) {
            case 12:
                yearAndDayInstallationDate = sender.date
            case 13:
                timeInstallationDate = sender.date
            case 21:
                yearAndDayLastCalibratedDate = sender.date
            case 22:
                timeLastCalibratedDate = sender.date
            default:
                break
            }
        }
        
        let calendar = NSCalendar.currentCalendar()
        if let yearDate = yearAndDayInstallationDate, timeDate = timeInstallationDate {
            let yearDateComponents = calendar.components([.Year, .Month, .Day], fromDate: yearDate)
            let timeDateComponents = calendar.components([.Hour, .Minute], fromDate: timeDate)
            yearDateComponents.hour = timeDateComponents.hour
            yearDateComponents.minute = timeDateComponents.minute
            
            detailComponentItem?.installationDate = calendar.dateFromComponents(yearDateComponents)
            tableView.reloadData()
        }
        if let yearDate = yearAndDayLastCalibratedDate, timeDate = timeLastCalibratedDate {
            let yearDateComponents = calendar.components([.Year, .Month, .Day], fromDate: yearDate)
            let timeDateComponents = calendar.components([.Hour, .Minute], fromDate: timeDate)
            yearDateComponents.hour = timeDateComponents.hour
            yearDateComponents.minute = timeDateComponents.minute
            
            detailComponentItem?.lastCalibratedDate = calendar.dateFromComponents(yearDateComponents)
            tableView.reloadData()
        }
    }



// MARK: UITextViewDelegate

    func textViewDidChange(textView: UITextView) {
        
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if let contentView = textView.superview, tableViewCell = contentView.superview, indexPath = tableView.indexPathForCell(tableViewCell as! UITableViewCell) {
            let propertyName = tableItems[indexPath.row].propertyName
            detailComponentItem?.setValue(textView.text, forKey: propertyName)
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
            if let _ = segue.destinationViewController as? ComponentsViewController {

            }
        }
    }

    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
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
        if self.detailComponentItem?.photo != nil {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let photoDetailViewController = mainStoryboard.instantiateViewControllerWithIdentifier("PhotoDetailViewController") as! PhotoDetailViewController
            photoDetailViewController.photoImage = self.detailComponentItem?.photo
            
            var viewController: UIViewController?
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                viewController = photoDetailViewController
            }
            else {
                viewController = UINavigationController(rootViewController: photoDetailViewController)
            }
            
            viewController!.modalPresentationStyle = .Popover
            presentViewController(viewController!, animated: true, completion: { () -> Void in })
            
            if let popoverPresentationController = viewController!.popoverPresentationController {
                popoverPresentationController.sourceView = sender.view
                popoverPresentationController.sourceRect = sender.view!.bounds
                popoverPresentationController.permittedArrowDirections = .Any
            }
            
            return;
        }
        
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.modalPresentationStyle = .Popover
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        }
        else {
            imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        self.presentViewController(imagePickerController, animated: true) { () -> Void in }
        if let popoverPresentationController = imagePickerController.popoverPresentationController {
            popoverPresentationController.sourceView = sender.view
            popoverPresentationController.sourceRect = sender.view!.bounds
            popoverPresentationController.permittedArrowDirections = .Any
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
