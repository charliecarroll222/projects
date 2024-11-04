//  TeamViewController.swift
//  OΧ Cycling
//

import UIKit
import FirebaseFirestore

class TeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1.0
        cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        
        cell.textLabel?.text = posts[indexPath.row]
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
            cell.textLabel?.font = UIFont(name: "AvenirNext-Regular", size: 16)
        }
        
        return cell
    }
    

    var appDelegate: AppDelegate?
    var model: cycling_model?
    var posts: [String] = []
    private let postService = PostService()
    
    @IBOutlet weak var pv: UITableView!
    @IBOutlet weak var addPostButton: UIButton!
    @IBOutlet weak var teamWeekMiles: UILabel!
    @IBOutlet weak var mostMiles: UILabel!
    @IBOutlet weak var mostRides: UILabel!
    @IBOutlet weak var inputField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.model = self.appDelegate?.model
        setStats()
        
        inputField.isHidden = true
        inputField.placeholder = "Type post here, hit enter when done"
        inputField.returnKeyType = .done
        inputField.addTarget(self, action: #selector(inputFieldReturnPressed), for: .editingDidEndOnExit)
        
        pv.layer.borderColor = UIColor.black.cgColor
        pv.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        pv.layer.borderWidth = 4.0
        pv.layer.cornerRadius = 5.0
        pv.delegate = self
        pv.dataSource = self
        pv.register(UITableViewCell.self, forCellReuseIdentifier: "PostCell")
        
        loadPosts()
    }
    
    func setStats(){
        model!.getWeeklyMiles{
            self.teamWeekMiles.text = String(self.model!.getWeekTotal())
            self.mostMiles.text = self.model!.getMostMiles()
        }
        model!.getWeeklyRides{
            self.mostRides.text = self.model!.getMostRides()
        }
        
    }
    
    func loadPosts() {
        postService.getPosts { [weak self] posts, error in
            if let error = error {
                print("Error fetching posts: \(error)")
                return
            }
            print("loading finished")
            self?.posts = posts ?? []
            self?.pv.reloadData()
        }
    }
    
    @IBAction func addPostButton(_ sender: UIButton){
        sender.alpha = 1.0
        print("button clicked")
        addPostButton.isHidden = true
        inputField.isHidden = false
    }
    
    @objc func inputFieldReturnPressed() {
        guard let postContent = inputField.text, !postContent.isEmpty else {
            addPostButton.isHidden = false
            inputField.isHidden = true
            return
        }
            
        let timestamp = Date().timeIntervalSince1970
        let username = model!.name
        addPostButton.isHidden = false
        inputField.isHidden = true
            
            // Call addPost to save to Firebase
        postService.addPost(content: postContent, username: username) { [weak self] error in
            if let error = error {
                print("Error adding post: \(error)")
            } else {
                //load new post
                self?.inputField.text = ""
                self?.loadPosts()
            }
        }
    }
    //highlight
    @IBAction func buttonTouchDown(_ sender: UIButton) {
        sender.alpha = 0.5
    }

}

class PostService{
    private let db = Firestore.firestore()
    private let collection = "posts"
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
    func addPost(content: String, username: String, completion: @escaping (Error?) -> Void) {
            let db = Firestore.firestore()
            let postsRef = db.collection("posts").document("posts")
            
            // create post string
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            let dateString = dateFormatter.string(from: date)
            let formattedPost = "\(dateString) - \(username): \(content)"
            
            // add post to firebase array
            postsRef.updateData([
                "posts": FieldValue.arrayUnion([formattedPost])
            ]) { error in
                completion(error)
            }
        }
    func getPosts(completion: @escaping ([String]?, Error?) -> Void) {
        let db = Firestore.firestore()
        let postsRef = db.collection("posts").document("posts")
        
        postsRef.getDocument { document, error in
            if let error = error {
                completion(nil, error)
            } else if let document = document, let data = document.data(), let postsArray = data["posts"] as? [String] {
                completion(postsArray, nil)
            } else {
                completion([], nil)
            }
        }
    }
}
