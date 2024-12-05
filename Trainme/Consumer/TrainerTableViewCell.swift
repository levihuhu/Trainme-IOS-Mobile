//
//  TrainerTableViewCell.swift
//  Trainme
//
//  Created by levi cheng on 12/1/24.
//

import UIKit

class TrainerTableViewCell: UITableViewCell {

    // UI Elements
    let trainerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let trainerInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let trainerDetailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Setup UI
    private func setupUI() {
        contentView.addSubview(trainerImageView)
        contentView.addSubview(trainerInfoLabel)
        contentView.addSubview(trainerDetailsLabel)
        
        // Add Constraints
        NSLayoutConstraint.activate([
            // Image View
            trainerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            trainerImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            trainerImageView.widthAnchor.constraint(equalToConstant: 100),
            trainerImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // Trainer Info Label
            trainerInfoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            trainerInfoLabel.leadingAnchor.constraint(equalTo: trainerImageView.trailingAnchor, constant: 16),
            trainerInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Trainer Details Label
            trainerDetailsLabel.topAnchor.constraint(equalTo: trainerInfoLabel.bottomAnchor, constant: 8),
            trainerDetailsLabel.leadingAnchor.constraint(equalTo: trainerImageView.trailingAnchor, constant: 16),
            trainerDetailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            trainerDetailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    // Configure Cell
    func configure(with trainer: [String: Any]) {
        // Load the first image if available
        if let images = trainer["images"] as? [String], let firstImageUrl = images.first, let url = URL(string: firstImageUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.trainerImageView.image = image
                    }
                }
            }
        } else {
            self.trainerImageView.image = UIImage(systemName: "person.crop.circle") // Placeholder image
        }

        // Debug print for trainer data
        print("Trainer data being configured: \(trainer)")

        // Parse and display trainer details
        let name = trainer["name"] as? String ?? "Trainer"
        let location = trainer["location"] as? String ?? "Unknown Location"
        let experience = trainer["experience"] as? String ?? "N/A"
        let height = trainer["height"] as? String ?? "N/A"
        let weight = trainer["weight"] as? String ?? "N/A"
        let price = trainer["price"] as? String ?? "N/A"

        // Update labels
        trainerInfoLabel.text = "\(name) at \(location)"
        trainerDetailsLabel.text = """
        Experience: \(experience)
        Height: \(height)
        Weight: \(weight)
        Price: \(price)
        """
        
        // Debug print for labels
        print("trainerInfoLabel: \(trainerInfoLabel.text ?? "")")
        print("trainerDetailsLabel: \(trainerDetailsLabel.text ?? "")")
    }

}

