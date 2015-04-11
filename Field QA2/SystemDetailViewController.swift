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
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    
    weak var datePicker: UIDatePicker? = nil
    weak var dateLabel: UILabel? = nil
    
    var installationDate : NSDate?
    
    var yearAndDayInstallationDate: NSDate?
    var timeInstallationDate: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillChangeFrameNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            let viewHeight = self.view.bounds.size.height
            let userInfo = notification.userInfo as NSDictionary!
            let keyboardValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
            let keyboardRect = keyboardValue.CGRectValue()
            let keyboardHeight = keyboardRect.size.height
            
        }
        
        let addSystemBarButton = UIBarButtonItem(title: "+ Component", style: UIBarButtonItemStyle.Plain, target: self, action: "addComponentToSystem:")
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
            return detailSystemItem?.components.count > 0 ? "Components" : nil
        case 2:
            return detailSystemItem?.serviceEntries.count > 0 ? "Service Entries" : nil
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
            
            // Save the context.
            var error: NSError? = nil
            if context.save(&error) == false {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //println("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
    }
    
    func addComponentToSystem(sender: UIBarButtonItem) {
        if let context = detailSystemItem?.managedObjectContext {
            let newComponent = NSEntityDescription.insertNewObjectForEntityForName("Component", inManagedObjectContext: context) as! Component
            newComponent.system = detailSystemItem
            newComponent.newlyCreated = true
            
            // Save the context.
            var error: NSError? = nil
            if context.save(&error) == false {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //println("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
            self.performSegueWithIdentifier("SystemDetailToComponentDetail", sender: newComponent)
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
        
        if let installationDate = self.installationDate {
            detailSystemItem!.installationDate = installationDate
        }
        else {
            detailSystemItem!.installationDate = nil
        }
        
        var error : NSError?
        self.detailSystemItem?.managedObjectContext!.save(&error)
    }
    // >>>
    
    /*
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var installationDateButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!

    */
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch(indexPath.section, indexPath.row) {
        case (0, 0):
            return 52.0
        case (0, 1):
            return 162.0
        case(0, 6...7):
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
            return 8
        case 1:
            if let components = detailSystemItem?.components {
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
        case (0, 2...4):
            cellIdentifier = "TextFieldCell"
        case (0, 1):
            cellIdentifier = "NotesCell"
        case (0, 5):
            cellIdentifier = "DateDisplayCell"
        case (0, 6...7):
            cellIdentifier = "DatePickerCell"
        default:
            cellIdentifier = "Cell"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier!, forIndexPath: indexPath) as! UITableViewCell
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
            if let cell: TextFieldCell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                latitudeTextField = cell.textField
                latitudeTextField?.keyboardType = .DecimalPad
                latitudeTextField?.delegate = self
                cell.titleLabel.text = "Latitude"
                
                let numberFormatter = NSNumberFormatter()
                numberFormatter.minimumFractionDigits = 6

                if let latitude = detailSystemItem?.latitude {
                    cell.textField.text = numberFormatter.stringFromNumber(latitude)
                }
                else {
                    cell.textField.text = nil
                }
            }
        case (0, 4):
            if let cell: TextFieldCell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing

                longitudeTextField = cell.textField
                longitudeTextField?.keyboardType = .DecimalPad
                longitudeTextField?.delegate = self
                cell.titleLabel.text = "Longitude"
                
                let numberFormatter = NSNumberFormatter()
                numberFormatter.minimumFractionDigits = 6
                if let longitude = detailSystemItem?.longitude {
                    cell.textField.text = numberFormatter.stringFromNumber(longitude)
                }
                else {
                    cell.textField.text = nil
                }
                
            }
        case (0, 5):
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
        case (0, 6):
            if let cell = cell as? DatePickerCell {
                cell.datePicker.userInteractionEnabled = self.editing
                
                
                datePicker = cell.datePicker
                datePicker?.datePickerMode = .Date
                datePicker?.addTarget(self, action: "dateValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
                datePicker?.tag = 1
                
                if let date = detailSystemItem?.installationDate {
                    let calendar = NSCalendar.currentCalendar()
                    let dateComponents = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: date)
                    let normalizedDate = calendar.dateFromComponents(dateComponents)
                    datePicker?.date = normalizedDate ?? NSDate()
                }
                
            }
        case (0, 7):
            if let cell = cell as? DatePickerCell {
                cell.datePicker.userInteractionEnabled = self.editing
                
                datePicker = cell.datePicker
                datePicker?.datePickerMode = .Time
                datePicker?.addTarget(self, action: "dateValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
                datePicker?.tag = 2
                
                if let date = detailSystemItem?.installationDate {
                    let calendar = NSCalendar.currentCalendar()
                    let dateComponents = calendar.components(.CalendarUnitHour | .CalendarUnitMinute , fromDate: date)
                    let normalizedDate = calendar.dateFromComponents(dateComponents)
                    datePicker?.date = normalizedDate ?? NSDate()
                }
            }
        case (1, _):
            let components = sortedComponentsForSystem(detailSystemItem)
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
            println("")
        }
        
    }
    
    func sortedComponentsForSystem(system: System?) -> [AnyObject] {
        if let system = system {
            let components = system.components
            let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
            let sortedComponents = NSArray(array:components.allObjects).sortedArrayUsingDescriptors([sortDescriptor])
            return sortedComponents
        }
        return [Component]()
    }
    
    func sortedServiceEntriesForSystem(system: System?) -> [AnyObject] {
        if let system = system {
            let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
            let sortedServiceEntries = NSArray(array: system.serviceEntries.allObjects).sortedArrayUsingDescriptors([sortDescriptor])
            return sortedServiceEntries
        }
        return [ServiceEntry]()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 {
            
        }
        else if indexPath.section == 1 {
            if let context = detailSystemItem?.managedObjectContext {
                let components = sortedComponentsForSystem(detailSystemItem)
                let selectedComponent = components[indexPath.row] as? Component
                self.performSegueWithIdentifier("SystemDetailToComponentDetail", sender: selectedComponent)
            }
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
            detailSystemItem?.name = textField.text
        }
        
        if textField == locationTextField {
            detailSystemItem?.installationLocation = textField.text
        }
        
        if textField == latitudeTextField {
            let numberFormatter = NSNumberFormatter()
            detailSystemItem?.latitude = numberFormatter.numberFromString(textField.text)
        }
        
        if textField == longitudeTextField {
            let numberFormatter = NSNumberFormatter()
            detailSystemItem?.longitude = numberFormatter.numberFromString(textField.text)
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
                let yearDateComponents = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: yearDate)
                let timeDateComponents = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: timeDate)
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

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
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
        
        
        var imagePickerController = UIImagePickerController()
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
