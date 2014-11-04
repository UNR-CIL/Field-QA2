//
//  ProjectDetailViewController.swift
//  Field QA2
//
//  Created by John Jusayan on 10/22/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import UIKit

class ProjectDetailViewController: UITableViewController, UIPopoverControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {

    enum DisplayMode: String {
        case NotShowingDatePicker = "NotShowingDatePicker"
        case ShowingDatePicker = "ShowingDatePicker"
    }
    
    var displayMode: DisplayMode = .NotShowingDatePicker
    
    var detailProjectItem : Project? {
        didSet {
            // Set date properties here
            self.configureView()
        }
    }
    
    weak var nameTextField: UITextField? = nil
    weak var fundingAgencyTextField: UITextField? = nil
    weak var grantNumberTextField: UITextField? = nil
    weak var institutionTextField: UITextField? = nil
    weak var datePicker: UIDatePicker? = nil
    weak var dateLabel: UILabel? = nil
    
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
    

    
    @IBAction func saveBarButtonTapped(sender: AnyObject) {
        /*
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
        

*/
        var error : NSError?

        self.detailProjectItem?.managedObjectContext!.save(&error)
    }
    
    func configureView() {
        /*
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
*/
        

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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let image = info[UIImagePickerControllerEditedImage] as UIImage
        /*
        self.detailServiceEntryItem?.photo = image
        
        self.imageView.image = self.detailServiceEntryItem?.photo
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void i
            
        })

*/
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    
    /*
    @NSManaged var name: String?
    @NSManaged var originalFundingAgencyName: String?
    @NSManaged var grantNumberString: String?
    @NSManaged var institutionName: String?
    @NSManaged var startedDate: NSDate?
    
    @NSManaged var principalInvestigator: Person?
    @NSManaged var do cuments: Document?
    
    */
    
    // MARK: UITableView
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if displayMode == DisplayMode.ShowingDatePicker {
            if indexPath.row == 5 {
                return 162.0
            }
        }
        return 44.0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return displayMode == .ShowingDatePicker ? 6 : 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellIdentifier: String? = nil
        
        if displayMode == .NotShowingDatePicker {
            switch indexPath.row {
            case 0...3:
                cellIdentifier = "TextFieldCell"
            case 4:
                cellIdentifier = "DateDisplayCell"
            default:
                cellIdentifier = "TextFieldCell"
            }
        }
        else {
            switch indexPath.row {
            case 0...3:
                cellIdentifier = "TextFieldCell"
            case 4:
                cellIdentifier = "DateDisplayCell"
            default:
                cellIdentifier = "DatePickerCell"
            }
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier!, forIndexPath: indexPath) as UITableViewCell
        configureCell(cell, forIndexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell: UITableViewCell, forIndexPath indexPath: NSIndexPath) {
        if displayMode == .NotShowingDatePicker {
            switch indexPath.row {
            case 0:
                if let cell: TextFieldCell = cell as? TextFieldCell {
                    nameTextField = cell.textField
                    nameTextField?.delegate = self
                    cell.titleLabel.text = "Name"
                    cell.textField.text = detailProjectItem?.name
                }
            case 1:
                if let cell: TextFieldCell = cell as? TextFieldCell {
                    fundingAgencyTextField = cell.textField
                    fundingAgencyTextField?.delegate = self
                    cell.titleLabel.text = "Funding Agency"
                    cell.textField.text = detailProjectItem?.originalFundingAgencyName
                }
            case 2:
                if let cell: TextFieldCell = cell as? TextFieldCell {
                    grantNumberTextField = cell.textField
                    grantNumberTextField?.delegate = self
                    cell.titleLabel.text = "Grant Number"
                    cell.textField.text = detailProjectItem?.grantNumberString
                }
            case 3:
                if let cell: TextFieldCell = cell as? TextFieldCell {
                    institutionTextField = cell.textField
                    institutionTextField?.delegate = self
                    cell.titleLabel.text = "Institution"
                    cell.textField.text = detailProjectItem?.institutionName
                }
            case 4:
                if let cell: DateDisplayCell = cell as? DateDisplayCell {
                    dateLabel = cell.detailLabel
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.timeStyle = .MediumStyle
                    dateFormatter.dateStyle = .MediumStyle
                    cell.titleLabel.text = "Started Date"
                    if let date = detailProjectItem?.startedDate {
                        cell.detailLabel.text = dateFormatter.stringFromDate(date)
                    }
                    else {
                        cell.detailLabel.text = ""
                    }
                }
            default:
                println("mode \(displayMode.rawValue) row \(indexPath.row)")
            }
        }
        else {
            switch indexPath.row {
            case 0:
                if let cell: TextFieldCell = cell as? TextFieldCell {
                    nameTextField = cell.textField
                    nameTextField?.delegate = self
                    cell.titleLabel.text = "Name"
                    cell.textField.text = detailProjectItem?.name
                }
            case 1:
                if let cell: TextFieldCell = cell as? TextFieldCell {
                    fundingAgencyTextField = cell.textField
                    fundingAgencyTextField?.delegate = self
                    cell.titleLabel.text = "Funding Agency"
                    cell.textField.text = detailProjectItem?.originalFundingAgencyName
                }
            case 2:
                if let cell: TextFieldCell = cell as? TextFieldCell {
                    grantNumberTextField = cell.textField
                    grantNumberTextField?.delegate = self
                    cell.titleLabel.text = "Grant Number"
                    cell.textField.text = detailProjectItem?.grantNumberString
                }
            case 3:
                if let cell: TextFieldCell = cell as? TextFieldCell {
                    institutionTextField = cell.textField
                    institutionTextField?.delegate = self
                    cell.titleLabel.text = "Institution"
                    cell.textField.text = detailProjectItem?.institutionName
                }
            case 4:
                if let cell: DateDisplayCell = cell as? DateDisplayCell {
                    dateLabel = cell.detailLabel
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.timeStyle = .MediumStyle
                    dateFormatter.dateStyle = .MediumStyle
                    cell.titleLabel.text = "Started Date"
                    if let date = detailProjectItem?.startedDate {
                        cell.detailLabel.text = dateFormatter.stringFromDate(date)
                    }
                    else {
                        cell.detailLabel.text = ""
                    }
                }
            case 5:
                if let cell: DatePickerCell = cell as? DatePickerCell {
                    datePicker = cell.datePicker
                    datePicker?.addTarget(self, action: "dateValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
                    
                }
            default:
                println("mode \(displayMode.rawValue) row \(indexPath.row)")
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if displayMode == DisplayMode.NotShowingDatePicker {
            displayMode = .ShowingDatePicker
        }
        else {
            displayMode = .NotShowingDatePicker
        }
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        println("textField ended \(textField.text)")
        
        if textField == nameTextField {
            detailProjectItem?.name = textField.text
        }
        
        if textField == fundingAgencyTextField {
            detailProjectItem?.originalFundingAgencyName = textField.text
        }
        
        if textField == grantNumberTextField {
            detailProjectItem?.grantNumberString = textField.text
        }
        
        if textField == institutionTextField {
            detailProjectItem?.institutionName = textField.text
        }
        
        return true
    }
    
    func dateValueChanged(sender: UIDatePicker) {
        detailProjectItem?.startedDate = sender.date
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    


}