import Foundation

enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}

class ForceUpdateAppVersion {
    class func isForceUpdateRequire(apiVersion:Int) -> Bool {
        
        func update() {
            UserDefaults.standard.set(apiVersion, forKey: "ApiVersion")
        }
        
        func appUpdateAvailable() -> Bool
        {
            guard let info = Bundle.main.infoDictionary,
                let identifier = info["CFBundleIdentifier"] as? String else {
                    return false
            }
            
            let storeInfoURL: String = "http://itunes.apple.com/lookup?bundleId=\(identifier)&country=za"
            var upgradeAvailable = false
            // Get the main bundle of the app so that we can determine the app's version number
            let bundle = Bundle.main
            if let infoDictionary = bundle.infoDictionary {
                // The URL for this app on the iTunes store uses the Apple ID for the  This never changes, so it is a constant
                let urlOnAppStore = NSURL(string: storeInfoURL)
                if let dataInJSON = NSData(contentsOf: urlOnAppStore! as URL) {
                    // Try to deserialize the JSON that we got
                    if let dict: NSDictionary = try? JSONSerialization.jsonObject(with: dataInJSON as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject] as NSDictionary? {
                        if let results:NSArray = dict["results"] as? NSArray {
                            if let version = (results[0] as! [String:Any])["version"] as? String {
                                // Get the version number of the current version installed on device
                                if let currentVersion = infoDictionary["CFBundleShortVersionString"] as? String {
                                    // Check if they are the same. If not, an upgrade is available.
                                    print("\(version)")
                                    if version != currentVersion {
                                        upgradeAvailable = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return upgradeAvailable
        }

        let isUpdateRequireed = appUpdateAvailable()
        print(isUpdateRequireed)

        
        
        let apiVersionLocal = UserDefaults.standard.integer(forKey: "ApiVersion")
        guard apiVersionLocal != 0 else {
            update()
            return false
        }
        
        if isUpdateRequireed && (apiVersionLocal != apiVersion) {
            return true
        } else {
            update()
            return false
        }
    }
    


}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

