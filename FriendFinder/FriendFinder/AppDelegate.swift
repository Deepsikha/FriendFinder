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
        
        GMSPlacesClient.provideAPIKey("AIzaSyDt2T1bFK6sowqk4WH_ZOA0v-tl115jnQg")
        
        locManager.delegate = self
        locManager.requestAlwaysAuthorization()
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.distanceFilter = 150.0
        locManager.startUpdatingLocation()
        currentLatitude = String(describing: (locManager.location?.coordinate.latitude)!)
        currentLongitude = String(describing: (locManager.location?.coordinate.longitude)!)
        location = currentLatitude?.appending(",").appending(currentLongitude!)
        print(location)
        
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
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
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

