//
//  LoginView.swift
//  Trainme
//
//  Created by levi cheng on 10/29/24.
//

import UIKit

// MARK: - Separate UI View Files
class LoginView: UIView {
    let trainerButton = UIButton(type: .system)
    let consumerButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let titleLabel = UILabel()
        titleLabel.text = "Welcome to FitConnect"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        trainerButton.setTitle("I am a personal trainer", for: .normal)
        trainerButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(trainerButton)
        
        consumerButton.setTitle("I am looking for a personal Trainer ", for: .normal)
        consumerButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(consumerButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 100),
            trainerButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            trainerButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            consumerButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            consumerButton.topAnchor.constraint(equalTo: trainerButton.bottomAnchor, constant: 20)
        ])
    }
}

