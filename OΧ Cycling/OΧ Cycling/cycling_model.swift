//
//  cycling_model.swift
//  OΧ Cycling
//
//  Created by Charles Carroll on 9/18/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class cycling_model {
    
    var name = ""
    
    var teamWeekTotal: Double = 0.0
    var myWeekMiles: Double = 0.0
    var myTotalMiles: Double = 0.0
    var myWeekRides: Double = 0.0
    var myTotalRides: Double = 0.0
    var myLongestRide: Double = 0.0
    let riders = ["tyler", "charlie", "will", "luke"]
    var weeklyMilesDict: [String: Double] = ["tyler": 0.0, "charlie": 0.0, "will": 0.0, "luke": 0.0]
    var weeklyRidesDict: [String: Double] = ["tyler": 0.0, "charlie": 0.0, "will": 0.0, "luke": 0.0]
    
    struct ride {
        var distance: Double
        var time: TimeInterval
    }
    
    struct post: Codable {
        @DocumentID var id: String?
        var username: String
        var content: String
        var timestamp: Timestamp
        
        // A computed property to convert the Firestore timestamp to Date
        var date: Date {
            return timestamp.dateValue()
        }
    }
    
    
    func getCurrentUserName() {
        if let user = Auth.auth().currentUser {
            let email = user.email
            if(email == "chajcarr@iu.edu"){
                name = "charlie"
            }
            else if(email == "wjduncan@iu.edu"){
                name = "will"
            }
            else if(email == "evanwell@iu.edu"){
                name = "will"
            }
            else{
                name = "luke"
            }
        } else {
            print("No user is logged in")
        }
    }
    
    func setRiderMiles(rider: String, miles: Double){
        self.weeklyMilesDict[rider] = miles
    }
    
    func getWeeklyMiles(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        let dispatchGroup = DispatchGroup()

        for rider in riders {
            dispatchGroup.enter()
            let riderRef = db.collection("riders").document(rider)
            print(riderRef)
            
            riderRef.getDocument { document, error in
                if let document = document, document.exists {
                    if let weeklyMiles = document.get("weekMiles") as? Double {
                        self.setRiderMiles(rider: rider, miles: weeklyMiles)
                    } else {
                        self.weeklyMilesDict[rider] = 0.0 // Assuming 0 if no data
                    }
                } else {
                    print("Error retrieving document for \(rider): \(error?.localizedDescription ?? "No error")")
                    self.weeklyMilesDict[rider] = 0.0
                }
                 // Leave the group after the Firestore call finishes
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
                print("All rider miles fetched. Final weeklyMilesDict:", self.weeklyMilesDict)
                completion()
        }
    }
    
    func getWeeklyRides(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        let dispatchGroup = DispatchGroup()

        for rider in riders {
            dispatchGroup.enter()
            let riderRef = db.collection("riders").document(rider)
            
            riderRef.getDocument { document, error in
                if let document = document, document.exists {
                    if let weeklyRides = document.get("weekRides") as? Double {
                        self.weeklyRidesDict[rider] = weeklyRides
                    } else {
                        self.weeklyRidesDict[rider] = 0.0 // Assuming 0 if no data
                    }
                } else {
                    print("Error retrieving document for \(rider): \(error?.localizedDescription ?? "No error")")
                    self.weeklyRidesDict[rider] = 0.0
                }
                dispatchGroup.leave() // Leave the group after the Firestore call finishes
            }
        }
        dispatchGroup.notify(queue: .main) {
                print("All rider rides fetched. Final weeklyRidesDict:", self.weeklyRidesDict)
                completion()
        }
    }
    
    func getMostMiles() -> String {
        var most = "tyler"
        for rider in riders {
            if weeklyMilesDict[rider]! >= weeklyMilesDict[most]!{
                most = rider
            }
        }
        return most
    }
    func getWeekTotal() -> Double {
        let answer:Double = self.weeklyMilesDict.values.reduce(0.0, +)
        return answer
    }
    
    func getMostRides() -> String {
        var most = "tyler"
        for rider in riders {
            if weeklyRidesDict[rider]! >= weeklyRidesDict[most]!{
                most = rider
            }
        }
        return most
    }
    
    func processMiles(m: Double){
        let db = Firestore.firestore()
        getWeeklyMiles{}
        getWeeklyRides{}
        weeklyMilesDict[name]! += m
        weeklyRidesDict[name]! += 1
        
        print("new amount of miles for charlie ", weeklyMilesDict[name]!)
        
        
    }
    
    func addRide(miles: Double, mins: String){
        let db = Firestore.firestore()
        let riderRef = db.collection("riders").document(name)
        riderRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    // Get stats
                    var currentMilesTotal = document.data()?["totalMiles"] as? Double ?? 0.0
                    var currentMilesWeek = document.data()?["weekMiles"] as? Double ?? 0.0
                    var currentRidesTotal = document.data()?["totalRides"] as? Double ?? 0.0
                    var currentRidesWeek = document.data()?["weekRides"] as? Double ?? 0.0
                    // Add ride
                    currentMilesTotal += miles
                    currentMilesWeek += miles
                    currentRidesTotal += 1
                    currentRidesWeek += 1
                    // Update Firestore
                    riderRef.updateData([
                        "totalMiles": currentMilesTotal,
                        "weekMiles": currentMilesWeek,
                        "totalRides": currentRidesTotal,
                        "weekRides": currentRidesWeek
                    ]) { err in
                        if let err = err {
                            print("Error updating miles: \(err)")
                        } else {
                            print("Successfully added \(miles) miles to rider: \(self.name)")
                        }
                    }
                } else {
                    print("Document does not exist or error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
    }
    
    func addRide(distance: Double, duration: Double, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let riderRef = db.collection(name).document(name)
        
        let averageSpeed = duration > 0 ? distance / (duration / 60.0) : 0.0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let currentDate = dateFormatter.string(from: Date())
        let rideEntry = "\(currentDate) - \(distance) miles, \(duration) minutes: Averaged \(averageSpeed) mph"
        
        // add to firestore database
        riderRef.updateData([
            "rides": FieldValue.arrayUnion([rideEntry])
        ]) { error in
            completion(error)
        }
    }
    
    func checkAndResetWeeklyMiles() {
        let resetRef = Firestore.firestore().collection("resetting").document("reset")
        
        // Fetch the last reset date
        resetRef.getDocument { (document, error) in
            guard let document = document, document.exists,
                  let lastResetTimestamp = document.get("lastReset") as? Timestamp else {
                print("error getting lastReset or fetching doc: \(String(describing: error))")
                return
            }
            
            let lastResetDate = lastResetTimestamp.dateValue()
            let currentDate = Date()
            
            // checking time since last reset
            let daysSinceLastReset = Calendar.current.dateComponents([.day], from: lastResetDate, to: currentDate).day ?? 0
            if daysSinceLastReset >= 7 {
                // set to closest prev sunday
                var lastSunday = Calendar.current.date(bySettingHour: 0, minute: 1, second: 0, of: currentDate) ?? currentDate
                let daysToSubtract = Calendar.current.component(.weekday, from: currentDate) - 1
                lastSunday = Calendar.current.date(byAdding: .day, value: -daysToSubtract, to: lastSunday) ?? lastSunday

                // update last reset in Firestore
                resetRef.updateData(["lastReset": Timestamp(date: lastSunday)]) { error in
                    if let error = error {
                        print("Error updating last reset date: \(error)")
                        return
                    }
                    
                    // Reset `weekMiles` for each rider
                    let ridersRef = Firestore.firestore().collection("riders")
                    ridersRef.getDocuments { (snapshot, error) in
                        if let error = error {
                            print("Error fetching riders: \(error)")
                            return
                        }
                        
                        guard let snapshot = snapshot else { return }
                        for document in snapshot.documents {
                            document.reference.updateData(["weekMiles": 0])
                            document.reference.updateData(["weekRides": 0]){ error in
                                if let error = error {
                                    print("Error resetting rider weekly stats \(document.documentID): \(error)")
                                }
                            }
                        }
                        
                        print("values updated to 0, last reset set to sunday")
                    }
                }
            } else {
                print("no reset needed")
            }
        }
    }
    
}
