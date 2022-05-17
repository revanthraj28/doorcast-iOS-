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

@UIApplicationMain
class AppDelegate: UIResponder,MessagingDelegate, UIApplicationDelegate, UNUserNotificationCenterDelegate  {
    
    let gcmMessageIDKey = "gcm.Message_ID"
    var aps: NSDictionary?
    var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        
        FirebaseApp.configure()
        registerForPush()
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
        
        
        if let userInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
            if let aps1 = userInfo["aps"] as? NSDictionary {
                print(aps1)
            }
        }
        
        return true
    }
    
    static var standard : AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
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
        
        NSLog("%@: did receive notification response: %@", self.description, response.notification.request.content.userInfo)
        //        completionHandler()
        if let aps = response.notification.request.content.userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                let title = alert["title"] as? String
                if let message = alert["body"] as? NSString {
                    print(message)
                    switch message {
                    case "Someone has logged in with your credeentials" :
                        goToLogin()
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
        
        NSLog("%@: will present notification: %@", self.description, notification.request.content.userInfo)
        completionHandler([.list, .sound, .banner])
        
        if let aps = notification.request.content.userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                print("notification alert: \(alert)")
                let title = alert["title"] as? String
                if let message = alert["body"] as? NSString {
                    print(message)
                    switch message {
                    case "Someone has logged in with your credeentials","Admin has removed you from the organisation":
                        goToLogin()
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
        NSLog("%@: did receive remote notification completionhandler: %@", self.description, userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
        print("userInfo:::\(userInfo)")
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
        
        
        self.window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
        
        DispatchQueue.main.async {
            if let vc = LoginVC.newInstance {
                let nav = UINavigationController(rootViewController: vc)
                nav.isNavigationBarHidden = true
                self.window?.rootViewController = nav
                self.window?.makeKeyAndVisible()
            }
        }
        
    }
    
}
