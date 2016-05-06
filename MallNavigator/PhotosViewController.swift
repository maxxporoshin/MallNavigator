import UIKit

class PhotosViewController : UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var photos = [UIImage]()
    var session: String?
    var category: String?
    var archiveURLPath: String?
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if session != nil && category != nil {
            archiveURLPath = Utility.getArchiveURLPath(session! + category! + "categories")
            navigationItem.title = session
            if let loadedPhotos = loadPhotos() {
                photos = loadedPhotos
            }
        }
    }
    
    func savePhotos() {
        NSKeyedArchiver.archiveRootObject(photos, toFile: archiveURLPath!)
    }
    
    func loadPhotos() -> [UIImage]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(archiveURLPath!) as? [UIImage]
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
        return photos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PhotosTableViewCell
        cell.photoImageView?.image = photos[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            photos.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            savePhotos()
        }
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        photos.insert((info[UIImagePickerControllerOriginalImage] as? UIImage)!, atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        savePhotos()
    }
}