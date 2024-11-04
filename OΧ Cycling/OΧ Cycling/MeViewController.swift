//  MeViewController.swift
//  OΧ Cycling
//

import UIKit
import FirebaseFirestore

class MeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var appDelegate: AppDelegate?
    var model: cycling_model?
    
    var rides: [String] = []
    
    @IBOutlet weak var weekMiles: UILabel!
    @IBOutlet weak var weekRides: UILabel!
    @IBOutlet weak var totalMiles: UILabel!
    @IBOutlet weak var rv: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.model = self.appDelegate?.model
        
        rv.delegate = self
        rv.dataSource = self
        rv.register(UITableViewCell.self, forCellReuseIdentifier: "RideCell")
        rv.layer.borderColor = UIColor.black.cgColor
        rv.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        rv.layer.borderWidth = 4.0
        rv.layer.cornerRadius = 5.0
        
        setStats()
        getRides()
    }
    
    //reload rides here
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getRides()
    }
    
    func setStats(){
        let db = Firestore.firestore()
        let riderRef = db.collection("riders").document(model!.name)
        riderRef.getDocument { (document, error) in
            if let error = error {
                //error case
                print("Error retrieving stats: \(error)")
                return
            }
            
            if let document = document, document.exists {
                // set fields
                let data = document.data()
                self.weekMiles.text = String(data?["weekMiles"] as? Double ?? 0.0)
                self.weekRides.text = String(data?["weekRides"] as? Int ?? 0)
                self.totalMiles.text = String(data?["totalMiles"] as? Double ?? 0.0)
            } else {
                //error case
                print("Document does not exist")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rides.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RideCell", for: indexPath)
        
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1.0
        cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        
        cell.textLabel?.text = rides[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = .black
        cell.textLabel?.layer.shadowOpacity = 0
        
        if indexPath.row == 0 {
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont(name: "MarkerFelt-Wide", size: 34)
            cell.backgroundColor = UIColor(red: 1.0, green: 0.30, blue: 0.30, alpha: 1.0)
            cell.textLabel?.textColor = .white
            cell.textLabel?.layer.shadowColor = UIColor.black.cgColor
            cell.textLabel?.layer.shadowOffset = CGSize(width: 3, height: 3)
            cell.textLabel?.layer.shadowOpacity = 0.8
            cell.textLabel?.layer.shadowRadius = 3
        } else {
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.font = UIFont(name: "AvenirNext-Regular", size: 18)
        }
        
        return cell
    }
    
    func getRides() {
        let db = Firestore.firestore()
        let riderRef = db.collection(model!.name).document(model!.name)
        
        riderRef.getDocument { (document, error) in
            if let error = error {
                //error case
                print("Error retrieving rides: \(error)")
                return
            }
            
            if let document = document, document.exists {
                print("found doc")
                let data = document.data()
                self.rides = data?["rides"] as? [String] ?? []
                DispatchQueue.main.async {
                    self.rv.reloadData()
                }
            } else {
                //error case
                print("Document does not exist")
            }
        }
    }

}
