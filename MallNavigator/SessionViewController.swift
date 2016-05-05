
//
//  SessionViewController .swift
//  MallNavigator
//
//  Created by Max  on 5/4/16.
//  Copyright © 2016 Max. All rights reserved.
//

import UIKit

class SessionViewController : UITableViewController, NameModalViewControllerDelegate {
    
    var session: String?
    var categories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Actions

    //MARK: Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createNewCategory" {
            let destination = (segue.destinationViewController as! UINavigationController).topViewController as! NameModalViewController
            destination.delegate = self
        }
    }
    
    //MARK: Table View
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = categories[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            categories.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    //MARK: NameModalViewControllerDelegate
    func sendName(name: String?) {
        if let categoryName = name {
            categories.insert(categoryName, atIndex: 0)
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    
    
    
    
    

}