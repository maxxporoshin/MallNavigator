import Foundation

class Utility {
    static func getArchiveURLPath(pathComponent: String) -> String? {
        return NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!.URLByAppendingPathComponent(pathComponent).path
    }
}