import UIKit
import CoreLocation

class PhotosViewController : UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {
    
    var data: SessionsData!
    var sessionIndex: Int!
    var categoryIndex: Int!
    var selectedRow: Int?
    var imagePicker: UIImagePickerController!
    var locationManager: CLLocationManager!
    var userLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = data.sessions[sessionIndex].categories[categoryIndex].name
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
    }
    
    //MARK: Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "showNeedle":
            let destination = segue.destinationViewController as! HeadingViewController
            let article = data.sessions[sessionIndex].categories[categoryIndex].articles[selectedRow!]
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
        return data.sessions[sessionIndex].categories[categoryIndex].articles.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PhotosTableViewCell
        cell.photoImageView?.image = data.sessions[sessionIndex].categories[categoryIndex].articles[indexPath.row].photo
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            data.sessions[sessionIndex].categories[categoryIndex].articles.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            data.save()
        }
    }
        
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedRow = indexPath.row
        return indexPath
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        data.sessions[sessionIndex].categories[categoryIndex].articles.insert(Article(photo: info[UIImagePickerControllerOriginalImage] as! UIImage, location: userLocation!), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        data.save()
    }
    
    //MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0]
    }
}