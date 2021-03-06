//
//  ServiceEntryDetailViewController.swift
//  Field QA2
//
//  Created by John Jusayan on 9/16/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import UIKit
import CoreData

class ServiceEntryDetailViewController: UITableViewController, UIPopoverControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    var detailServiceEntryItem : ServiceEntry? {
        didSet {
            // Set date properties here
            self.configureView()
        }
    }
    
    var presentedAsFormStyle = false
    
    var datePopoverController: UIPopoverController?
    var associatedEntityPopoverController: UIPopoverController?

    var image: UIImage?
    weak var imageView: UIImageView!
    weak var nameTextField: UITextField?
    weak var operationTextField: UITextField?
    weak var notesTextView: UITextView?


    var date: NSDate?
    var yearServiceDate: NSDate?
    var timeServiceDate: NSDate?
    
    var dateLabel: UILabel?
    var yearDatePicker: UIDatePicker?
    var timeDatePicker: UIDatePicker?
    

    var creationDate: NSDate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillChangeFrameNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            let _ = self.view.bounds.size.height
            let userInfo = notification.userInfo as NSDictionary!
            let keyboardValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
            let keyboardRect = keyboardValue.CGRectValue()
            let _ = keyboardRect.size.height
            
        }
        
        if presentedAsFormStyle {
            let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(ServiceEntryDetailViewController.done(_:)))
            self.navigationItem.rightBarButtonItem = doneBarButtonItem
        }
        
        if detailServiceEntryItem?.newlyCreated == true {
            self.setEditing(true, animated: false)

            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if let currentUser = appDelegate.currentUser, firstName = currentUser.firstName, lastName = currentUser.lastName {
                detailServiceEntryItem?.name = firstName + " " + lastName
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
            return "Service Entry Details"
        default:
            return nil
        }
    }
    
    func done(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func popoverControllerShouldDismissPopover(popoverController: UIPopoverController) -> Bool {
        if popoverController == self.datePopoverController {
            let datePickerViewController = popoverController.contentViewController as! DatePickerViewController
            date = datePickerViewController.datePicker.date
        }
        else if popoverController == self.associatedEntityPopoverController {
            
        }
        return true
    }
    
    @IBAction func saveBarButtonTapped(sender: AnyObject) {
        if let operation = operationTextField?.text {
            detailServiceEntryItem!.operation = operation
        }
        else {
            detailServiceEntryItem!.operation = nil
        }
        if let notes = self.notesTextView?.text {
            detailServiceEntryItem!.notes = notes
        }
        else {
            detailServiceEntryItem!.notes = nil
        }

        do {
            try self.detailServiceEntryItem?.managedObjectContext!.save()
        } catch _ as NSError {
        }
    }
    
    func configureView() {

        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.detailServiceEntryItem?.photo = image
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            return 52.0
        case (0, 2), (0, 4), (0, 5):
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
        return 6
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellIdentifier: String? = nil
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cellIdentifier = "PhotoTextFieldCell"
        case (0, 2):
            cellIdentifier = "NotesCell"
        case (0, 3):
            cellIdentifier = "DateDisplayCell"
        case (0, 4...5):
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
                cell.textField.text = detailServiceEntryItem?.name
                
                cell.photoImageView?.layer.borderColor = UIColor.lightGrayColor().CGColor
                cell.photoImageView?.layer.borderWidth = 1.0
                cell.photoImageView?.layer.cornerRadius = 20
                cell.photoImageView?.layer.masksToBounds = true
                
                if let photo = detailServiceEntryItem?.photo {
                    cell.photoImageView?.image = photo
                }
                else {
                    cell.photoImageView?.image = nil
                }
            }
        case (0, 1):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                operationTextField = cell.textField
                operationTextField?.delegate = self
                cell.textField.text = detailServiceEntryItem?.operation
                cell.titleLabel.text = "Operation"
            }
        case (0, 2):
            if let cell = cell as? NotesCell {
                cell.textView.userInteractionEnabled = self.editing

                notesTextView = cell.textView
                notesTextView?.delegate = self
                cell.textView.text = detailServiceEntryItem?.notes
            }
        case (0, 3):
            if let cell = cell as? DateDisplayCell {
                dateLabel = cell.detailLabel
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.timeStyle = .MediumStyle
                dateFormatter.dateStyle = .MediumStyle
                cell.titleLabel.text = "Service Date"
                
                if let date = detailServiceEntryItem?.date {
                    cell.detailLabel.text = dateFormatter.stringFromDate(date)
                }
                else {
                    cell.detailLabel.text = ""
                }
            }
        case (0, 4):
            if let cell = cell as? DatePickerCell {
                cell.datePicker.userInteractionEnabled = self.editing
                
                
                yearDatePicker = cell.datePicker
                yearDatePicker?.datePickerMode = .Date
                yearDatePicker?.addTarget(self, action: #selector(ServiceEntryDetailViewController.dateValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
                
                if let date = detailServiceEntryItem?.date {
                    let calendar = NSCalendar.currentCalendar()
                    let dateComponents = calendar.components([.Year, .Month, .Day], fromDate: date)
                    let normalizedDate = calendar.dateFromComponents(dateComponents)
                    yearDatePicker?.date = normalizedDate ?? NSDate()
                }
                
            }
        case (0, 5):
            if let cell = cell as? DatePickerCell {
                cell.datePicker.userInteractionEnabled = self.editing
                
                timeDatePicker = cell.datePicker
                timeDatePicker?.datePickerMode = .Time
                timeDatePicker?.addTarget(self, action: #selector(ServiceEntryDetailViewController.dateValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
                
                if let date = detailServiceEntryItem?.date {
                    let calendar = NSCalendar.currentCalendar()
                    let dateComponents = calendar.components([.Hour, .Minute] , fromDate: date)
                    let normalizedDate = calendar.dateFromComponents(dateComponents)
                    timeDatePicker?.date = normalizedDate ?? NSDate()
                }
            }
        default:
            print("Default")
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if textField == nameTextField {
            detailServiceEntryItem?.name = textField.text
        }
        if textField ==  operationTextField {
            detailServiceEntryItem?.operation = textField.text
        }

        return true
    }
    
    func dateValueChanged(sender: UIDatePicker) {
        if sender == yearDatePicker {
            yearServiceDate = yearDatePicker!.date
        }
        else if sender == timeDatePicker {
            timeServiceDate = timeDatePicker!.date
        }
        
        let calendar = NSCalendar.currentCalendar()
        if let yearDate = yearServiceDate {
            if let timeDate = timeServiceDate {
                let yearDateComponents = calendar.components([.Year, .Month, .Day], fromDate: yearDate)
                let timeDateComponents = calendar.components([.Hour, .Minute], fromDate: timeDate)
                yearDateComponents.hour = timeDateComponents.hour
                yearDateComponents.minute = timeDateComponents.minute
                
                detailServiceEntryItem?.date = calendar.dateFromComponents(yearDateComponents)
                tableView.reloadData()
            }
        }
    }
    
    
    // MARK: UITextViewDelegate
    
    func textViewDidChange(textView: UITextView) {
        
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if textView == notesTextView {
            detailServiceEntryItem?.notes = textView.text
        }
        
        return true
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        
    }
    
    @IBAction func photoImageViewTapped(sender: UITapGestureRecognizer) {
        NSLog("Tapped!")
        if self.detailServiceEntryItem?.photo != nil {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let photoDetailViewController = mainStoryboard.instantiateViewControllerWithIdentifier("PhotoDetailViewController") as! PhotoDetailViewController
            photoDetailViewController.photoImage = self.detailServiceEntryItem?.photo
            
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
