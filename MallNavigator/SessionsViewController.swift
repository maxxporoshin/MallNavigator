import UIKit

class SessionsViewController : UITableViewController, NewNameViewControllerDelegate {
    
    var sessions = [String]()
    let archiveURLPath = Utility.getArchiveURLPath("sessions")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let loadedSessions = loadSessions() {
            sessions = loadedSessions
        }
    }
    
    func saveSessions() {
        NSKeyedArchiver.archiveRootObject(sessions, toFile: archiveURLPath!)
    }
    
    func loadSessions() -> [String]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(archiveURLPath!) as? [String]

    }
    
    //MARK: Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "createNewSession":
            let destination = (segue.destinationViewController as! UINavigationController).topViewController as! NewNameViewController
            destination.delegate = self
            break
        case "showCategories":
            let destination = segue.destinationViewController as! CategoriesViewController
            destination.session = (sender as! UITableViewCell).textLabel!.text
            break
        default: break
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
            saveSessions()
        }
    }
    
    //MARK: NewNameViewControllerDelegate
    func sendName(name: String?) {
        if let sessionName = name {
            sessions.insert(sessionName, atIndex: 0)
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            saveSessions()
        }
    }
}
