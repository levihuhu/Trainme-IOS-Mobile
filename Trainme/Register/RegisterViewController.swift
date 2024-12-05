//
//  RegisterViewController.swift
//  Trainme
//
//  Created by levi cheng on 11/19/24.
//


import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {
    let childProgressView = ProgressSpinnerViewController()
    let registerView = RegisterView()
    
    override func loadView() {
        view = registerView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        registerView.buttonRegister.addTarget(self, action: #selector(onRegisterTapped), for: .touchUpInside)
        title = "Register"
    }
    
    @objc func onRegisterTapped(){
        //MARK: creating a new user on Firebase...
        registerNewAccount()
    }
    
    
}
