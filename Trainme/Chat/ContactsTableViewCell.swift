import UIKit

protocol ContactsTableViewCellDelegate: AnyObject {
    func didTapAccept(for bookingId: String)
    func didTapDecline(for bookingId: String)
}

class ContactsTableViewCell: UITableViewCell {
    
    var labelName: UILabel!
    var labelEmail: UILabel!
    var labelPhone: UILabel!
    var acceptButton: UIButton!
    var declineButton: UIButton!
    
    weak var delegate: ContactsTableViewCellDelegate?
    var bookingId: String? // The ID of the booking in Firestore
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupContentView()
        setupLabelName()
        setupLabelEmail()
        setupLabelPhone()
        setupButtons()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContentView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 6.0
        contentView.layer.borderColor = UIColor.lightGray.cgColor // Set border color
        contentView.layer.borderWidth = 1.0 // Set border width
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 5.0
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.masksToBounds = false
        contentView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    }

    
    func setupLabelName() {
        labelName = UILabel()
        labelName.font = UIFont.boldSystemFont(ofSize: 20)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelName)
    }
    
    func setupLabelEmail() {
        labelEmail = UILabel()
        labelEmail.font = UIFont.systemFont(ofSize: 14)
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelEmail)
    }
    
    func setupLabelPhone() {
        labelPhone = UILabel()
        labelPhone.font = UIFont.systemFont(ofSize: 14)
        labelPhone.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelPhone)
    }
    
    func setupButtons() {
        acceptButton = UIButton(type: .system)
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.backgroundColor = .systemGreen
        acceptButton.setTitleColor(.white, for: .normal)
        acceptButton.layer.cornerRadius = 4.0
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.addTarget(self, action: #selector(acceptTapped), for: .touchUpInside)
        contentView.addSubview(acceptButton)
        
        declineButton = UIButton(type: .system)
        declineButton.setTitle("Decline", for: .normal)
        declineButton.backgroundColor = .systemRed
        declineButton.setTitleColor(.white, for: .normal)
        declineButton.layer.cornerRadius = 4.0
        declineButton.translatesAutoresizingMaskIntoConstraints = false
        declineButton.addTarget(self, action: #selector(declineTapped), for: .touchUpInside)
        contentView.addSubview(declineButton)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Label Name Constraints
            labelName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            labelName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelName.trailingAnchor.constraint(lessThanOrEqualTo: acceptButton.leadingAnchor, constant: -8),
            
            // Label Email Constraints
            labelEmail.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 4),
            labelEmail.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            labelEmail.trailingAnchor.constraint(equalTo: labelName.trailingAnchor),
            
            // Label Phone Constraints
            labelPhone.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 4),
            labelPhone.leadingAnchor.constraint(equalTo: labelEmail.leadingAnchor),
            labelPhone.trailingAnchor.constraint(equalTo: labelEmail.trailingAnchor),
            labelPhone.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            
            // Accept Button Constraints
            acceptButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            acceptButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            acceptButton.widthAnchor.constraint(equalToConstant: 80),
            acceptButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Decline Button Constraints
            declineButton.topAnchor.constraint(equalTo: acceptButton.bottomAnchor, constant: 8),
            declineButton.trailingAnchor.constraint(equalTo: acceptButton.trailingAnchor),
            declineButton.widthAnchor.constraint(equalTo: acceptButton.widthAnchor),
            declineButton.heightAnchor.constraint(equalTo: acceptButton.heightAnchor),
            declineButton.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    @objc private func acceptTapped() {
        guard let bookingId = bookingId else { return }
        print("Accept button clicked")
        delegate?.didTapAccept(for: bookingId)
    }
    
    @objc private func declineTapped() {
        guard let bookingId = bookingId else { return }
        print("Decline button clicked")
        delegate?.didTapDecline(for: bookingId)
    }
}

