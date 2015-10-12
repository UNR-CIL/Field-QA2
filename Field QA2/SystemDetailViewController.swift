//
//  SystemsDetailViewController.swift
//  Field QA2
//
//  Created by John Jusayan on 8/18/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import UIKit
import CoreData

class SystemDetailViewController: UITableViewController, UIPopoverControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    var detailSystemItem : System? {
        didSet {
            self.installationDate = detailSystemItem?.installationDate
            self.configureView()
        }
    }
    var datePopoverController : UIPopoverController?
    var componentsPopoverController : UIPopoverController?
    
    var image: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var installationDateButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var locationTextField: UITextField!
    
    weak var datePicker: UIDatePicker? = nil
    weak var dateLabel: UILabel? = nil
    
    var installationDate : NSDate?
    
    var yearAndDayInstallationDate: NSDate?
    var timeInstallationDate: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillChangeFrameNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            _ = self.view.bounds.size.height
            let userInfo = notification.userInfo as NSDictionary!
            let keyboardValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
            let keyboardRect = keyboardValue.CGRectValue()
            _ = keyboardRect.size.height
            
        }
        
        let addSystemBarButton = UIBarButtonItem(title: "+ Component", style: UIBarButtonItemStyle.Plain, target: self, action: "addDeploymentToSystem:")
        let addServiceEntryBarButton = UIBarButtonItem(title: "+ Service Entry", style: .Plain, target: self, action: "addServiceEntryToSystem:")
        navigationItem.rightBarButtonItems = [addSystemBarButton, addServiceEntryBarButton]
        
        if detailSystemItem?.newlyCreated == true {
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
            return "System Details"
        case 1:
            return detailSystemItem?.deployments?.count > 0 ? "Deployments" : nil
        case 2:
            return detailSystemItem?.serviceEntries?.count > 0 ? "Service Entries" : nil
        default:
            return nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addServiceEntryToSystem(sender: UIBarButtonItem) {
        if let context = detailSystemItem?.managedObjectContext {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let serviceEntryDetailViewController = storyboard.instantiateViewControllerWithIdentifier("ServiceEntryDetailViewController") as! ServiceEntryDetailViewController
            serviceEntryDetailViewController.presentedAsFormStyle = true
            
            let navigationController = UINavigationController(rootViewController: serviceEntryDetailViewController)
            navigationController.modalPresentationStyle = .FormSheet
            self.presentViewController(navigationController, animated: true, completion: nil)
            
            let newServiceEntry = NSEntityDescription.insertNewObjectForEntityForName("ServiceEntry", inManagedObjectContext: context) as! ServiceEntry
            newServiceEntry.system = detailSystemItem
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
    
    func addDeploymentToSystem(sender: UIBarButtonItem) {
        if let context = detailSystemItem?.managedObjectContext {
            let newDeployment = NSEntityDescription.insertNewObjectForEntityForName("Deployment", inManagedObjectContext: context) as! Deployment
            newDeployment.system = detailSystemItem
            newDeployment.newlyCreated = true
            
            do {
                try context.save()
            }
            catch {
                abort()
            }
            self.performSegueWithIdentifier("SystemDetailToComponentDetail", sender: newDeployment)
        }
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if (segue.identifier == "SystemDetailToComponentDetail") {
            if let componentDetailViewController = segue.destinationViewController as? ComponentDetailViewController {
                if let newComponent = sender as? Component {
                    componentDetailViewController.detailComponentItem = newComponent
                }
            }
        }
        else if (segue.identifier == "ComponentsViewControllerPopover") {
            if let componentsViewController = segue.destinationViewController as? ComponentsViewController {
                let predicate = NSPredicate(format: "system == %@", self.detailSystemItem!)
                componentsViewController.componentsPredicate = predicate
            }
        }
    }
    
    
    @IBAction func installationDateButtonTapped(sender: AnyObject) {
    let datePickerStoryboard = UIStoryboard(name: "DatePicker", bundle: nil)
        let datePickerViewController = datePickerStoryboard.instantiateViewControllerWithIdentifier("DatePickerViewController") as! DatePickerViewController
        self.datePopoverController = UIPopoverController(contentViewController: datePickerViewController)
        
        self.datePopoverController!.delegate = self
        self.datePopoverController!.presentPopoverFromRect(installationDateButton.bounds, inView: installationDateButton, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
    }

    func popoverControllerShouldDismissPopover(popoverController: UIPopoverController) -> Bool {
        if popoverController == self.datePopoverController {
            let datePickerViewController = popoverController.contentViewController as! DatePickerViewController
            installationDate = datePickerViewController.datePicker.date
            self.updateInstallationDateButtonTitle()
        }
        else if popoverController == self.componentsPopoverController {
            
        }
        return true
    }
    
    @IBAction func saveBarButtonTapped(sender: AnyObject) {
        if let name = self.nameTextField.text {
            detailSystemItem!.name = name
        }
        else {
            detailSystemItem!.name = nil
        }
        if let notes = self.notesTextView.text {
            detailSystemItem!.details = notes
        }
        else {
            detailSystemItem!.details = nil
        }
        if let locationDescription = self.locationTextField.text {
            detailSystemItem!.installationLocation = locationDescription
        }
        else {
            detailSystemItem!.installationLocation = nil
        }
        
        let doubleNumberFormatter = NSNumberFormatter()
        doubleNumberFormatter.numberStyle = NSNumberFormatterStyle.NoStyle
        
        // >>> TODO: Lat Lon now in components
        /*
        if let latitudeString = self.latitudeTextField.text {
            if let latitude = doubleNumberFormatter.numberFromString(latitudeString) {
                detailSystemItem!.latitude = latitude
            }
            else {
                detailSystemItem!.latitude = nil
            }

        }
        else {
            detailSystemItem!.latitude = nil
        }
        
        if let longitudeString = self.longitudeTextField.text {
            if let longitude = doubleNumberFormatter.numberFromString(longitudeString) {
                detailSystemItem!.longitude = longitude
            }
            else {
                detailSystemItem!.longitude = nil
            }
            
        }
        else {
            detailSystemItem!.longitude = nil
        }
        */
        
        if let installationDate = self.installationDate {
            detailSystemItem!.installationDate = installationDate
        }
        else {
            detailSystemItem!.installationDate = nil
        }
        
        do {
            try self.detailSystemItem?.managedObjectContext!.save()
        } catch {
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch(indexPath.section, indexPath.row) {
        case (0, 0):
            return 52.0
        case (0, 1):
            return 162.0
        case(0, 4...5):
            return 162.0
        default:
            return 44.0
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        switch (section) {
        case 0:
            return 6
        case 1:
            if let components = detailSystemItem?.deployments {
                return components.count
            }
            return 0
        case 2:
            if let serviceEntries = detailSystemItem?.serviceEntries {
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
        case (0, 0):
            cellIdentifier = "PhotoTextFieldCell"
        case (0, 1):
            cellIdentifier = "NotesCell"
        case (0, 2):
            cellIdentifier = "TextFieldCell"
        case (0, 3):
            cellIdentifier = "DateDisplayCell"
        case (0, 4...5):
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
            if let cell: TextFieldCell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing
                nameTextField = cell.textField
                nameTextField?.delegate = self
                cell.titleLabel.text = "Name"
                cell.textField.text = detailSystemItem?.name
                
                cell.photoImageView?.layer.borderColor = UIColor.lightGrayColor().CGColor
                cell.photoImageView?.layer.borderWidth = 1.0
                cell.photoImageView?.layer.cornerRadius = 20
                cell.photoImageView?.layer.masksToBounds = true
                if let photo = detailSystemItem?.photo {
                    cell.photoImageView?.image = photo
                }
                else {
                    cell.photoImageView?.image = nil
                }
            }
        case (0, 1):
            if let cell: NotesCell = cell as? NotesCell {
                cell.textView.userInteractionEnabled = self.editing

                notesTextView = cell.textView
                notesTextView?.delegate = self
                cell.textView.text = "Notes"
                cell.textView.text = detailSystemItem?.details
            }
        case (0, 2):
            if let cell: TextFieldCell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                locationTextField = cell.textField
                locationTextField?.delegate = self
                cell.titleLabel.text = "Location"
                cell.textField.text = detailSystemItem?.installationLocation
            }
        case (0, 3):
            if let cell: DateDisplayCell = cell as? DateDisplayCell {
                dateLabel = cell.detailLabel
                let dateFormatter = NSDateFormatter()
                dateFormatter.timeStyle = .MediumStyle
                dateFormatter.dateStyle = .MediumStyle
                cell.titleLabel.text = "Installation Date"
                if let date = detailSystemItem?.installationDate {
                    cell.detailLabel.text = dateFormatter.stringFromDate(date)
                }
                else {
                    cell.detailLabel.text = ""
                }
            }
        case (0, 4):
            if let cell = cell as? DatePickerCell {
                cell.datePicker.userInteractionEnabled = self.editing
                
                
                datePicker = cell.datePicker
                datePicker?.datePickerMode = .Date
                datePicker?.addTarget(self, action: "dateValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
                datePicker?.tag = 1
                
                if let date = detailSystemItem?.installationDate {
                    let calendar = NSCalendar.currentCalendar()
                    let dateComponents = calendar.components([.Year, .Month, .Day], fromDate: date)
                    let normalizedDate = calendar.dateFromComponents(dateComponents)
                    datePicker?.date = normalizedDate ?? NSDate()
                }
                
            }
        case (0, 5):
            if let cell = cell as? DatePickerCell {
                cell.datePicker.userInteractionEnabled = self.editing
                
                datePicker = cell.datePicker
                datePicker?.datePickerMode = .Time
                datePicker?.addTarget(self, action: "dateValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
                datePicker?.tag = 2
                
                if let date = detailSystemItem?.installationDate {
                    let calendar = NSCalendar.currentCalendar()
                    let dateComponents = calendar.components([.Hour, .Minute] , fromDate: date)
                    let normalizedDate = calendar.dateFromComponents(dateComponents)
                    datePicker?.date = normalizedDate ?? NSDate()
                }
            }
        case (1, _):
            let components = sortedDeploymentsForSystem(detailSystemItem)
            if components.count == 0 {
                return
            }
            else {
                let component = components[indexPath.row] as! Component
                cell.textLabel?.text = component.name
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.timeStyle = .MediumStyle
                dateFormatter.dateStyle = .MediumStyle
                if let date = component.creationDate {
                    cell.detailTextLabel?.text = dateFormatter.stringFromDate(date)
                }
                else {
                    cell.detailTextLabel?.text = ""
                }
            }
        case (2, _):
            let serviceEntries = sortedServiceEntriesForSystem(detailSystemItem)
            if serviceEntries.count == 0 {
                return
            }
            else {
                let serviceEntry = serviceEntries[indexPath.row] as! ServiceEntry
                cell.textLabel?.text = serviceEntry.name
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.timeStyle = .MediumStyle
                dateFormatter.dateStyle = .MediumStyle
                if let date = serviceEntry.creationDate {
                    cell.detailTextLabel?.text = dateFormatter.stringFromDate(date)
                }
                else {
                    cell.detailTextLabel?.text = ""
                }
            }
        default:
            print("")
        }
        
    }
    
    func sortedDeploymentsForSystem(system: System?) -> [AnyObject] {
        if let system = system {
            let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
            if let deployments = system.deployments {
                let sortedComponents = NSArray(array:deployments.allObjects).sortedArrayUsingDescriptors([sortDescriptor])
                return sortedComponents
            }
        }
        return [Component]()
    }
    
    func sortedServiceEntriesForSystem(system: System?) -> [AnyObject] {
        if let system = system {
            let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
            if let serviceEntries = system.serviceEntries {
                let sortedServiceEntries = NSArray(array: serviceEntries.allObjects).sortedArrayUsingDescriptors([sortDescriptor])
                return sortedServiceEntries
            }
        }
        return [ServiceEntry]()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 {
            
        }
        else if indexPath.section == 1 {
            if let _ = detailSystemItem?.managedObjectContext {
                let components = sortedDeploymentsForSystem(detailSystemItem)
                let selectedComponent = components[indexPath.row] as? Component
                self.performSegueWithIdentifier("SystemDetailToComponentDetail", sender: selectedComponent)
            }
        }
    }

    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print("textField ended \(textField.text)")
        
        if textField == nameTextField {
            detailSystemItem?.name = textField.text
        }
        
        if textField == locationTextField {
            detailSystemItem?.installationLocation = textField.text
        }
        

        
        return true
    }
    
    func dateValueChanged(sender: UIDatePicker) {
        if sender.tag == 1 {
            yearAndDayInstallationDate = sender.date
        }
        else {
            timeInstallationDate = sender.date
        }
        
        let calendar = NSCalendar.currentCalendar()
        if let yearDate = yearAndDayInstallationDate {
            if let timeDate = timeInstallationDate {
                let yearDateComponents = calendar.components([.Year, .Month, .Day], fromDate: yearDate)
                let timeDateComponents = calendar.components([.Hour, .Minute], fromDate: timeDate)
                yearDateComponents.hour = timeDateComponents.hour
                yearDateComponents.minute = timeDateComponents.minute
                
                detailSystemItem?.installationDate = calendar.dateFromComponents(yearDateComponents)
                tableView.reloadData()
            }
        }
    }
    
    
    // MARK: UITextViewDelegate
    
    func textViewDidChange(textView: UITextView) {
        
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if textView == notesTextView {
            detailSystemItem?.details = textView.text
        }
        return true
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        
    }

    // >>>
    
    
    
    func configureView() {
        /*
        if let name = detailSystemItem!.name {
            self.nameTextField?.text = name
        }
        else {
            self.nameTextField?.text = nil
        }
        if let image = detailSystemItem!.photo {
            self.imageView?.image = image as UIImage
        }
        else {
            self.imageView?.image = nil
        }
        
        if let notes = detailSystemItem!.details {
            self.notesTextView?.text = notes
        }
        else {
            self.notesTextView?.text = nil
        }
        if let locationDescription =  detailSystemItem!.installationLocation {
            self.locationTextField?.text = locationDescription
        }
        else {
            self.locationTextField?.text = nil
        }
        
        let doubleNumberFormatter = NSNumberFormatter()
        doubleNumberFormatter.numberStyle = NSNumberFormatterStyle.NoStyle
        
        if let latitudeNumber = detailSystemItem!.latitude {
            if let latitudeString = doubleNumberFormatter.stringFromNumber(latitudeNumber) {
                self.latitudeTextField?.text = latitudeString
            }
            else {
                self.latitudeTextField?.text = nil
            }
        }
        else {
            self.latitudeTextField?.text = nil
        }
        
        if let longitudeNumber = detailSystemItem!.longitude {
            if let longitudeString = doubleNumberFormatter.stringFromNumber(longitudeNumber) {
                self.longitudeTextField?.text = longitudeString
            }
            else {
                self.longitudeTextField?.text = nil
            }
            
        }
        else {
            self.longitudeTextField?.text = nil
        }
        
        self.updateInstallationDateButtonTitle()

*/
    }
    
    func updateInstallationDateButtonTitle() {
        if let installationDate = self.installationDate {
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = .ShortStyle
            dateFormatter.dateStyle = .MediumStyle
            
            self.installationDateButton?.setTitle(dateFormatter.stringFromDate(installationDate), forState: .Normal)
            
        }
        else {
            self.installationDateButton?.setTitle("Installation Date", forState: .Normal)
        }
    }
    
    // MARK: UIImagePickerControllerDelegate

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.detailSystemItem?.photo = image
        
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
        if self.detailSystemItem?.photo != nil {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let photoDetailViewController = mainStoryboard.instantiateViewControllerWithIdentifier("PhotoDetailViewController") as! PhotoDetailViewController
            photoDetailViewController.photoImage = self.detailSystemItem?.photo
            
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
