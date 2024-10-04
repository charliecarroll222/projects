//
//  GemTableViewController.swift
//  CasinoGame
//
//  Created by Charles Carroll on 4/11/24.
//
// Charles Carroll (chajcarr), Anthony Reyes (antreye)
// App Name: Diamond Dunes Casinno
// Final Project Submission Date: 04/28/2024

import UIKit


class GemTableViewController: UIViewController {
    
    var appDelegate: AppDelegate?
    var model: CasinoModel?
    
    @IBOutlet weak var buttonsView: UITableView!
    let buttonTitles = ["ADD 10 GEMS", "ADD 25 GEMS", "ADD 50 GEMS", "ADD A DIAMOND (150 GEMS)"]
    let buttonColors = [UIColor.systemBlue, UIColor.green, UIColor.orange, UIColor.systemPink]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.model = self.appDelegate?.model
    }

  
 
    
    
    @IBAction func add10Gems(_ sender:Any) {
        model?.add10Gems()
    }
    @IBAction func add25Gems(_ sender:Any) {
        model?.add25Gems()
    }
    @IBAction func add50Gems(_ sender:Any) {
        model?.add50Gems()
    }
    @IBAction func add1500Gems(_ sender:Any) {
        model?.add150Gems()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
