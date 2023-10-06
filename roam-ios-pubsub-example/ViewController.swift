//
//  ViewController.swift
//  Roam-SDK-Demo
//
//  Created by MacBook on 13/09/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var userALabel: UILabel!
    @IBOutlet weak var userBLabel: UILabel!
    
    @IBOutlet weak var didUpdateLabel: UILabel!
    @IBOutlet weak var didReceiveLabel: UILabel!
    
    @IBOutlet weak var userSegement: UISegmentedControl!

    @IBOutlet weak var getUserButton: UIButton!
    @IBOutlet weak var startTracking: UIButton!
    
//    @IBOutlet weak var subscribe: UISegmentedControl!

//    @IBOutlet weak var getUserButton: UIButton!
    
    @IBOutlet weak var publishSaveSwitch: UISwitch!

    @IBOutlet weak var stopracking: UIButton!
    @IBOutlet weak var publishLabel: UILabel!
    
    let userAId = ""
    let userBId = ""
    
    #error("Add userAId and userBId")
    
    var loggedinUser: String = ""
    
    var didUpdateLocationCount = 0
    var didReceiveUserLocationCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userALabel.text = "User A: " + userAId
        userBLabel.text = "User B: " + userBId
        
        updateCount()
        
        
 
    }
    
    func updateCount() {
        didUpdateLabel.text = "didUpdateLocation: " + "\(LocationTracker.shared.didUpdateLocationCount)"
        didReceiveLabel.text = "didReceiveUserLocation: " + "\(LocationTracker.shared.didReceiveUserLocationCount)"
        
        LocationTracker.shared.didUpdateCount = { [weak self] in
            DispatchQueue.main.async {
                self?.didUpdateLabel.text = "didUpdateLocation: " + "\(LocationTracker.shared.didUpdateLocationCount)"
                self?.didReceiveLabel.text = "didReceiveUserLocation: " + "\(LocationTracker.shared.didReceiveUserLocationCount)"
            }
        }
    }
    
    @IBAction func userSegmentAction(_ sender: Any) {
        if userSegement.selectedSegmentIndex == 1{
           
        }else if userSegement.selectedSegmentIndex == 0{

        }
    }
    
    @IBAction func requestLocation(_ sender: UIButton) {
        LocationTracker.shared.requestUserLocation()
    }
    
    
    @IBAction func getUserClicked(_ sender: UIButton) {
        let user: String = userSegement.selectedSegmentIndex == 0 ? userAId : userBId
        
        LocationTracker.shared.getUser(roamUserId: user) { User in
            print(User?["userId"] ?? "")
            self.loggedinUser = User?["userId"] as? String ?? ""
        }
    }
    
    @IBAction func logoutButtonClicked(_ sender: UIButton) {
        LocationTracker.shared.logoutUser()
    }
    
    @IBAction func subscribeClicked(_ sender: UIButton) {
        LocationTracker.shared.subscribeUsers([userAId , userBId])
    }

    @IBAction func onStartButtonClicked(_ sender: UIButton) {
        LocationTracker.shared.startUserTracking()
    }
    
    @IBAction func onStopButtonClicked(_ sender: UIButton) {
        LocationTracker.shared.stopTracking()
    }

}

