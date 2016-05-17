import UIKit
import CoreData

class CategoriesViewController : UITableViewController, NewNameViewControllerDelegate {
    
    var categories = [NSManagedObject]()
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var session: NSManagedObject!
    var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        navigationItem.title = session.valueForKey("name") as? String
    }
    
    func addCategory(name: String) {
        let categoryEntity = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedContext)!
        let category = NSManagedObject(entity: categoryEntity, insertIntoManagedObjectContext: managedContext)
        category.setValue(name, forKey: "name")
        category.setValue(session, forKey: "session")
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
        let fetchRequest = NSFetchRequest(entityName: "Category")
        fetchRequest.predicate = NSPredicate(format: "session == %@", session)
        do {
            categories = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        } catch {
            print("Could not fetch")
        }
    }
    
    //MARK: Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "createNewCategory":
            let destination = (segue.destinationViewController as! UINavigationController).topViewController as! NewNameViewController
            destination.delegate = self
            destination.navigationItem.title = "New category"
            destination.labelText = "Category name"
            break
        case "showPhotos":
            let destination = segue.destinationViewController as! PhotosViewController
            destination.category = categories[selectedRow!]
            break
        default: break
        }
    }
    
    //MARK: Table View
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = categories[indexPath.row].valueForKey("name") as? String
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            managedContext.deleteObject(categories[indexPath.row])
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
        if let categoryName = name {
            addCategory(categoryName)
            fetchData()
            tableView.reloadData()
        }

    }
    
    
    
    
    
    

}