//
//  AppDelegate.swift
//  DoorcastRebase
//
//  Created by U Dinesh Kumar Reddy on 04/05/22.
//

import UIKit
import CoreData
import Firebase
import Foundation
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder,MessagingDelegate, UIApplicationDelegate, UNUserNotificationCenterDelegate  {
    
    let gcmMessageIDKey = "gcm.Message_ID"
    var aps: NSDictionary?
    var window: UIWindow?
    var locationManager:CLLocationManager?
    var currentLocation:CLLocation?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
        
        FirebaseApp.configure()
        registerForPush()
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
        if let userInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
            if let aps1 = userInfo["aps"] as? NSDictionary {
                print(aps1)
            }
        }
        
        
         
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackgroundActive(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForegroundActive(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        setupLocationManager()
        NotificationCenter.default.addObserver(self, selector: #selector(Drained), name: NSNotification.Name.init(rawValue: "Drained"), object: nil)
        
        
        NotificationCenter.default.post(name: NSNotification.Name("Drained"), object: nil)
        
        
        
        
        return true
    }
    
    @objc func Drained() {
        print("battery2")
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = UIDevice.current.batteryLevel
        
        if (UIDevice.current.batteryState == .unplugged || UIDevice.current.batteryState == .unknown)
        {
         if UIDevice.current.batteryLevel <= 0.2 && UIDevice.current.batteryLevel > 0.15 {
            print("batteryLevel")
          showAlert(message: "battery level")
         } else if UIDevice.current.batteryLevel <= 0.15 && UIDevice.current.batteryLevel > 0.10 {
             showAlert(message: "battery level")
         } else if UIDevice.current.batteryLevel <= 0.10  {
             showAlert(message: "battery level")
         }
    }
 }
   

    
    static var standard : AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    func showAlert(message : String){
        
        let alert = UIAlertController(title: "Battery too low", message:"This application requires battery power of greater than 20%. please charge your phone", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))

        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Create url which from we will get fresh data
        if let url = URL(string: "https://www.vialyx.com") {
            // Send request
            URLSession.shared.dataTask(with: url, completionHandler: { (data, respone, error) in
                // Check Data
                guard let `data` = data else { completionHandler(.failed); return }
                // Get result from data
                let result = String(data: data, encoding: .utf8)
                // Print result into console
                print("performFetchWithCompletionHandler result: \(String(describing: result))")
                // Call background fetch completion with .newData result
                completionHandler(.newData)
            }).resume()
        }
    }
    
    func registerForPush() {
        // Register for Push notifications
        // request Permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert], completionHandler: {granted, error in
            if granted {
                UNUserNotificationCenter.current().delegate = self
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        })
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog("%@: failed to register for remote notifications: %@", self.description, error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //        CleverTap.sharedInstance()?.setPushToken(deviceToken)
        NSLog("%@: registered for remote notifications: %@", self.description, deviceToken.description)
        print(deviceToken.debugDescription)
        Messaging.messaging().apnsToken = deviceToken
        print(deviceToken)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        UserDefaults.standard.set(fcmToken, forKey: "FCMToken")
        // TODO: If necessary send token to application server.
        // No
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        self.window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
        NSLog("%@: did receive notification response: %@", self.description, response.notification.request.content.userInfo)
        //        completionHandler()
        if let aps = response.notification.request.content.userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                let data = alert["data"] as? String
                
                
                if let message = alert["body"] as? NSString {
                    print(message)
                    switch message {
                    case "Someone has logged in with your credeentials","Admin has removed you from the organisation" :
                        goToLogin()
                        break
                    case "Task is added for the crew", "Task is added","Task Reassigned" :
                        gotoCommonTaskDetailVC()
                        break
                    case "Task Reassigned" :
                        break
                    case "Your day has been stopped since your idle for 1.5 hours" :
                        
                        break
                    case "Your time has stopped" :
                        break
                    case "" :
                        break
                        
                    default:
                        break
                    }
                }
                
                
                if let title = alert["title"] as? NSString {
                    print(title)
                    switch title {
                    case "Your task has ended":
                        if defaults.string(forKey: UserDefaultsKeys.task_id) != "" {
                            if let responsedata = response.notification.request.content.userInfo["data"] as? String {
                                print(responsedata)
                                let data1 = responsedata.data(using: .utf8)!
                                do {
                                    if let jsonArray = try? JSONSerialization.jsonObject(with: data1 as Data, options: [.allowFragments]) as? [String:Any]
                                    {
                                       print(jsonArray) // use the json here
                                        if let task_id = jsonArray["task_id"] as? String{
                                            print(task_id)
                                                if task_id == defaults.string(forKey: UserDefaultsKeys.task_id){
                                                    print(defaults.string(forKey: UserDefaultsKeys.task_id))
                                                    gotoCommonTaskDetailVC()
                                                }
                                            } else {
                                                print("Error")
                                        }
                                    }
                                }
                            }
                        }
                        break
                    default:
                        break
                    }
                }
            }
        }
        
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        self.window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
        NSLog("%@: will present notification: %@", self.description, notification.request.content.userInfo)
        if #available(iOS 14.0, *) {
            completionHandler([.list, .sound, .banner])
        } else {
            // Fallback on earlier versions
        }
        
        if let aps = notification.request.content.userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                print("notification alert: \(alert)")
                let title = alert["title"] as? String
                
                
                if let message = alert["body"] as? NSString {
                    print(message)
                    switch message {
                    case "Someone has logged in with your credeentials","Admin has removed you from the organisation" :
                        goToLogin()
                        break
                    case  "Task is added for the crew", "Task is added","Task Reassigned" :
                        gotoCommonTaskDetailVC()
                        break
                    case "Your day has been stopped since your idle for 1.5 hours" :
                        break
                    case "Your time has stopped" :
                        break
                    case "" :
                        break
                        
                    default:
                        break
                    }
                }
                
                
                if let title = alert["title"] as? NSString {
                    print(title)
                    switch title {
                    case "Your task has ended":
                        if defaults.string(forKey: UserDefaultsKeys.task_id) != "" {
                            if let responsedata = notification.request.content.userInfo["data"] as? String {
                                print(responsedata)
                    //                                if let content = String(data: data, encoding: .utf8) {
                                let data1 = responsedata.data(using: .utf8)!
                                do {
                                    if let jsonArray = try? JSONSerialization.jsonObject(with: data1 as Data, options: [.allowFragments]) as? [String:Any]
                                    {
                                       print(jsonArray) // use the json here
                                        if let task_id = jsonArray["task_id"] as? String{
                                            print(task_id)
                                                if task_id == defaults.string(forKey: UserDefaultsKeys.task_id){
                                                    print(defaults.string(forKey: UserDefaultsKeys.task_id))
                                                    gotoCommonTaskDetailVC()
                                                }
                                            } else {
                                                print("Error")
                                        }
                                    }
                                }
                            }
                        }
                        break
                    default:
                        break
                    }
                }
            }
            
            

        }
        
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("userInfo:::\(userInfo)")
        self.window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                print("notification alert: \(alert)")
                let title = alert["title"] as? String
                
                
                if let message = alert["body"] as? NSString {
                    print(message)
                    switch message {
                    case "Someone has logged in with your credeentials" , "Admin has removed you from the organisation" :
                        goToLogin()
                        break
                    case "Task is added for the crew" :
                        break
                    case "Your day has been stopped since your idle for 1.5 hours" :
                        goToOnBoardingVC()
                        break
                    case "Your time has stopped" :
                        break
                    case "" :
                        break
                        
                    default:
                        break
                    }
                }
                
                
                if let title = alert["title"] as? NSString {
                    print(title)
                    switch title {
                    case "Your task has ended":
                        if defaults.string(forKey: UserDefaultsKeys.task_id) != "" {
                            if let responsedata = userInfo["data"] as? String {
                                print(responsedata)
                    //                                if let content = String(data: data, encoding: .utf8) {
                                let data1 = responsedata.data(using: .utf8)!
                                do {
                                    if let jsonArray = try? JSONSerialization.jsonObject(with: data1 as Data, options: [.allowFragments]) as? [String:Any]
                                    {
                                       print(jsonArray) // use the json here
                                        if let task_id = jsonArray["task_id"] as? String{
                                            print(task_id)
                                                if task_id == defaults.string(forKey: UserDefaultsKeys.task_id){
                                                    print(defaults.string(forKey: UserDefaultsKeys.task_id))
                                                    gotoCommonTaskDetailVC()
                                                } else {
                                                    print("Error")
                                                }
                                            }
                                        
                                    }
                                }
                            }
                        }
                        break
                    default:
                        break
                    }
                }
            
              }
        }
        NSLog("%@: did receive remote notification completionhandler: %@", self.description, userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
       
    }
    
    func pushNotificationTapped(withCustomExtras customExtras: [AnyHashable : Any]!) {
        NSLog("pushNotificationTapped: customExtras: ", customExtras)
        //        NotificationCenter.default.post(name: NSNotification.Name("versionCheck"), object: nil)
    }
    
    
    // MARK: UISceneSession Lifecyclz
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "DoorcastRebase")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func goToLogin(){
        
        //        self.window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
        
        DispatchQueue.main.async {
            if let vc = LoginVC.newInstance {
                let nav = UINavigationController(rootViewController: vc)
                nav.isNavigationBarHidden = true
                self.window?.rootViewController = nav
                self.window?.makeKeyAndVisible()
            }
        }
        
    }
    func goToOnBoardingVC(){
        
        //        self.window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
        
        DispatchQueue.main.async {
            if let vc = OnBoardingVC.newInstance {
                let nav = UINavigationController(rootViewController: vc)
                nav.isNavigationBarHidden = true
                self.window?.rootViewController = nav
                self.window?.makeKeyAndVisible()
            }
        }
        
    }
    func gotoCommonTaskDetailVC(){
        
        self.window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
        
        DispatchQueue.main.async {
            if let vc = CommonTaskDetailVC.newInstance {
                let nav = UINavigationController(rootViewController: vc)
                nav.isNavigationBarHidden = true
                self.window?.rootViewController = nav
                self.window?.makeKeyAndVisible()
            }
        }
        
    }
    
    
    
    @objc private func applicationDidEnterBackgroundActive (_ notification: Notification) {
        self.locationManager?.startMonitoringSignificantLocationChanges()
    }
    
    @objc private func applicationWillEnterForegroundActive (_ notification: Notification) {
        self.locationManager?.startUpdatingLocation()
    }
    
}



extension AppDelegate:CLLocationManagerDelegate {
    
    func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        self.locationManager?.requestAlwaysAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.startUpdatingLocation()        
    }
    
    // Below method will provide you current location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
      
        let locationValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        KLat = String(locationValue.latitude)
        KLong = String(locationValue.longitude)
        
        // locationManager?.stopUpdatingLocation()
        NotificationCenter.default.post(name: NSNotification.Name("updateLocation"), object: nil)
        
    }
    
    // Below Mehtod will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
    
    
    
    
}


//latitude = "15.151565551757812";
//longitude = "76.92289389955027";
