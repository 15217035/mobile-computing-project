//
//  AppDelegate.swift
//  bookExchangeApp
//
//  Created by 15217035 on 15/11/2018.
//  Copyright © 2018 comp4097proj. All rights reserved.
//
import UIKit
import Firebase
import UserNotifications
import PushNotifications
import FirebaseFirestore
import FirebaseAuth

    @UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
        
        var window: UIWindow?
        
        let pushNotifications = PushNotifications.shared
        
        var myUserID = ""
        
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
                 UserDefaults.standard.set(nil, forKey: "userid")

                application.registerForRemoteNotifications()
                
                FirebaseApp.configure()
                
                self.pushNotifications.start(instanceId: "e259b834-189f-4848-afed-0563de7ec4e1")
                self.pushNotifications.registerForRemoteNotifications()
                try? self.pushNotifications.subscribe(interest: "hello")
                
                return true
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
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

//func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//    // Convert token to string
//    let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
//
//    // Print it to console
//    print("APNs device token!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!-----------------------------!: \(deviceTokenString)")
//
//    // Persist it in your backend in case it's new
//}
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
//    self.pushNotifications.registerDeviceToken(deviceToken)
    print("APNs device token: \(deviceTokenString)")
    
    self.myUserID = Auth.auth().currentUser!.uid
    
    let ref = Firestore.firestore().collection("Users").document(self.myUserID)
    ref.updateData([
        "token":deviceTokenString
    ]) { err in
        if let err = err {
            print("Error updating document: \(err)")
        } else {
            print("Document successfully updated")
            UserDefaults.standard.set(deviceTokenString, forKey: "token")
        }
    }
}
        
  


// Called when APNs failed to register the device for push notifications
func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    // Print the error to console (you should alert the user that registration failed)
    print("APNs registration failed: \(error)")
}

func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
  
    self.pushNotifications.handleNotification(userInfo: userInfo)
}

}
