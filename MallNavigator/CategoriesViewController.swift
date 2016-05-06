import UIKit

class CategoriesViewController : UITableViewController, NewNameViewControllerDelegate {
    
    var session: String?
    var categories = [String]()
    var archiveURLPath: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        archiveURLPath = Utility.getArchiveURLPath(session! + "categories")
        navigationItem.title = session
        if let loadedCategories = loadCategories() {
            categories = loadedCategories
        }
    }
    
    func saveCategories() {
        NSKeyedArchiver.archiveRootObject(categories, toFile: archiveURLPath!)
    }
    
    func loadCategories() -> [String]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(archiveURLPath!) as? [String]
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
            destination.category = (sender as! UITableViewCell).textLabel!.text
            destination.session = session
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
        cell.textLabel!.text = categories[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            categories.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            saveCategories()
        }
    }
    
    //MARK: NewNameViewControllerDelegate
    func sendName(name: String?) {
        if let categoryName = name {
            categories.insert(categoryName, atIndex: 0)
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            saveCategories()
        }
    }
    
    
    
    
    
    

}