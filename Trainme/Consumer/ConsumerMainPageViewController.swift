//
//  ConsumerMainPageViewController.swift
//  Trainme
//
//  Created by levi cheng on 10/29/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ConsumerMainPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let db = Firestore.firestore()
    var trainers: [[String: Any]] = []
    let trainersTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let consumerMainPageView = ConsumerMainPageView(frame: self.view.frame, controller: self)
        self.view.backgroundColor = .white
        self.title = "Choose Your Trainers"
        self.view = consumerMainPageView
        trainersTableView.delegate = self
        trainersTableView.dataSource = self
        trainersTableView.register(TrainerTableViewCell.self, forCellReuseIdentifier: "TrainerTableViewCell")
        loadTrainerData()
        setupRightBarButton()
       
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }


        @objc func showMyAppointments() {
            guard let currentUserId = Auth.auth().currentUser?.uid else {
                    print("No user is currently logged in.")
                    return
                }
                let appointmentListVC = AppointmentListViewController()
                self.navigationController?.pushViewController(appointmentListVC, animated: true)
        }
           // TODO: Push to a new view controller with actual appointment data
       
    
    private func loadTrainerData() {
        db.collection("trainers").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error loading trainers: \(error.localizedDescription)")
            } else {
                self.trainers = snapshot?.documents.map { $0.data() } ?? []
                print("Loaded trainers: \(self.trainers)") 
                DispatchQueue.main.async {
                               self.trainersTableView.reloadData() // Reload data on the main thread
                           }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of trainers: \(trainers.count)") // Debug
        return trainers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrainerTableViewCell", for: indexPath) as! TrainerTableViewCell
        let trainer = trainers[indexPath.row]
        print("Configuring cell for trainer: \(trainer)") 
        cell.configure(with: trainer)
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trainer = trainers[indexPath.row]
        let appointmentVC = AppointmentViewController()
        
        appointmentVC.trainerData = trainer
        navigationController?.pushViewController(appointmentVC, animated: true)
    }
}
