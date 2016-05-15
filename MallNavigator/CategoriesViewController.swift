import UIKit

class CategoriesViewController : UITableViewController, NewNameViewControllerDelegate {
    
    var data: SessionsData!
    var sessionIndex: Int!
    var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = data.sessions[sessionIndex].name
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
            destination.data = data
            destination.sessionIndex = sessionIndex
            destination.categoryIndex = selectedRow
            break
        default: break
        }
    }
    
    //MARK: Table View
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.sessions[sessionIndex].categories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = data.sessions[sessionIndex].categories[indexPath.row].name
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            data.sessions[sessionIndex].categories.removeAtIndex(indexPath.row)
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
        if let categoryName = name {
            data.sessions[sessionIndex].categories.insert(Category(name: categoryName), atIndex: 0)
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            data.save()
        }
    }
    
    
    
    
    
    

}