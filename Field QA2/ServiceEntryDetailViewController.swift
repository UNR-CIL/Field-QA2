//
//  ServiceEntryDetailViewController.swift
//  Field QA2
//
//  Created by John Jusayan on 9/16/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import UIKit

class ServiceEntryDetailViewController: UITableViewController, UIPopoverControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    var detailServiceEntryItem : ServiceEntry? {
        didSet {
            // Set date properties here
            self.configureView()
        }
    }
    
    var datePopoverController: UIPopoverController?
    var associatedEntityPopoverController: UIPopoverController?
    var cameraPopoverController: UIPopoverController?
    
    var image: UIImage?
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var operationTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var associatedEntityButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var date: NSDate?

    
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
    
    @IBAction func dateButtonTapped(sender: AnyObject) {
        let datePickerStoryboard = UIStoryboard(name: "DatePicker", bundle: nil)
        let datePickerViewController = datePickerStoryboard.instantiateViewControllerWithIdentifier("DatePickerViewController") as DatePickerViewController
        self.datePopoverController = UIPopoverController(contentViewController: datePickerViewController)
        
        self.datePopoverController!.delegate = self
        self.datePopoverController!.presentPopoverFromRect(dateButton.bounds, inView: dateButton, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
    }
    
    func popoverControllerShouldDismissPopover(popoverController: UIPopoverController) -> Bool {
        if popoverController == self.datePopoverController {
            let datePickerViewController = popoverController.contentViewController as DatePickerViewController
            date = datePickerViewController.datePicker.date
            self.updateDateButtonTitle()
        }
        else if popoverController == self.associatedEntityPopoverController {
            
        }
        return true
    }
    
    @IBAction func saveBarButtonTapped(sender: AnyObject) {
        if let operation = operationTextField.text {
            detailServiceEntryItem!.operation = operation
        }
        else {
            detailServiceEntryItem!.operation = nil
        }
        if let notes = self.notesTextView.text {
            detailServiceEntryItem!.notes = notes
        }
        else {
            detailServiceEntryItem!.notes = nil
        }

        var error : NSError?
        self.detailServiceEntryItem?.managedObjectContext!.save(&error)
    }
    
    func configureView() {
        if let operation = detailServiceEntryItem!.operation {
            operationTextField?.text = operation
        }
        else {
            operationTextField?.text = nil
        }
        if let image = detailServiceEntryItem!.photo {
            self.imageView?.image = image as UIImage
        }
        else {
            self.imageView?.image = nil
        }
        if let notes = detailServiceEntryItem!.notes {
            notesTextView?.text = notes
        }
        else {
            notesTextView?.text = nil
        }
        
        self.updateDateButtonTitle()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateDateButtonTitle() {
        if let date = self.date {
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = .ShortStyle
            dateFormatter.dateStyle = .MediumStyle
            
            self.dateButton?.setTitle(dateFormatter.stringFromDate(date), forState: .Normal)
        }
        else {
            self.dateButton?.setTitle("Installation Date", forState: .Normal)
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
        self.detailServiceEntryItem?.photo = image
        
        self.imageView.image = self.detailServiceEntryItem?.photo
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
}
