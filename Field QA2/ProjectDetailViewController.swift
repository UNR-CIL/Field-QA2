//
//  ProjectDetailViewController.swift
//  Field QA2
//
//  Created by John Jusayan on 10/22/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import UIKit
import CoreData

class ProjectDetailViewController: UITableViewController, UIPopoverControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {
    
    var detailProjectItem : Project? {
        didSet {
            // Set date properties here
            self.configureView()
        }
    }
    
    weak var nameTextField: UITextField?
    weak var fundingAgencyTextField: UITextField?
    weak var grantNumberTextField: UITextField?
    weak var institutionTextField: UITextField?
    weak var yearDatePicker: UIDatePicker?
    weak var timeDatePicker: UIDatePicker?
    weak var dateLabel: UILabel?
    
    var yearAndDayStartedDate: NSDate?
    var timeStartedDate: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillChangeFrameNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            _ = self.view.bounds.size.height
            let userInfo = notification.userInfo as NSDictionary!
            let keyboardValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
            let keyboardRect = keyboardValue.CGRectValue()
            _ = keyboardRect.size.height
        }
        
        let addSiteBarButton = UIBarButtonItem(title: "+Site", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ProjectDetailViewController.addSiteToProject(_:)))
        let addServiceEntryBarButton = UIBarButtonItem(title: "+SE", style: .Plain, target: self, action: #selector(ProjectDetailViewController.addServiceEntryToProject(_:)))
        navigationItem.rightBarButtonItems = [addSiteBarButton, addServiceEntryBarButton]
        
        if detailProjectItem?.newlyCreated == true {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addServiceEntryToProject(sender: UIBarButtonItem) {
        if let context = detailProjectItem?.managedObjectContext {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let serviceEntryDetailViewController = storyboard.instantiateViewControllerWithIdentifier("ServiceEntryDetailViewController") as! ServiceEntryDetailViewController
            serviceEntryDetailViewController.presentedAsFormStyle = true
            let navigationController = UINavigationController(rootViewController: serviceEntryDetailViewController)
            navigationController.modalPresentationStyle = .FormSheet
            self.presentViewController(navigationController, animated: true, completion: nil)
            
            let newServiceEntry = NSEntityDescription.insertNewObjectForEntityForName("ServiceEntry", inManagedObjectContext: context) as! ServiceEntry
            newServiceEntry.project = detailProjectItem
            newServiceEntry.projectIdentifier = detailProjectItem?.uniqueIdentifier
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
    
    func addSiteToProject(sender: UIBarButtonItem) {
        if let context = detailProjectItem?.managedObjectContext {
    
            let newSite = NSEntityDescription.insertNewObjectForEntityForName("Site", inManagedObjectContext: context) as! Site
            newSite.project = detailProjectItem
            newSite.projectIdentifier = detailProjectItem?.uniqueIdentifier
            newSite.newlyCreated = true
            
            do {
                try context.save()
            }
            catch {
                abort()
            }

            self.performSegueWithIdentifier("ProjectDetailToSiteDetail", sender: newSite)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "ProjectDetailToSiteDetail") {
            if let siteDetailViewController = segue.destinationViewController as? SiteDetailViewController {
                if let newSite = sender as? Site {
                    siteDetailViewController.detailSiteItem = newSite
                }
            }
        }
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

        do {
            try self.detailProjectItem?.managedObjectContext!.save()
        }
        catch {
        }
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        _ = info[UIImagePickerControllerEditedImage] as? UIImage
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
    
    
    // MARK: UITableView
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            return 52.0
        case (0, 5...6):
            return 162.0
        default:
            return 44.0
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (section) {
        case 0:
            return 7
        case 1:
            if let sites = detailProjectItem?.sites {
                return sites.count
            }
            return 0
        case 2:
            if let serviceEntries = detailProjectItem?.serviceEntries {
                return serviceEntries.count
            }
            return 0
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cellIdentifier: String? = nil
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0...3):
            cellIdentifier = "TextFieldCell"
        case (0, 4):
            cellIdentifier = "DateDisplayCell"
        case (0, 5...6):
            cellIdentifier = "DatePickerCell"
        default:
            cellIdentifier = "Cell"
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
                    cell.textField.text = detailProjectItem?.name
                }
            case (0, 1):
                if let cell = cell as? TextFieldCell {
                    cell.textField.userInteractionEnabled = self.editing

                    fundingAgencyTextField = cell.textField
                    fundingAgencyTextField?.delegate = self
                    cell.titleLabel.text = "Funding Agency"
                    cell.textField.text = detailProjectItem?.originalFundingAgencyName
                }
            case (0, 2):
                if let cell = cell as? TextFieldCell {
                    cell.textField.userInteractionEnabled = self.editing

                    grantNumberTextField = cell.textField
                    grantNumberTextField?.delegate = self
                    cell.titleLabel.text = "Grant Number"
                    cell.textField.text = detailProjectItem?.grantNumberString
                }
            case (0, 3):
                if let cell = cell as? TextFieldCell {
                    cell.textField.userInteractionEnabled = self.editing

                    institutionTextField = cell.textField
                    institutionTextField?.delegate = self
                    cell.titleLabel.text = "Institution"
                    cell.textField.text = detailProjectItem?.institutionName
                }
            case (0, 4):
                if let cell = cell as? DateDisplayCell {
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
            case (0, 5):
                if let cell = cell as? DatePickerCell {
                    cell.datePicker.userInteractionEnabled = self.editing


                    yearDatePicker = cell.datePicker
                    yearDatePicker?.datePickerMode = .Date
                    yearDatePicker?.addTarget(self, action: #selector(ProjectDetailViewController.dateValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
                    
                    if let date = detailProjectItem?.startedDate {
                        let calendar = NSCalendar.currentCalendar()
                        let dateComponents = calendar.components([.Year, .Month, .Day], fromDate: date)
                        let normalizedDate = calendar.dateFromComponents(dateComponents)
                        yearDatePicker?.date = normalizedDate ?? NSDate()
                    }
                    
                }
            case (0, 6):
                if let cell = cell as? DatePickerCell {
                    cell.datePicker.userInteractionEnabled = self.editing
                    
                    timeDatePicker = cell.datePicker
                    timeDatePicker?.datePickerMode = .Time
                    timeDatePicker?.addTarget(self, action: #selector(ProjectDetailViewController.dateValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
                    
                    if let date = detailProjectItem?.startedDate {
                        let calendar = NSCalendar.currentCalendar()
                        let dateComponents = calendar.components([.Hour, .Minute] , fromDate: date)
                        let normalizedDate = calendar.dateFromComponents(dateComponents)
                        timeDatePicker?.date = normalizedDate ?? NSDate()
                    }
                }
            case (1, _):
                let sites = sortedSitesForProject(detailProjectItem)
                if sites.count == 0 {
                    return
                }
                else {
                    let site = sites[indexPath.row] as! Site
                    cell.textLabel?.text = site.name ?? "A Site"
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.timeStyle = .MediumStyle
                    dateFormatter.dateStyle = .MediumStyle
                    if let date = site.creationDate {
                        cell.detailTextLabel?.text = dateFormatter.stringFromDate(date)
                    }
                    else {
                        cell.detailTextLabel?.text = "No Date"
                    }
                }
            case (2, _):
                let serviceEntries = sortedServiceEntriesForProject(detailProjectItem)
                if serviceEntries.count == 0 {
                    return
                }
                else {
                    let serviceEntry = serviceEntries[indexPath.row] as! ServiceEntry
                    cell.textLabel?.text = serviceEntry.name ?? "A Service Entry"
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.timeStyle = .MediumStyle
                    dateFormatter.dateStyle = .MediumStyle
                    if let date = serviceEntry.creationDate {
                        cell.detailTextLabel?.text = dateFormatter.stringFromDate(date)
                    }
                    else {
                        cell.detailTextLabel?.text = "No Date"
                    }
                }
            default:
                cell.textLabel?.text = "Default"
        }
    }
    
    func sortedSitesForProject(project: Project?) -> [AnyObject] {
        if let project = project {
            let sites = project.sites!
            let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
            let sortedSites = NSArray(array:sites.allObjects).sortedArrayUsingDescriptors([sortDescriptor])
            return sortedSites
        }
        return [Site]()
    }
    
    func sortedServiceEntriesForProject(project: Project?) -> [AnyObject] {
        if let project = project {
            let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
            let sortedServiceEntries = NSArray(array: project.serviceEntries!.allObjects).sortedArrayUsingDescriptors([sortDescriptor])
            return sortedServiceEntries
        }
        return [ServiceEntry]()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 {
            
        }
        else if indexPath.section == 1 {
            if let _ = detailProjectItem?.managedObjectContext {
                let sites = sortedSitesForProject(detailProjectItem)
                let selectedSite = sites[indexPath.row] as? Site
                
                self.performSegueWithIdentifier("ProjectDetailToSiteDetail", sender: selectedSite)
            }
        }
        else if indexPath.section == 2 {
            if let _ = detailProjectItem?.managedObjectContext {
                let serviceEntries = sortedServiceEntriesForProject(detailProjectItem)
                if let selectedServiceEntry = serviceEntries[indexPath.row] as? ServiceEntry {
                    presentServiceEntryDetailViewController(selectedServiceEntry)
                }
            }
            
        }
    }

    func presentServiceEntryDetailViewController(selectedItem: ServiceEntry) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let serviceEntryDetailViewController = storyboard.instantiateViewControllerWithIdentifier("ServiceEntryDetailViewController") as! ServiceEntryDetailViewController
        serviceEntryDetailViewController.presentedAsFormStyle = true

        let navigationController = UINavigationController(rootViewController: serviceEntryDetailViewController)
        navigationController.modalPresentationStyle = .FormSheet
        self.presentViewController(navigationController, animated: true, completion: nil)
        serviceEntryDetailViewController.detailServiceEntryItem = selectedItem
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Project Details"
        case 1:
            return detailProjectItem?.sites?.count > 0 ? "Sites" : nil
        case 2:
            return detailProjectItem?.serviceEntries!.count > 0 ? "Service Entries" : nil
        default:
            return nil
        }
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print("textField ended \(textField.text)")
        
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
        if sender == yearDatePicker {
            yearAndDayStartedDate = yearDatePicker!.date
        }
        else if sender == timeDatePicker {
            timeStartedDate = timeDatePicker!.date
        }
        
        let calendar = NSCalendar.currentCalendar()
        if let yearDate = yearAndDayStartedDate {
            if let timeDate = timeStartedDate {
                let yearDateComponents = calendar.components([.Year, .Month, .Day], fromDate: yearDate)
                let timeDateComponents = calendar.components([.Hour, .Minute], fromDate: timeDate)
                yearDateComponents.hour = timeDateComponents.hour
                yearDateComponents.minute = timeDateComponents.minute
                
                detailProjectItem?.startedDate = calendar.dateFromComponents(yearDateComponents)
                tableView.reloadData()
            }
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
}