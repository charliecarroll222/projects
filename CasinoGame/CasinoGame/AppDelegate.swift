//
//  AppDelegate.swift
//  CasinoGame
//
//  Created by Charles Carroll on 4/11/24.
//
// Charles Carroll (chajcarr), Anthony Reyes (antreye)
// App Name: Diamond Dunes Casinno
// Final Project Submission Date: 04/28/2024

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var model : CasinoModel = CasinoModel(balance: 0)
    var notificationsOn = false
    
    var path: String!
    
    func saveToFile(_ model: CasinoModel, atPath path: String) {
        do {
            
            let data = try PropertyListEncoder().encode(model)
            let fileManager = FileManager.default
            guard let docsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else{
                return
            }
            let pURL = docsURL.appendingPathComponent("theFile.plist")
            try data.write(
                to: URL(fileURLWithPath: path))
        } catch {
            print("Error saving file: \(error.localizedDescription)")
        }
    }
    
    func loadFromFile(atPath path: String) {
        guard FileManager.default.fileExists(atPath: path) else{
            print("file not found at this path")
            return
        }
            do {
                let data = try? Data(contentsOf: URL(fileURLWithPath: path))
                guard !data!.isEmpty else{
                    return
                }
                let decoder = PropertyListDecoder()
                self.model = try decoder.decode(CasinoModel.self, from: data!)
                
            } catch {
                print("Error loading file: \(error.localizedDescription)")
            }
        }



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let lDocsPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
 
        
        if let lDocsString: NSString = lDocsPath as NSString? {
            let lFileNameWithPath = lDocsString.appendingPathComponent("theFile.plist")
            print("in appDelegate: fileNameWithPath is \(lFileNameWithPath)")
            path = lFileNameWithPath
            
            
            loadFromFile(atPath: path)
            print("balance: " + String(model.balance))
            
        }
        
        if let myTmpDirPath: NSString = NSTemporaryDirectory() as NSString? {
            let myTmpFilePath = myTmpDirPath.appendingPathComponent("tempFile.txt")
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                if granted {
                    print("Notification authorization granted")
                    self.notificationsOn = true
                    
                } else {
                    print("Notification authorization denied")
                    self.notificationsOn = false
                }
            }
        
        if(!notificationsOn){
            scheduleNotification()
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
        }
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
            // When the application enters the background, update and save the model object
        saveToFile(model, atPath: path)
        if(!notificationsOn){
            
        }
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
    
    func scheduleNotification() {
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "It's time to win some treasure!"
        content.body = "Hop back on to Diamond Dunes Casino for more winnings"
        //trigger for 9:00 PM
        var dateComponents = DateComponents()
        dateComponents.hour = 21
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        //request
        let request = UNNotificationRequest(identifier: "chipsNotification", content: content, trigger: trigger)
        // Schedule
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling: \(error.localizedDescription)")
            } else {
                print("Notification scheduled")
            }
        }
    }


}

