import UIKit

class SessionsViewController : UITableViewController, NewNameViewControllerDelegate {
    
    var data = SessionsData()
    var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data.load()
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
            destination.data = data
            destination.sessionIndex = selectedRow
            break
        default: break
        }
    }
    
    //MARK: Table View
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.sessions.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = data.sessions[indexPath.row].name
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            data.sessions.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            data.save()
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedRow = indexPath.row
        return indexPath
    }
    
    //MARK: NewNameViewControllerDelegate
    func newName(name: String?) {
        if let sessionName = name {
            data.sessions.insert(Session(name: sessionName), atIndex: 0)
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            data.save()
        }
    }
}
