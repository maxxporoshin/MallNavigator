import UIKit
import CoreLocation

class HeadingViewController : UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var needle: UIImageView!
    var locationManager: CLLocationManager!
    var targetLocation: CLLocation!
    var userLocation: CLLocation?
    var angle: Double? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    func calculateAngle() {
        let userLatitude = userLocation!.coordinate.latitude
        let userLongitude = userLocation!.coordinate.longitude
        let targetLatitude = targetLocation.coordinate.latitude
        let targetLongitude = targetLocation.coordinate.longitude
        var pointLatitude: CLLocationDegrees! = 0
        var pointLongitude: CLLocationDegrees! = 0
        
        if targetLatitude > userLatitude && targetLongitude > userLongitude {
            //north east
            pointLatitude = userLatitude
            pointLongitude = targetLongitude
            angle = 0
        }
        else if targetLatitude > userLatitude && targetLongitude < userLongitude {
            //south east
            pointLatitude = targetLatitude
            pointLongitude = userLongitude
            angle = 45
        }
        else if targetLatitude < userLatitude && targetLongitude < userLongitude {
            //south west
            pointLatitude = targetLatitude
            pointLongitude = userLatitude
            angle = 180
        }
        else if targetLatitude < userLatitude && targetLongitude > userLongitude {
            //north west
            pointLatitude = targetLatitude
            pointLongitude = userLongitude
            angle = 225
        }
        let vQPLatitude: Double = pointLatitude - userLatitude
        let vQPLongitude: Double = pointLongitude - userLongitude
        
        let vQTLatitude: Double = targetLatitude - userLatitude
        let vQTLongitude: Double = targetLongitude - userLongitude
        
        let cosDegrees: Double = (vQPLatitude * vQTLatitude + vQPLongitude * vQTLatitude) / sqrt((vQPLatitude * vQPLatitude + vQPLongitude * vQPLongitude) * (vQTLatitude * vQTLatitude + vQTLongitude * vQTLongitude))
        angle = angle! + acos(cosDegrees)
    }
    
    //MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0]
        label.text = Int(userLocation!.distanceFromLocation(targetLocation)).description + "meters"
        calculateAngle()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        needle.transform = CGAffineTransformMakeRotation(CGFloat((angle! - newHeading.magneticHeading) * M_PI / 180))
    }
}