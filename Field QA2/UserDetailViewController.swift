//
//  AddUserViewController.swift
//  Field QA2
//
//  Created by John Jusayan on 12/13/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import UIKit

class UserDetailViewController: UITableViewController, UITextFieldDelegate, UIPopoverControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    var rowItems = [(title:"First", name:"firstName", identifier:"PhotoTextFieldCell"), (title:"Last", name:"lastName", identifier:"TextFieldCell"), (title:"Email", name:"email", identifier:"TextFieldCell"), (title:"Organization", name:"organization", identifier:"TextFieldCell")]
    var nameTextField: UITextField?
    var detailUser: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if detailUser?.newlyCreated == true {
            self.setEditing(true, animated: false)
        }
        else {
            self.setEditing(false, animated: false)
        }
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return rowItems.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(rowItems[indexPath.row].identifier, forIndexPath: indexPath) as! UITableViewCell

        configureCell(cell, forRowAtIndexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            return 52.0
        default:
            return 44.0
        }
    }

    func configureCell(cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let cellTuple = rowItems[indexPath.row]
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            if let cell = cell as? TextFieldCell {
                cell.textField.tag = indexPath.row
                cell.textField.userInteractionEnabled = self.editing
                
                nameTextField = cell.textField
                nameTextField?.delegate = self
                cell.titleLabel.text = "First"
                cell.textField.text = detailUser?.firstName
                
                cell.photoImageView?.layer.borderColor = UIColor.lightGrayColor().CGColor
                cell.photoImageView?.layer.borderWidth = 1.0
                cell.photoImageView?.layer.cornerRadius = 20
                cell.photoImageView?.layer.masksToBounds = true
                
                if let photo = detailUser?.photo {
                    cell.photoImageView?.image = photo
                }
                else {
                    cell.photoImageView?.image = nil
                }
            }
        default:
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            if let detailUser = self.detailUser {
                if let cell = cell as? TextFieldCell {
                    cell.textField.userInteractionEnabled = self.editing
                    cell.textField.delegate = self
                    cell.textField.tag = indexPath.row
                    cell.textField.text = detailUser.valueForKey(cellTuple.name) as? NSString as! String
                    cell.titleLabel.text = cellTuple.title as NSString as? String
                }
            }
            else {
                if let cell = cell as? TextFieldCell {
                    cell.textField.userInteractionEnabled = self.editing
                    cell.textField.delegate = self
                    cell.textField.tag = indexPath.row
                    cell.titleLabel.text = cellTuple.title as NSString as? String
                }
            }
            
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        let cellTuple = rowItems[textField.tag]
        
        NSLog("tag %i", textField.tag)
        
        switch textField.tag {
        default:
            detailUser?.setValue(textField.text, forKey: cellTuple.name)
            println("\(textField.tag)")

            
        }
        return true
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
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
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.reloadData()
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        self.detailUser?.photo = image
        
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
        if self.detailUser?.photo != nil {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let photoDetailViewController = mainStoryboard.instantiateViewControllerWithIdentifier("PhotoDetailViewController") as! PhotoDetailViewController
            photoDetailViewController.photoImage = self.detailUser?.photo
            
            var viewController: UIViewController?
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                viewController = photoDetailViewController
            }
            else {
                viewController = UINavigationController(rootViewController: photoDetailViewController)
            }
            
            viewController!.modalPresentationStyle = .Popover
            // The popver needs to be presented before configuring
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

}
