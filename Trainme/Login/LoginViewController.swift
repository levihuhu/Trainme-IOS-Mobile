//
//  ViewController.swift
//  Trainme
//
//  Created by levi cheng on 10/29/24.
///Users/levicheng/Desktop/VC/Trainme/Trainme/Login/LoginViewController.swift
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import FirebaseAppCheck



// MARK: - LoginViewController

class LoginViewController: UIViewController {
    var handleAuth: AuthStateDidChangeListenerHandle?
    var currentUser: FirebaseAuth.User?
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: Handling authentication state changes
        handleAuth = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            
            // Handle unauthenticated user early
            guard let user = user else {
                DispatchQueue.main.async {
                    self.showLoginView()
                }
                return
            }
            
            // Fetch user details from Firestore
            let db = Firestore.firestore()
            let userId = user.uid
            
            db.collection("users").document(userId).getDocument { document, error in
                if let error = error {
                    print("Error fetching user details: \(error.localizedDescription)")
                    return
                }
                
                if let document = document, document.exists {
                    let data = document.data()
                    let email = user.email ?? "No email"
                    let role = data?["role"] as? String ?? "No role"
                    
                    print("User is logged in: \(email) (\(role))")
                    
                    // Call handleLoggedInUser with the role
                    DispatchQueue.main.async {
                        self.handleLoggedInUser(user: user, role: role)
                    }
                } else {
                    print("User document does not exist. Please check Firestore setup or user registration process.")
                }
            }
        }
    }

    // Updated handleLoggedInUser to accept role as a parameter
    private func handleLoggedInUser(user: FirebaseAuth.User, role: String) {
        print("User is logged in: \(user.email ?? "No email") with role: \(role)")
        navigateToRoleBasedPage(role: role)
    }

    // Navigation based on role
    func navigateToRoleBasedPage(role: String) {
        if role == "Trainer" {
            // Navigate to Trainer page
            let chatVC = ChatViewController() // Assuming TrainerViewController exists
            self.navigationController?.pushViewController(chatVC, animated: true)
        } else if role == "Customer" {
            // Navigate to Customer page
            let customerVC = ConsumerMainPageViewController() // Assuming CustomerViewController exists
            customerVC.title = "Choose your trainers" // Set title
            self.navigationController?.pushViewController(customerVC, animated: true)
        } else {
            // Handle unknown role
            showAlert(title: "Error", message: "Unknown role selected")
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let handleAuth = handleAuth {
            Auth.auth().removeStateDidChangeListener(handleAuth)
        }
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }

    
    private func showLoginView() {
        // Clear existing subviews to prevent duplicates
        self.view.subviews.forEach { $0.removeFromSuperview() }
        
        self.view.backgroundColor = .white
        
        // Add LoginView
        let loginView = LoginView(frame: self.view.bounds)
        self.view.addSubview(loginView)
        
        // Set up Auto Layout
        loginView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalTo: self.view.topAnchor),
            loginView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            loginView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            loginView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        // Add button actions
        loginView.trainerButton.addTarget(self, action: #selector(onSignInBarButtonTapped), for: .touchUpInside)
        loginView.consumerButton.addTarget(self, action: #selector(onSignInBarButtonTapped), for: .touchUpInside)
    }

   

   
    @objc func onSignInBarButtonTapped(){
        let signInAlert = UIAlertController(
            title: "Sign In / Register",
            message: "Please sign in to continue.",
            preferredStyle: .alert)
        
        //MARK: setting up email textField in the alert...
        signInAlert.addTextField{ textField in
            textField.placeholder = "Enter email"
            textField.contentMode = .center
            textField.keyboardType = .emailAddress
        }
        
        //MARK: setting up password textField in the alert...
        signInAlert.addTextField{ textField in
            textField.placeholder = "Enter password"
            textField.contentMode = .center
            textField.isSecureTextEntry = true
        }
        
        //MARK: Sign In Action...
        //MARK: Sign In Action...
        let signInAction = UIAlertAction(title: "Sign In", style: .default, handler: { (_) in
            if let email = signInAlert.textFields?[0].text,
               let password = signInAlert.textFields?[1].text {
 
                // Firebase Authentication 登录
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
             
                    if let error = error {
                        // 显示错误信息
                        self.showAlert(title: "Error", message: error.localizedDescription)
                    } else if let user = result?.user {
                        // 登录成功，获取用户角色
                        let db = Firestore.firestore()
                        db.collection("users").document(user.uid).getDocument { snapshot, error in
                            if let error = error {
                                // 获取失败，显示错误信息
                                self.showAlert(title: "Error", message: "Failed to fetch user role: \(error.localizedDescription)")
                            } else if let data = snapshot?.data(), let role = data["role"] as? String {
                                // 根据角色跳转页面
                                self.navigateToRoleBasedPage(role: role)
                            } else {
                                // 数据不完整
                                self.showAlert(title: "Error", message: "User role not found")
                            }
                        }
                    }
                }
            }
        })
 



        //MARK: Register Action...
     
        let registerAction = UIAlertAction(title: "Register", style: .default, handler: {(_) in
                   //MARK: logic to open the register screen...
                   let registerViewController = RegisterViewController()
                   self.navigationController?.pushViewController(registerViewController, animated: true)
               })
        
        //MARK: action buttons...
        signInAlert.addAction(signInAction)
        signInAlert.addAction(registerAction)
        
        self.present(signInAlert, animated: true, completion: {() in
            //MARK: hide the alerton tap outside...
            signInAlert.view.superview?.isUserInteractionEnabled = true
            signInAlert.view.superview?.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(self.onTapOutsideAlert))
            )
        })
    }
    @objc func onTapOutsideAlert(){
        self.dismiss(animated: true)
    }

}
