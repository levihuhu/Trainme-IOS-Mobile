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
        self.backgroundColor = .black
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let titleLabel = UILabel()
        titleLabel.text = "Welcome to Trainme"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28) // 字体变大
        titleLabel.textColor = UIColor(named: "Pink") ?? UIColor(red: 1.0, green: 0.4, blue: 0.7, alpha: 1.0) // 粉色标题
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        trainerButton.setTitle("I am a personal trainer", for: .normal)
        trainerButton.setTitleColor(.white, for: .normal) // 黑色文字
        trainerButton.backgroundColor = .black // 白色按钮背景
        trainerButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .medium) // 字体变大
        trainerButton.layer.cornerRadius = 10
        trainerButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(trainerButton)
        
        consumerButton.setTitle("I am looking for a personal trainer", for: .normal)
        consumerButton.setTitleColor(.white, for: .normal) // 黑色文字
        consumerButton.backgroundColor = .black // 白色按钮背景
        consumerButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .medium) // 字体变大
        consumerButton.layer.cornerRadius = 10
        consumerButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(consumerButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 100),
            trainerButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            trainerButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 180),
            trainerButton.widthAnchor.constraint(equalToConstant: 250),
            trainerButton.heightAnchor.constraint(equalToConstant: 60), // 按钮更高
            consumerButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            consumerButton.topAnchor.constraint(equalTo: trainerButton.bottomAnchor, constant: 20),
            consumerButton.widthAnchor.constraint(equalToConstant: 400),
            consumerButton.heightAnchor.constraint(equalToConstant: 60) // 按钮更高
        ])
    }
}

