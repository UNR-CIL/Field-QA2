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
    var cameraPopoverController: UIPopoverController?

    var image: UIImage?
    weak var imageView: UIImageView!
    //    @NSManaged var photo: UIImage?
    
    weak var nameTextField: UITextField?
    //    @NSManaged var name: String?
    
    weak var operationTextField: UITextField?
    //    @NSManaged var operation: String?
    
    weak var notesTextView: UITextView?
    //    @NSManaged var notes: String?


    var date: NSDate?
    var dateLabel: UILabel?
    var datePicker: UIDatePicker?
    //    @NSManaged var date: NSDate?

    var creationDate: NSDate?
    //    var creationDatePicker: NSDate?
    //    @NSManaged var creationDate: NSDate?
    //    @NSManaged var creator: Person?
    //    @NSManaged var documents: NSSet

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillChangeFrameNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            let viewHeight = self.view.bounds.size.height
            let userInfo = notification.userInfo as NSDictionary!
            let keyboardValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as NSValue
            let keyboardRect = keyboardValue.CGRectValue()
            let keyboardHeight = keyboardRect.size.height
            
        }
        
        if presentedAsFormStyle {
            let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done:")
            self.navigationItem.rightBarButtonItem = doneBarButtonItem
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
            let datePickerViewController = popoverController.contentViewController as DatePickerViewController
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

        var error : NSError?
        self.detailServiceEntryItem?.managedObjectContext!.save(&error)
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
        self.detailServiceEntryItem?.photo = image
        
        self.imageView.image = self.detailServiceEntryItem?.photo
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    /*
    0 weak var nameTextField: UITextField?
    //    @NSManaged var name: String?
    
    1 weak var operationTextField: UITextField?
    //    @NSManaged var operation: String?
    
    2 weak var notesTextView: UITextView?
    //    @NSManaged var notes: String?
    
    3
    var date: NSDate?
    4 var datePicker: UIDatePicker?
    //    @NSManaged var date: NSDate?
    
    var creationDate: NSDate?
    //    var creationDatePicker: NSDate?
    //    @NSManaged var creationDate: NSDate?
    //    @NSManaged var creator: Person?
    //    @NSManaged var documents: NSSet

*/
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            return 52.0
        case (0, 2), (0, 4):
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
        return 5
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
        case (0, 4):
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
                nameTextField = cell.textField
                nameTextField?.delegate = self
                cell.titleLabel.text = "Name"
                cell.textField.text = detailServiceEntryItem?.name
                
                cell.photoImageView?.layer.borderColor = UIColor.lightGrayColor().CGColor
                cell.photoImageView?.layer.borderWidth = 1.0
                cell.photoImageView?.layer.cornerRadius = 20
                
                if let photo = detailServiceEntryItem?.photo {
                    cell.photoImageView?.image = photo
                }
                else {
                    cell.photoImageView?.image = nil
                }
            }
        case (0, 1):
            if let cell = cell as? TextFieldCell {
                operationTextField = cell.textField
                operationTextField?.delegate = self
                cell.textField.text = detailServiceEntryItem?.operation
                cell.titleLabel.text = "Operation"
            }
        case (0, 2):
            if let cell = cell as? NotesCell {
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
                cell.titleLabel.text = "Installation Date"
                
                if let date = detailServiceEntryItem?.date {
                    cell.detailLabel.text = dateFormatter.stringFromDate(date)
                }
                else {
                    cell.detailLabel.text = ""
                }
            }
        case (0, 4):
            if let cell = cell as? DatePickerCell {
                datePicker = cell.datePicker
                datePicker?.addTarget(self, action: "dateValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
            }
        default:
            println("Default")
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
        if sender == self.datePicker {
            detailServiceEntryItem?.date = sender.date
            
            
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 3, inSection: 0)], withRowAnimation: .None)
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
    
    @IBAction func photoImageViewTapped(sender: AnyObject) {
        NSLog("Tapped!")
        
    }

}
