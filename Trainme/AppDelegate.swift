//
//  AppDelegate.swift
//  Trainme
//
//  Created by levi cheng on 10/29/24.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import FirebaseAppCheck
import FirebaseStorage


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
   
     

        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> 
    
    Bool {
        AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())
               FirebaseApp.configure()
        let storage = Storage.storage()
               print("Storage initialized with bucket: \(storage.reference().bucket)")
        
        GMSPlacesClient.provideAPIKey("AIzaSyDhcRgTLWiSqgW7FhdBXMTXkhETsLuBU4A")
            GMSServices.provideAPIKey("AIzaSyDhcRgTLWiSqgW7FhdBXMTXkhETsLuBU4A")
        
           
        GMSPlacesClient.openSourceLicenseInfo()
             
               return true
           }

    
    

    // MARK: UISceneSession Lifecycle

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


}


