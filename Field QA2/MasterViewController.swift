//
//  MasterViewController.swift
//  Field QA2
//
//  Created by John Jusayan on 8/11/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate, MFMailComposeViewControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    var currentUser: Person?
    var currentUserSelectedObserverToken: NSObjectProtocol?
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    func updateHeader() {
        
        userImageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        userImageView.layer.borderWidth = 1.0
        userImageView.layer.cornerRadius = 20
        userImageView.layer.masksToBounds = true
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        currentUser = appDelegate.currentUser
        
        if let user = currentUser {
            if user.firstName != nil && user.lastName != nil {
                let fullName = user.firstName! + " " + user.lastName!
                userNameLabel.text = fullName
            }
            else {
                userNameLabel.text = "A User"
            }
            userImageView.image = user.photo
        }
        else {
            userNameLabel.text = "Not logged in"
            userImageView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUserSelectedObserverToken = NSNotificationCenter.defaultCenter().addObserverForName("CurrentUserSelectedNotification", object: nil, queue: nil) {
            [weak self]
            (_) -> Void in
            self?.updateHeader()
            return
        }
        
        let exportButton = UIBarButtonItem(title: "Export", style: UIBarButtonItemStyle.Plain, target: self, action: "export:")
        self.navigationItem.leftBarButtonItem = exportButton
    }
    
    func export(sender: UIBarButtonItem) {
        do {
            try DataManager.sharedManager.managedObjectContext?.save()
        } catch {
        }
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposeViewController.setToRecipients(["john@renocollective.com"])
        mailComposeViewController.setSubject("Field QA Export")
        mailComposeViewController.setMessageBody("Data Export:\n", isHTML: false)
        
        
        let data = CDJSONExporter.exportContext(DataManager.sharedManager.managedObjectContext, auxiliaryInfo: nil)
        let data2 = NEXJSONExporter.exportContext(DataManager.sharedManager.managedObjectContext, auxiliaryInfo: nil)

        
        mailComposeViewController.addAttachmentData(data, mimeType: "application/json", fileName:"app-export.json")
        mailComposeViewController.addAttachmentData(data2, mimeType: "application/json", fileName:"server-export.json")

        return mailComposeViewController
    }
    
    func showSendMailErrorAlert() {
        let alertViewController = UIAlertController(title: nil, message: "Unable to send email", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (_) -> Void in
            
        }
        alertViewController.addAction(okAction)
        self.presentViewController(alertViewController, animated: true) { () -> Void in
            
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    deinit {
        if let currentUserSelectedObserverToken = self.currentUserSelectedObserverToken {
            NSNotificationCenter.defaultCenter().removeObserver(currentUserSelectedObserverToken, name: "CurrentUserSelectedNotification", object: nil)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateHeader()

        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in

            if self.currentUser == nil {
                let alertController = UIAlertController(title: nil, message: "Please log in", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Log In", style: UIAlertActionStyle.Default, handler: { (_) -> Void in
                    self.performSegueWithIdentifier("showUsersViewController", sender: nil)
                }))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.navigationItem.leftItemsSupplementBackButton = true
    }
    
    // MARK: - Table View

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)
                
            do {
                try context.save()
            }
            catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //println("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
    }

    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        _ = self.fetchedResultsController.objectAtIndexPath(indexPath)
    }

    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("ServiceEntry", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
    	do {
            try _fetchedResultsController!.performFetch()
        }
        catch {
    	     // Replace this implementation with code to handle the error appropriately.
    	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             //println("Unresolved error \(error), \(error.userInfo)")
    	     abort()
    	}
        
        return _fetchedResultsController!
    }    
    var _fetchedResultsController: NSFetchedResultsController? = nil

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
            case .Insert:
                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            case .Delete:
                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            default:
                return
        }
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }

    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         self.tableView.reloadData()
     }
     */

    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            let versionNumber = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? NSString
            let buildNumber = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? NSString
            
            return NSString(format:"Field QA v%@ (%@). © UNR CSE, 2015", versionNumber!, buildNumber!) as String
        }
        return nil;
    }


}

