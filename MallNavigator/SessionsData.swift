import UIKit
import CoreLocation

class SessionsData {
    var sessions = [Session]()
    let archiveURLPath = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!.URLByAppendingPathComponent("sessionsData").path
    
    func save() {
        NSKeyedArchiver.archiveRootObject(sessions, toFile: archiveURLPath!)
    }
    
    func load() {
        if let data = NSKeyedUnarchiver.unarchiveObjectWithFile(archiveURLPath!) {
            sessions = data as! [Session]
        }
    }
}

class Session : NSObject, NSCoding {
    let sessionNameKey = "sessionName"
    let categoriesKey = "categories"
    var name: String
    var categories = [Category]()
    
    init(name: String) {
        self.name = name
        categories.append(Category(name: "Jeans"))
        categories.append(Category(name: "Shoes"))
        categories.append(Category(name: "Shirts"))
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: sessionNameKey)
        aCoder.encodeObject(categories, forKey: categoriesKey)
    }
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey(sessionNameKey) as! String
        categories = aDecoder.decodeObjectForKey(categoriesKey) as! [Category]
    }
    
}

class Category : NSObject, NSCoding {
    let categoryNameKey = "categoriesName"
    let articlesKey = "article"
    var name: String
    var articles = [Article]()
    
    init(name: String) {
        self.name = name
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: categoryNameKey)
        aCoder.encodeObject(articles, forKey: articlesKey)
    }
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey(categoryNameKey) as! String
        articles = aDecoder.decodeObjectForKey(articlesKey) as! [Article]
    }
    
}

class Article : NSObject, NSCoding {
    let photoKey = "photo"
    let locationKey = "location"
    
    var photo: UIImage?
    var location: CLLocation?
    
    init(photo: UIImage, location: CLLocation) {
        self.photo = photo
        self.location = location
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(photo, forKey: photoKey)
        aCoder.encodeObject(location, forKey: locationKey)
    }
    required init?(coder aDecoder: NSCoder) {
        photo = aDecoder.decodeObjectForKey(photoKey) as? UIImage
        location = aDecoder.decodeObjectForKey(locationKey) as? CLLocation
    }
}
