import UIKit
import CoreData

class SessionsViewController : UITableViewController, NewNameViewControllerDelegate {
    
    var sessions = [NSManagedObject]()
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func addSession(name: String) {
        let sessionEntity = NSEntityDescription.entityForName("Session", inManagedObjectContext: managedContext)!
        let session = NSManagedObject(entity: sessionEntity, insertIntoManagedObjectContext: managedContext)
        session.setValue(name, forKey: "name")
        saveData()
    }
    
    func saveData() {
        do {
            try managedContext.save()
        } catch {
            print("Could not save")
        }
    }
    
    func fetchData() {
        let fetchRequest = NSFetchRequest(entityName: "Session")
        do {
            sessions = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        } catch {
            print("Could not fetch")
        }
    }
    
    //MARK: Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "createNewSession":
            let destination = (segue.destinationViewController as! UINavigationController).topViewController as! NewNameViewController
            destination.delegate = self
            var i = 1
            while i != 0 {
                var isFound = false
                let newSessionName = "Session \(i)"
                for session in sessions {
                    if session.valueForKey("name") as? String == newSessionName {
                        isFound = true
                    }
                }
                if !isFound {
                    destination.textFieldText = newSessionName
                    i = 0
                }
                else {
                    i += 1
                }
            }
            break
        case "showCategories":
            let destination = segue.destinationViewController as! CategoriesViewController
            destination.session = sessions[selectedRow!]
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
        cell.textLabel!.text = sessions[indexPath.row].valueForKey("name") as? String
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            managedContext.deleteObject(sessions[indexPath.row])
            fetchData()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedRow = indexPath.row
        return indexPath
    }
    
    //MARK: NewNameViewControllerDelegate
    func newName(name: String?) {
        if let sessionName = name {
            addSession(sessionName)
            fetchData()
            tableView.reloadData()
        }
    }
}
