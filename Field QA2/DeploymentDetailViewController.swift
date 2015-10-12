//
//  DeploymentDetailViewController.swift
//  Field QA2
//
//  Created by John Jusayan on 10/12/15.
//  Copyright © 2015 University of Nevada, Reno. All rights reserved.
//

import UIKit
import CoreData

class DeploymentDetailViewController: UITableViewController, UIPopoverControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    var detailDeploymentItem: Deployment? {
        didSet {
            self.configureView()
        }
    }

    var establishedDate: NSDate?
    var abandonedDate: NSDate?
    
    var installationDatePopoverController: UIPopoverController?
    var lastCallibrationDatePopoverController: UIPopoverController?
    var logicalDevicePopoverController: UIPopoverController?
    var serviceEntriesPopoverController: UIPopoverController?

    var yearAndDayEstablishedDate: NSDate?
    var timeEstablishedDate: NSDate?
    var yearAndDayAbandonedDate: NSDate?
    var timeAbandonedDate: NSDate?
    
    var tableItems = [
        (propertyName: "name", title: "Name", cellIdentifier: "TextFieldCell", valueType: "text"),
        (propertyName: "purpose", title: "Purpose", cellIdentifier: "NotesCell", valueType: "text"),
        (propertyName: "centerOffset", title: "Center Offset", cellIdentifier: "TextFieldCell", valueType: "number"),
        (propertyName: "heightFromGround", title: "Height", cellIdentifier: "TextFieldCell",valueType: "number"),
        (propertyName: "establishedDate", title: "Established Date", cellIdentifier: "DateDisplayCell", valueType: "date"),
        (propertyName: "establishedDate", title: "", cellIdentifier: "DatePickerCell", valueType: "date"),
        (propertyName: "establishedDate", title: "", cellIdentifier: "DatePickerCell", valueType: "date"),
        (propertyName: "installationLocation", title: "Location", cellIdentifier: "TextFieldCell", valueType: "text"),
        (propertyName: "latitude", title: "Latitude", cellIdentifier: "TextFieldCell", valueType: "number"),
        (propertyName: "longitude", title: "Longitude", cellIdentifier: "TextFieldCell", valueType: "number"),
        (propertyName: "abandonedDate", title: "Abandoned Date", cellIdentifier: "DateDisplayCell", valueType: "text"),
        (propertyName: "abandonedDate", title: "", cellIdentifier: "DatePickerCell", valueType: "date"),
        (propertyName: "abandonedDate", title: "", cellIdentifier: "DatePickerCell", valueType: "date"),
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
        }
        
        
        let addServiceEntryBarButton = UIBarButtonItem(title: "+ Service Entry", style: .Plain, target: self, action: "addServiceEntryToComponent:")
        navigationItem.rightBarButtonItems = [addServiceEntryBarButton]
        
        if detailDeploymentItem?.newlyCreated == true {
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
            return "Deployment Details"
        default:
            return nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addServiceEntryToComponent(sender: UIBarButtonItem) {
        if let context = detailDeploymentItem?.managedObjectContext {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let serviceEntryDetailViewController = storyboard.instantiateViewControllerWithIdentifier("ServiceEntryDetailViewController") as! ServiceEntryDetailViewController
            serviceEntryDetailViewController.presentedAsFormStyle = true
            
            let navigationController = UINavigationController(rootViewController: serviceEntryDetailViewController)
            navigationController.modalPresentationStyle = .FormSheet
            self.presentViewController(navigationController, animated: true, completion: nil)
            
            let newServiceEntry = NSEntityDescription.insertNewObjectForEntityForName("ServiceEntry", inManagedObjectContext: context) as! ServiceEntry
            
            
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
    
    func popoverControllerShouldDismissPopover(popoverController: UIPopoverController) -> Bool {

        return true
    }
    
    @IBAction func saveBarButtonTapped(sender: AnyObject) {
        
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (tableItems[indexPath.row].cellIdentifier) {
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
                cell.textField.text = detailDeploymentItem?.valueForKey(tableItems[0].propertyName) as! String?
            }
        case (0, 1):
            if let cell = cell as? NotesCell {
                cell.textView.userInteractionEnabled = self.editing
                
                cell.textView?.delegate = self
                cell.titleLabel.text = tableItems[1].title
                cell.textView.text = detailDeploymentItem?.valueForKey(tableItems[1].propertyName) as! String?
            }
        case (0, 2):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing
                
                cell.textField?.delegate = self
                let numberFormatter = NSNumberFormatter()
                if let offsetNumber = detailDeploymentItem?.centerOffset {
                    cell.textField.text = numberFormatter.stringFromNumber(offsetNumber)
                }
                else {
                    cell.textField.text = nil
                }
                
                cell.titleLabel.text = "Center Offset"
                cell.textField.keyboardType = UIKeyboardType.NumberPad
            }
        case (0, 3):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing
                
                cell.textField?.delegate = self
                
                let numberFormatter = NSNumberFormatter()
                if let offsetNumber = detailDeploymentItem?.heightFromGround {
                    cell.textField.text = numberFormatter.stringFromNumber(offsetNumber)
                }
                else {
                    cell.textField.text = nil
                }
                
                cell.titleLabel.text = "Height"
                cell.textField.keyboardType = UIKeyboardType.NumberPad
            }
        case (0, 4):
            if let cell = cell as? DateDisplayCell {
                let dateFormatter = NSDateFormatter()
                dateFormatter.timeStyle = .MediumStyle
                dateFormatter.dateStyle = .MediumStyle
                cell.titleLabel.text = "Established Date"
                
                if let date = detailDeploymentItem?.establishedDate {
                    cell.detailLabel.text = dateFormatter.stringFromDate(date)
                }
                else {
                    cell.detailLabel.text = ""
                }
            }
        case (0, 5):
            if let cell = cell as? DatePickerCell {
                cell.datePicker.userInteractionEnabled = self.editing
                
                cell.datePicker?.datePickerMode = .Date
                cell.datePicker?.addTarget(self, action: "dateValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
                
                if let date = detailDeploymentItem?.establishedDate {
                    let calendar = NSCalendar.currentCalendar()
                    let dateComponents = calendar.components([.Year, .Month, .Day], fromDate: date)
                    let normalizedDate = calendar.dateFromComponents(dateComponents)
                    cell.datePicker?.date = normalizedDate ?? NSDate()
                }
            }
        case (0, 6):
            if let cell = cell as? DatePickerCell {
                cell.datePicker.userInteractionEnabled = self.editing
                
                cell.datePicker?.datePickerMode = .Time
                cell.datePicker?.addTarget(self, action: "dateValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
                
                if let date = detailDeploymentItem?.establishedDate {
                    let calendar = NSCalendar.currentCalendar()
                    let dateComponents = calendar.components([.Hour, .Minute] , fromDate: date)
                    let normalizedDate = calendar.dateFromComponents(dateComponents)
                    cell.datePicker?.date = normalizedDate ?? NSDate()
                }
            }
        case (0, 7):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing
                
                cell.textField?.delegate = self
                cell.textField.text = detailDeploymentItem?.location
                cell.titleLabel.text = "Location"
            }
            
        case (0, 8):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing
                
                cell.textField?.keyboardType = .DecimalPad
                cell.textField?.delegate = self
                
                let numberFormatter = NSNumberFormatter()
                numberFormatter.minimumFractionDigits = 6
                
                if let latitudeNumber = detailDeploymentItem?.latitude {
                    cell.textField.text = numberFormatter.stringFromNumber(latitudeNumber)
                }
                
                if detailDeploymentItem?.latitude == nil || detailDeploymentItem?.latitude?.integerValue == 0 {
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
        case (0, 9):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing
                
                cell.textField?.keyboardType = .DecimalPad
                cell.textField?.delegate = self
                
                let numberFormatter = NSNumberFormatter()
                numberFormatter.minimumFractionDigits = 6
                
                if let longitudeNumber = detailDeploymentItem?.longitude {
                    cell.textField.text = numberFormatter.stringFromNumber(longitudeNumber)
                }
                
                if detailDeploymentItem?.longitude == nil || detailDeploymentItem?.longitude?.integerValue == 0 {
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
        case (0, 10):
            if let cell = cell as? DateDisplayCell {
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.timeStyle = .MediumStyle
                dateFormatter.dateStyle = .MediumStyle
                cell.titleLabel.text = "Established"

                if let date = detailDeploymentItem?.establishedDate {
                    cell.detailLabel.text = dateFormatter.stringFromDate(date)
                }
                else {
                    cell.detailLabel.text = ""
                }
            }

        case (0, 11):
            if let cell = cell as? DatePickerCell {
                cell.datePicker.userInteractionEnabled = self.editing
                
                cell.datePicker?.datePickerMode = .Date
                cell.datePicker?.addTarget(self, action: "dateValueChanged:", forControlEvents: .ValueChanged)
                
                if let date = detailDeploymentItem?.establishedDate {
                    let calendar = NSCalendar.currentCalendar()
                    let dateComponents = calendar.components([.Year, .Month, .Day], fromDate: date)
                    let normalizedDate = calendar.dateFromComponents(dateComponents)
                    cell.datePicker?.date = normalizedDate ?? NSDate()
                }
            }
        case (0, 12):
            if let cell = cell as? DatePickerCell {
                cell.datePicker.userInteractionEnabled = self.editing
                
                cell.datePicker?.datePickerMode = .Time
                cell.datePicker?.addTarget(self, action: "dateValueChanged:", forControlEvents: .ValueChanged)
                
                if let date = detailDeploymentItem?.establishedDate {
                    let calendar = NSCalendar.currentCalendar()
                    let dateComponents = calendar.components([.Hour, .Minute] , fromDate: date)
                    let normalizedDate = calendar.dateFromComponents(dateComponents)
                    cell.datePicker?.date = normalizedDate ?? NSDate()
                }
            }
        case (0, 20):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing
                
                cell.textField?.delegate = self
                cell.textField?.text = detailDeploymentItem?.parentLogger
                cell.titleLabel.text = "Parent Logger"
            }
            
        default:
            break
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
                detailDeploymentItem?.setValue(numberFormatter.numberFromString(textField.text ?? ""), forKey: tableItem.propertyName)
            }
            else if tableItem.valueType == "text" {
                detailDeploymentItem?.setValue(textField.text ?? "", forKey: tableItem.propertyName)
            }
        }
        
        return true
    }
    
    func dateValueChanged(sender: UIDatePicker) {
        if let contentView = sender.superview, tableViewCell = contentView.superview, indexPath = tableView.indexPathForCell(tableViewCell as! UITableViewCell) {
            switch (indexPath.row) {
            case 5:
                yearAndDayEstablishedDate = sender.date
            case 6:
                timeEstablishedDate = sender.date
            case 11:
                yearAndDayAbandonedDate = sender.date
            case 12:
                timeAbandonedDate = sender.date
            default:
                NSLog(">>> Wrong date picker index %i", indexPath.row)
                break
            }
        }
        
        let calendar = NSCalendar.currentCalendar()
        if let yearDate = yearAndDayEstablishedDate, timeDate = timeEstablishedDate {
            let yearDateComponents = calendar.components([.Year, .Month, .Day], fromDate: yearDate)
            let timeDateComponents = calendar.components([.Hour, .Minute], fromDate: timeDate)
            yearDateComponents.hour = timeDateComponents.hour
            yearDateComponents.minute = timeDateComponents.minute
            
            tableView.reloadData()
        }
        if let yearDate = yearAndDayAbandonedDate, timeDate = timeAbandonedDate {
            let yearDateComponents = calendar.components([.Year, .Month, .Day], fromDate: yearDate)
            let timeDateComponents = calendar.components([.Hour, .Minute], fromDate: timeDate)
            yearDateComponents.hour = timeDateComponents.hour
            yearDateComponents.minute = timeDateComponents.minute
            

            tableView.reloadData()
        }
    }
    
    
    
    // MARK: UITextViewDelegate
    
    func textViewDidChange(textView: UITextView) {
        
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if let contentView = textView.superview, tableViewCell = contentView.superview, indexPath = tableView.indexPathForCell(tableViewCell as! UITableViewCell) {
            let propertyName = tableItems[indexPath.row].propertyName
            detailDeploymentItem?.setValue(textView.text, forKey: propertyName)
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
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
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
