import UIKit
import CoreData
import CoreLocation

class PhotosViewController : UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {
    
    var articles = [NSManagedObject]()
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var category: NSManagedObject!
    var selectedRow: Int?
    var imagePicker: UIImagePickerController!
    var locationManager: CLLocationManager!
    var userLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        navigationItem.title = category.valueForKey("name") as? String
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
    }
    
    func addArticle(photo: UIImage, location: CLLocation) {
        let articleEntity = NSEntityDescription.entityForName("Article", inManagedObjectContext: managedContext)!
        let article = NSManagedObject(entity: articleEntity, insertIntoManagedObjectContext: managedContext)
        article.setValue(photo, forKey: "photo")
        article.setValue(location, forKey: "location")
        article.setValue(category, forKey: "category")
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
        let fetchRequest = NSFetchRequest(entityName: "Article")
        fetchRequest.predicate = NSPredicate(format: "category == %@", category)
        do {
            articles = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        } catch {
            print("Could not fetch")
        }
    }

    
    //MARK: Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "showNeedle":
            let destination = segue.destinationViewController as! HeadingViewController
            destination.targetLocation = articles[selectedRow!].valueForKey("location") as? CLLocation
            break
        default: break
        }
    }
    
    //MARK: Actions
    @IBAction func takePhoto(sender: UIBarButtonItem) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: Table View
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PhotosTableViewCell
        cell.photoImageView?.image = articles[indexPath.row].valueForKey("photo") as? UIImage
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            managedContext.deleteObject(articles[indexPath.row])
            fetchData()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedRow = indexPath.row
        return indexPath
    }

    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        addArticle(info[UIImagePickerControllerOriginalImage] as! UIImage, location: userLocation!)
        fetchData()
        tableView.reloadData()
    }
    
    //MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0]
    }
}