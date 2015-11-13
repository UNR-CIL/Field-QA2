//
//  SiteDetailViewController.swift
//  Field QA2
//
//  Created by John Jusayan on 10/12/15.
//  Copyright © 2015 University of Nevada, Reno. All rights reserved.
//

import UIKit
import CoreData

class SiteDetailViewController: UITableViewController, UIPopoverControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    
    var detailSiteItem : Site? {
        didSet {
            self.configureView()
        }
    }
    
    var installationDate: NSDate?
    var lastCalibratedDate: NSDate?
    
    var associatedLogicalDevice: LogicalDevice?
    
    var yearAndDayInstallationDate: NSDate?
    var timeInstallationDate: NSDate?
    var yearAndDayLastCalibratedDate: NSDate?
    var timeLastCalibratedDate: NSDate?
    
    var tableItems = [
        (propertyName: "name", title: "Name", cellIdentifier: "PhotoTextFieldCell", valueType: "text"),
        (propertyName: "gpsLandmark", title: "Landmark", cellIdentifier: "TextFieldCell", valueType: "text"),
        (propertyName: "landOwner", title: "Land Owner", cellIdentifier: "TextFieldCell", valueType: "text"),
        (propertyName: "location", title: "Location", cellIdentifier: "TextFieldCell", valueType: "text"),
        (propertyName: "notes", title: "Notes", cellIdentifier: "NotesCell", valueType: "text"),
        (propertyName: "permitHolder", title: "Permit Holder", cellIdentifier: "TextFieldCell", valueType: "text"),
        (propertyName: "timeZoneAbbreviation", title: "TZ Abbr.", cellIdentifier: "TextFieldCell", valueType: "text"),
        (propertyName: "timeZoneName", title: "TZ Name", cellIdentifier: "TextFieldCell", valueType: "text"),
        (propertyName: "timeZoneOffset", title: "TZ Offset", cellIdentifier: "TextFieldCell", valueType: "text")
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
        
        let addSystemToSite = UIBarButtonItem(title: "+System", style: .Plain, target: self, action: "addSystemToSite:")
        navigationItem.rightBarButtonItems = [addSystemToSite]
        
        if detailSiteItem?.newlyCreated == true {
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
            return "Site Details"
        case 1:
            return detailSiteItem?.systems?.count > 0 ? "Systems" : nil
        default:
            return nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addSystemToSite(sender: UIBarButtonItem) {
        if let context = detailSiteItem?.managedObjectContext {
            
            let newSystem = NSEntityDescription.insertNewObjectForEntityForName("System", inManagedObjectContext: context) as! System
            newSystem.site = detailSiteItem
            newSystem.siteIdentifier = detailSiteItem?.uniqueIdentifier
            newSystem.newlyCreated = true
            
            do {
                try context.save()
            }
            catch {
                abort()
            }
            
            self.performSegueWithIdentifier("SiteDetailToSystemDetail", sender: newSystem)
        }
        
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
                cell.titleLabel.text = tableItems[indexPath.row].title
                cell.textField.text = detailSiteItem?.valueForKey(tableItems[indexPath.row].propertyName) as! String?
                
                cell.photoImageView?.layer.borderColor = UIColor.lightGrayColor().CGColor
                cell.photoImageView?.layer.borderWidth = 1.0
                cell.photoImageView?.layer.cornerRadius = 20
                cell.photoImageView?.layer.masksToBounds = true
                
                if let photo = detailSiteItem?.landmarkPhoto {
                    cell.photoImageView?.image = photo
                }
                else {
                    cell.photoImageView?.image = nil
                }
            }
        case (0, 1):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing
                
                cell.textField?.delegate = self                
                cell.textField.text = detailSiteItem?.valueForKey(tableItems[indexPath.row].propertyName) as! String?
                cell.titleLabel.text = tableItems[indexPath.row].title
            }
        case (0, 2):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing
                
                cell.textField?.delegate = self
                cell.textField.text = detailSiteItem?.valueForKey(tableItems[indexPath.row].propertyName) as! String?
                cell.titleLabel.text = tableItems[indexPath.row].title
            }
        case (0, 3):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing
                
                cell.textField?.delegate = self
                cell.textField.text = detailSiteItem?.valueForKey(tableItems[indexPath.row].propertyName) as! String?
                cell.titleLabel.text = tableItems[indexPath.row].title
            }
        case (0, 4):
            if let cell = cell as? NotesCell {
                cell.textView.userInteractionEnabled = self.editing
                cell.textView?.delegate = self
                
                cell.textView.text = detailSiteItem?.valueForKey(tableItems[indexPath.row].propertyName) as! String?
                cell.titleLabel.text = tableItems[indexPath.row].title
            }
        case (0, 5):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing
                
                cell.textField?.delegate = self
                cell.textField.text = detailSiteItem?.valueForKey(tableItems[indexPath.row].propertyName) as! String?
                cell.titleLabel.text = tableItems[indexPath.row].title
            }
        case (0, 6):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing
                
                cell.textField?.delegate = self
                cell.textField.text = detailSiteItem?.valueForKey(tableItems[indexPath.row].propertyName) as! String?
                cell.titleLabel.text = tableItems[indexPath.row].title
            }
        case (0, 7):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing
                
                cell.textField?.delegate = self
                cell.textField.text = detailSiteItem?.valueForKey(tableItems[indexPath.row].propertyName) as! String?
                cell.titleLabel.text = tableItems[indexPath.row].title
            }
        case (0, 8):
            if let cell = cell as? TextFieldCell {
                cell.textField.userInteractionEnabled = self.editing
                
                cell.textField?.delegate = self
                cell.textField.text = detailSiteItem?.valueForKey(tableItems[indexPath.row].propertyName) as! String?
                cell.titleLabel.text = tableItems[indexPath.row].title
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
                detailSiteItem?.setValue(numberFormatter.numberFromString(textField.text ?? ""), forKey: tableItem.propertyName)
            }
            else if tableItem.valueType == "text" {
                detailSiteItem?.setValue(textField.text ?? "", forKey: tableItem.propertyName)
            }
        }
        
        return true
    }
    

    
    
    // MARK: UITextViewDelegate
    
    func textViewDidChange(textView: UITextView) {
        
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if let contentView = textView.superview, tableViewCell = contentView.superview, indexPath = tableView.indexPathForCell(tableViewCell as! UITableViewCell) {
            let propertyName = tableItems[indexPath.row].propertyName
            detailSiteItem?.setValue(textView.text, forKey: propertyName)
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
        if (segue.identifier == "SiteDetailToSystemDetail") {
            if let systemDetailViewController = segue.destinationViewController as? SystemDetailViewController {
                if let newSystem = sender as? System {
                    systemDetailViewController.detailSystemItem = newSystem
                }
            }
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.detailSiteItem?.landmarkPhoto = image
        
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
        if self.detailSiteItem?.landmarkPhoto != nil {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let photoDetailViewController = mainStoryboard.instantiateViewControllerWithIdentifier("PhotoDetailViewController") as! PhotoDetailViewController
            photoDetailViewController.photoImage = self.detailSiteItem?.landmarkPhoto
            
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
