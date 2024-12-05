import FirebaseFirestore
import FirebaseAuth
extension RegisterViewController {

    func registerNewAccount() {
        if let name = registerView.textFieldName.text,
           let email = registerView.textFieldEmail.text,
           let role = registerView.roleSegmentControl.titleForSegment(at: registerView.roleSegmentControl.selectedSegmentIndex),
           let password = registerView.textFieldPassword.text {
            // Validations....
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    // Error creating the user
                    print(error.localizedDescription)
                } else if let user = result?.user {
                    // User creation successful
                    self.showActivityIndicator()
                    self.setNameOfTheUserInFirebaseAuth(name: name)
                    
                    // Save additional user details (e.g., role) in Firestore
                    let db = Firestore.firestore()
                    db.collection("users").document(user.uid).setData([
                        "name": name,
                        "email": email,
                        "role": role
                    ]) { error in
                        if let error = error {
                            print("Error saving user data: \(error.localizedDescription)")
                        } else {
                            print("User data saved successfully.")
                        }
                    }
                }
            }
        }
    }

    // Update user's display name in Firebase Auth
    func setNameOfTheUserInFirebaseAuth(name: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { error in
            if error == nil {
                // Profile update successful
                self.navigateToRoleBasedView()
            } else {
                print("Error occurred: \(String(describing: error))")
            }
        }
    }

    // Navigate based on user role
    func navigateToRoleBasedView() {
        guard let user = Auth.auth().currentUser else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
            } else if let data = snapshot?.data(), let role = data["role"] as? String {
                // Navigate to different views based on role
                if role == "Trainer" {
                    let trainerVC = TrainerProfileViewController() // Replace with actual Trainer VC
                    self.navigationController?.pushViewController(trainerVC, animated: true)
                } else if role == "Customer" {
                    let customerVC = ConsumerMainPageViewController() // Replace with actual Customer VC
                    self.hideActivityIndicator()
                    self.navigationController?.pushViewController(customerVC, animated: true)
                }
            }
        }
    }
}
