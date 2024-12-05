
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
let db = Firestore.firestore()

class ChatViewController: UIViewController,UITableViewDelegate {
    
    let mainScreen = ChatView()
    var appointments: [[String: Any]] = []
    var handleAuth: AuthStateDidChangeListenerHandle?
    var currentUser: FirebaseAuth.User?
    var userRole: String?
    let db = Firestore.firestore()
    
    override func loadView() {
        view = mainScreen
        
        mainScreen.tableViewContacts.delegate = self
        mainScreen.tableViewContacts.dataSource = self
        mainScreen.tableViewContacts.separatorStyle = .none
        mainScreen.tableViewContacts.register(ContactsTableViewCell.self, forCellReuseIdentifier: "ContactsTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
            self.navigationItem.hidesBackButton = true
      

        
        handleAuth = Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.currentUser = user
            self.loadUserRole(for: user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        view.bringSubviewToFront(mainScreen.floatingButtonAddContact)
        mainScreen.floatingButtonAddContact.addTarget(self, action: #selector(didTapFloatingButton), for: .touchUpInside)
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let handleAuth = handleAuth {
            Auth.auth().removeStateDidChangeListener(handleAuth)
        }
    }
    
    private func fetchAppointments() {
        guard let currentUser = self.currentUser else { return }
        db.collection("notifications")
            .whereField("trainerId", isEqualTo: currentUser.uid)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching appointments: \(error.localizedDescription)")
                    return
                }
                self.appointments = snapshot?.documents.map { document in
                    var data = document.data()
                    data["docId"] = document.documentID
                    return data
                } ?? []
                self.appointments.sort {
                    let date1 = ($0["date"] as? Timestamp)?.dateValue() ?? Date.distantPast
                    let date2 = ($1["date"] as? Timestamp)?.dateValue() ?? Date.distantPast
                    return date1 < date2
                }
                DispatchQueue.main.async {
                    self.mainScreen.tableViewContacts.reloadData()
                }
            }
    }
    
    private func loadUserRole(for user: FirebaseAuth.User) {
        db.collection("users").document(user.uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching user role: \(error.localizedDescription)")
                return
            }
            if let data = snapshot?.data(),
               let role = data["role"] as? String {
                self.userRole = role
                DispatchQueue.main.async {
                    self.title = (role == "Trainer") ? "My Appointments" : "Find My Trainers"
                }
                if role == "Trainer" {
                    self.fetchAppointments()
                }
            }
        }
    }
    
    @objc private func didTapFloatingButton() {
        if self.userRole == "Trainer" {
            let trainerInfoVC = TrainerProfileViewController()
            self.navigationController?.pushViewController(trainerInfoVC, animated: true)
        }
    }
    
}

extension ChatViewController: ContactsTableViewCellDelegate {
    func didTapAccept(for bookingId: String) {
        guard let currentUser = currentUser else { return }
        
        db.collection("notifications").document(bookingId).updateData(["status": "accepted"]) { error in
            print("Accept button tapped for bookingId: \(bookingId)")
            if let error = error {
                print("Error accepting appointment: \(error.localizedDescription)")
            } else {
                let alert = UIAlertController(
                                  title: "Success",
                                  message: "Appointment accepted",
                                  preferredStyle: .alert
                              )
                              alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                              self.present(alert, animated: true, completion: nil)

                print("Appointment accepted")
                if let appointment = self.appointments.first(where: { $0["docId"] as? String == bookingId }),
                   let date = appointment["date"] as? Timestamp {
                    self.db.collection("availability").document(currentUser.uid).setData([
                        "unavailableDates": FieldValue.arrayUnion([date])
                    ], merge: true)
                }
            }
        }
    }
    
    func didTapDecline(for bookingId: String) {
        db.collection("notifications").document(bookingId).delete { error in
            print("Accept button tapped for bookingId: \(bookingId)")
            if let error = error {
                print("Error declining appointment: \(error.localizedDescription)")
            } else {
                let alert = UIAlertController(
                                  title: "Declined",
                                  message: "Appointment Declined",
                                  preferredStyle: .alert
                              )
                              alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                              self.present(alert, animated: true, completion: nil)

               
            }
        }
    }
}



