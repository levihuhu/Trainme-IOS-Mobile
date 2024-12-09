//
//  TrainerProgressIndicatorManager.swift
//  Trainme
//
//  Created by levi cheng on 11/29/24.
//

//

import Foundation

extension TrainerProfileViewController:ProgressSpinnerDelegate{
    func showActivityIndicator(){
        addChild(childProgressView)
        view.addSubview(childProgressView.view)
        childProgressView.didMove(toParent: self)
    }
    
    func hideActivityIndicator(){
        childProgressView.willMove(toParent: nil)
        childProgressView.view.removeFromSuperview()
        childProgressView.removeFromParent()
    }
}
