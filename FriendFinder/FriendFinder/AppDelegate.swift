//
//  AppDelegate.swift
//  FriendFinder
//
//  Created by devloper65 on 2/21/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import GooglePlaces


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    
    var window: UIWindow?
    var navController: UINavigationController?
    var viewController = FriendViewController()
    let shareData = ShareData.sharedInstance
    let defaults = UserDefaults.standard
    var locManager = CLLocationManager()
    var location : String!
    var user: String?
    var currentLatitude: String?
    var currentLongitude: String?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.registerForRemoteNotifications()
        
        GMSPlacesClient.provideAPIKey("AIzaSyDt2T1bFK6sowqk4WH_ZOA0v-tl115jnQg")
        
        locManager.delegate = self
        locManager.requestAlwaysAuthorization()
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.distanceFilter = 5.0
        locManager.startUpdatingLocation()
        
        currentLatitude = String(describing: (locManager.location?.coordinate.latitude)!)
        currentLongitude = String(describing: (locManager.location?.coordinate.longitude)!)
        location = currentLatitude?.appending(",").appending(currentLongitude!)
        
        if(UserDefaults.standard.value(forKey: "user") != nil){
            
            let rootVC = tabbar()
            let nav = UINavigationController(rootViewController: rootVC)
            window?.rootViewController = nav
            window?.makeKeyAndVisible()
            return true
        }
        else{
            let rootVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
            let nav = UINavigationController(rootViewController: rootVC)
            window?.rootViewController = nav
            window?.makeKeyAndVisible()
            return true
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(deviceToken)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("\(error)\nFailed to register!");
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        currentLatitude = String(describing: (manager.location?.coordinate.latitude)!)
        currentLongitude = String(describing: (manager.location?.coordinate.longitude)!)
        location = currentLatitude?.appending(",").appending(currentLongitude!)
        
        if(UserDefaults.standard.value(forKey: "user") != nil){
            let user = UserDefaults.standard.value(forKey: "user") as! String
            let parameters = ["username": user,"location": location!]
            print("updated")
            server_API.sharedObject.requestFor_NSMutableDictionary(Str_Request_Url: "loc", Request_parameter: parameters, Request_parameter_Images: nil, status: { (result) in
                
            }, response_Dictionary: { (result) in
                
            }, response_Array: { (result) in
                
            }, isTokenEmbeded: false)
        }
        else{
            print("Username is empty")
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error)
    {
        print("Location not updated")
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        locManager.startUpdatingLocation()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        locManager.startUpdatingLocation()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
       locManager.startUpdatingLocation()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        locManager.startUpdatingLocation()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
//    applicationDidRe
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "FriendFinder")
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
    
}

