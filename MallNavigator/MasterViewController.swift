//
//  MasterViewController.swift
//  MallNavigator
//
//  Created by Max  on 5/3/16.
//  Copyright © 2016 Max. All rights reserved.
//

import UIKit

class MasterViewController : UITableViewController, NameModalViewControllerDelegate {
    
    var sessions = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Actions
    @IBAction func insertNewSession(sender: UIBarButtonItem) {
    }
    
    //MARK: Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createNewSession" {
            let destination = (segue.destinationViewController as! UINavigationController).topViewController as! NameModalViewController
            destination.delegate = self
        }
    }
    
    //MARK: Table View
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = sessions[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            sessions.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    //MARK: NameModalViewControllerDelegate
    func sendName(name: String?) {
        if let sessionName = name {
            sessions.insert(sessionName, atIndex: 0)
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    
    
    
    
    
    
}