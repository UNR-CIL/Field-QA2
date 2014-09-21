//
//  ServiceEntryDetailViewController.swift
//  Field QA2
//
//  Created by John Jusayan on 9/16/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import UIKit

class ServiceEntryDetailViewController: UIViewController, UIPopoverControllerDelegate {

    var detailServiceEntryItem : ServiceEntry? {
        didSet {
            // Set date properties here
            self.configureView()
        }
    }
    
    var datePopoverController: UIPopoverController?
    var associatedEntityPopoverController: UIPopoverController?
    
    @IBOutlet weak var operationTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var associatedEntityButton: UIButton!
    
    var date: NSDate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.detailServiceEntryItem?.managedObjectContext.save(&error)
    }
    
    func configureView() {
        if let operation = detailServiceEntryItem!.operation {
            operationTextField?.text = operation
        }
        else {
            operationTextField?.text = nil
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
}
