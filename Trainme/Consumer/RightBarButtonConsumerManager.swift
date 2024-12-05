//
//  RightBarButtonManager.swift
//  Trainme
//
//  Created by levi cheng on 12/1/24.
//


//

import UIKit
import FirebaseAuth

extension ConsumerMainPageViewController{
    func setupRightBarButton(){
      
            //MARK: user is logged in...
            let barIcon = UIBarButtonItem(
                image: UIImage(systemName: "rectangle.portrait.and.arrow.forward"),
                style: .plain,
                target: self,
                action: #selector(onLogOutBarButtonTapped)
            )
            let barText = UIBarButtonItem(
                title: "Logout",
                style: .plain,
                target: self,
                action: #selector(onLogOutBarButtonTapped)
            )
            
            navigationItem.rightBarButtonItems = [barIcon, barText]
            
        
    }
    
  
    
    @objc func onLogOutBarButtonTapped(){
        let logoutAlert = UIAlertController(title: "Logging out", message: "Are you sure want to log out?",
            preferredStyle: .actionSheet)
        logoutAlert.addAction(UIAlertAction(title: "Yes, log out", style: .default, handler: {(_) in
                do{
                    try Auth.auth().signOut()
                   
                    let loginVC = LoginViewController()
                             
                             // Push the LoginViewController onto the navigation stack
                    self.navigationController?.pushViewController(loginVC, animated: true)
                }catch{
                    print("Error occured!")
                }
            })
        )
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(logoutAlert, animated: true)
    }

    
}

