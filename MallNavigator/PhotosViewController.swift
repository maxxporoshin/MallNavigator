import UIKit
import CoreLocation

class Article : NSObject, NSCoding {
    let photoKey = "photo"
    let locationKey = "location"
    
    var photo: UIImage?
    var location: CLLocation?
    
    init(photo: UIImage, location: CLLocation) {
        self.photo = photo
        self.location = location
    }
    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(photo, forKey: photoKey)
        aCoder.encodeObject(location, forKey: locationKey)
    }
    @objc required init?(coder aDecoder: NSCoder) {
        photo = aDecoder.decodeObjectForKey(photoKey) as? UIImage
        location = aDecoder.decodeObjectForKey(locationKey) as? CLLocation
    }
}

class PhotosViewController : UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {
    
    var articles = [Article]()
    var session: String?
    var category: String?
    var archiveURLPath: String?
    var imagePicker: UIImagePickerController!
    var locationManager: CLLocationManager!
    var userLocation: CLLocation?
    var selectedCellRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if session != nil && category != nil {
            archiveURLPath = Utility.getArchiveURLPath(session! + " " + category! + " articles")
            navigationItem.title = session
            if let loadedArticles = loadArticles() {
                articles = loadedArticles
            }
        }
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
    }
    
    func saveArticles() {
        NSKeyedArchiver.archiveRootObject(articles, toFile: archiveURLPath!)
    }
    
    func loadArticles() -> [Article]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(archiveURLPath!) as? [Article]
    }
    
    //MARK: Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "showNeedle":
            let destination = segue.destinationViewController as! HeadingViewController
            let article = articles[selectedCellRow!]
            destination.targetLocation = article.location
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
        cell.photoImageView?.image = articles[indexPath.row].photo
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            articles.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            saveArticles()
        }
    }
        
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedCellRow = indexPath.row
        return indexPath
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        articles.insert(Article(photo: info[UIImagePickerControllerOriginalImage] as! UIImage, location: userLocation!), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        saveArticles()
    }
    
    //MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0]
    }
}