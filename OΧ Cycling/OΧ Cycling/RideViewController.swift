//  RideViewController.swift
//  OΧ Cycling
//

import UIKit
import MapKit
import CoreLocation

class RideViewController: UIViewController {
    
    var appDelegate: AppDelegate?
    var model: cycling_model?
    
    //initial layout items
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var inputRide: UIButton!
    @IBOutlet weak var startRide: UIButton!
    @IBOutlet weak var crest: UIImageView!
    @IBOutlet weak var crest2: UIImageView!
    @IBOutlet weak var logo: UIImageView!
    
    //input ride items
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var enter: UIButton!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var tryAgain: UILabel!
    
    //new ride items
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var pauseResume: UIButton!
    @IBOutlet weak var finish: UIButton!
    
    //map set up
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var previousLocation: CLLocation?
    var locations: [CLLocation] = []
    
    //ride statistic items
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    var rideTimer: Timer?
    var startTime: Date?
    var elapsedTime: TimeInterval = 0.0
    var ridingStatus: Bool = true
    var d:Double = 0
    var dur:Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.model = self.appDelegate?.model
        
        inputRide.layer.borderWidth = 3.0
        inputRide.layer.borderColor = UIColor.black.cgColor
        inputRide.layer.cornerRadius = 10.0
        startRide.layer.borderWidth = 3.0
        startRide.layer.borderColor = UIColor.black.cgColor
        startRide.layer.cornerRadius = 10.0
        
        map.isHidden = true
        inputLabel.isHidden = true
        tryAgain.isHidden = true
        inputField.isHidden = true
        enter.isHidden = true
        pauseResume.isHidden = true
        start.isHidden = true
        finish.isHidden = true
        distanceLabel.isHidden = true
        timerLabel.isHidden = true
        crest.isHidden = false
        crest2.isHidden = false
        logo.isHidden = false
        model!.getCurrentUserName()
    }
    
    @IBAction func inputRide(_ sender: UIButton){
        sender.alpha = 1.0
        startRide.isHidden = true
        inputRide.isHidden = true
        map.isHidden = true
        inputLabel.isHidden = false
        inputField.isHidden = false
        enter.isHidden = false
        enter.layer.borderWidth = 2.0
        enter.layer.borderColor = UIColor.black.cgColor
        enter.layer.cornerRadius = 5.0
    }
    
    @IBAction func enter(_ sender: UIButton){
        sender.alpha = 1.0
        if(inputLabel.text == "ENTER DISTANCE RIDDEN"){
            inputLabel.text = "ENTER DURATION (MINUTES)"
            if let distanceText = inputField.text, let distance = Double(distanceText) {
                model!.myWeekMiles += distance
                model!.myTotalMiles += distance
                d += distance
                print("adding ", d, "miles")
                model!.processMiles(m: d)
                inputField.text = ""
                tryAgain.isHidden = true
                    } else {
                        tryAgain.isHidden = false
                    }
        } else{
            if let durationText = inputField.text, let duration = Double(durationText) {
                model!.myWeekRides += 1
                model!.myTotalRides += 1
                dur += duration
                tryAgain.isHidden = true
                enter.isHidden = true
                inputField.isHidden = true
                inputLabel.isHidden = true
                inputRide.isHidden = false
                startRide.isHidden = false
                model!.addRide(distance: d, duration: dur){ [weak self] error in
                    if let error = error {
                        print("Error adding ride: \(error)")
                    }
                }
                d = 0
                dur = 0
            } else {
                tryAgain.isHidden = false
            }
        }
    }
    
    @IBAction func startRide(_ sender: UIButton){
        sender.alpha = 1.0
        inputRide.isHidden = true
        startRide.isHidden = true
        logo.isHidden = true
        
        map.isHidden = false
        start.isHidden = false
        
        //locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            map.showsUserLocation = true
            guard let currentLocation = locationManager.location else {
                        print("Current location not available yet.")
                        return
                    }
            let region = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 1609, longitudinalMeters: 1609)
            map.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        self.currentLocation = currentLocation
        self.locations.append(currentLocation)
        if previousLocation == nil {
            let region = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 1609, longitudinalMeters: 1609)
            map.setRegion(region, animated: true)
            } else {
                updatePath()
            }
            previousLocation = currentLocation
        }
    
    //if no location permissions
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.startUpdatingLocation()
            case .denied, .restricted:
                break
            default:
                break
            }
        }
    
    func updatePath() {
            let coordinates = locations.map { $0.coordinate }
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            map.addOverlay(polyline)
        }
    
    func map(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 4.0
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    @IBAction func start(_ sender: UIButton){
        sender.alpha = 1.0
        timerLabel.isHidden = false
        timerLabel.text = "00:00:00"
        timerLabel.layer.borderWidth = 2.0
        timerLabel.layer.borderColor = UIColor.black.cgColor
        
        distanceLabel.isHidden = false
        distanceLabel.text = "0.00"
        distanceLabel.layer.borderWidth = 2.0
        distanceLabel.layer.borderColor = UIColor.black.cgColor
        
        start.isHidden = true
        pauseResume.isHidden = false
        finish.isHidden = false
        ridingStatus = true
        crest.isHidden = true
        crest2.isHidden = true
        
        startTime = Date()
        rideTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)

    }
    
    @objc func updateTimerLabel() {
            // Calculate elapsed time since the timer started
            if let start = startTime {
                elapsedTime = Date().timeIntervalSince(start)
                timerLabel.text = formatTime(elapsedTime)
            }
        }
    
    func formatTime(_ timeInterval: TimeInterval) -> String {
            let hours = Int(timeInterval) / 3600
            let minutes = Int(timeInterval) / 60 % 60
            let seconds = Int(timeInterval) % 60
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    
    @IBAction func finish(_ sender: UIButton){
        sender.alpha = 1.0
        //distance input
        guard let distanceText = distanceLabel.text, let distance = Double(distanceText) else {
            print("Invalid distance value")
            return
        }

        //duration input
        let timerText = timerLabel.text ?? "0"
        let components = timerText.split(separator: ":").map { String($0) }
        guard components.count == 3,
            let hours = Double(components[0]),
            let minutes = Double(components[1]),
            let seconds = Double(components[2]) 
        else {
            print("Invalid duration value")
            return
        }
        dur = hours * 60 + minutes + seconds / 60
        dur = (dur * 100).rounded() / 100.0
        
        //add ride for this rider
        model!.addRide(distance: distance, duration: dur){ [weak self] error in
            if let error = error {
                print("Error adding ride: \(error)")
            } else {
                return
            }
        }
        dur = 0
        
        rideTimer?.invalidate()
        rideTimer = nil
        pauseResume.isHidden = true
        finish.isHidden = true
        distanceLabel.isHidden = true
        timerLabel.isHidden = true
        startRide.isHidden = false
        inputRide.isHidden = false
        map.isHidden = true
        crest.isHidden = false
        crest2.isHidden = false
        logo.isHidden = false
        model!.processMiles(m: Double(distanceLabel.text!)!)
    }
    
    @IBAction func pauseResume(_ sender: UIButton){
        sender.alpha = 1.0
        if ridingStatus == true {
            pauseResume.titleLabel?.text = "RESUME RIDE"
            //pauseResume.titleLabel?.font = UIFont(name: "Chalkduster", size: 25.0)
            pauseTimer()
            ridingStatus = false
        } else {
            //pauseResume.titleLabel?.font = UIFont(name: "Chalkduster", size: 25.0)
            resumeTimer()
            ridingStatus = true
        }
    }
    
    func pauseTimer() {
        if let start = startTime {
            elapsedTime = Date().timeIntervalSince(start)
        }
        rideTimer?.invalidate()
        rideTimer = nil
    }
    
    func resumeTimer() {
        if startTime == nil {
            startTime = Date()
        } else {
            startTime = Date() - elapsedTime
        }
        rideTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
    }
    
    //highlight
    @IBAction func buttonTouchDown(_ sender: UIButton) {
        sender.alpha = 0.5
    }


}
