import UIKit

protocol ContactsTableViewCellDelegate: AnyObject {
    func didTapAccept(for bookingId: String)
    func didTapDecline(for bookingId: String)
}

class ContactsTableViewCell: UITableViewCell {
    
    var labelName: UILabel!
    var labelEmail: UILabel!
    var labelPhone: UILabel!
    var separator1: UIView!
    var separator2: UIView!
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
        setupSeparators()
        setupButtons()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContentView() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10.0
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.layer.borderWidth = 1.0
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.shadowRadius = 6.0
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.masksToBounds = false
    }
    
    func setupLabelName() {
        labelName = UILabel()
        labelName.font = UIFont.boldSystemFont(ofSize: 18)
        labelName.textColor = .black
        labelName.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelName)
    }
    
    func setupLabelEmail() {
        labelEmail = UILabel()
        labelEmail.font = UIFont.systemFont(ofSize: 14)
        labelEmail.textColor = .darkGray
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelEmail)
    }
    
    func setupLabelPhone() {
        labelPhone = UILabel()
        labelPhone.font = UIFont.systemFont(ofSize: 14)
        labelPhone.textColor = .darkGray
        labelPhone.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelPhone)
    }
    
    func setupSeparators() {
        separator1 = UIView()
        separator1.backgroundColor = UIColor.systemGray4
        separator1.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separator1)
        
        separator2 = UIView()
        separator2.backgroundColor = UIColor.systemGray4
        separator2.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separator2)
    }
    
    func setupButtons() {
        acceptButton = UIButton(type: .system)
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.backgroundColor = UIColor.systemGreen
        acceptButton.setTitleColor(.white, for: .normal)
        acceptButton.layer.cornerRadius = 15.0
        acceptButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        acceptButton.addTarget(self, action: #selector(acceptTapped), for: .touchUpInside)
        contentView.addSubview(acceptButton)
        
        declineButton = UIButton(type: .system)
        declineButton.setTitle("Decline", for: .normal)
        declineButton.backgroundColor = UIColor.systemRed
        declineButton.setTitleColor(.white, for: .normal)
        declineButton.layer.cornerRadius = 15.0
        declineButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        declineButton.translatesAutoresizingMaskIntoConstraints = false
        declineButton.addTarget(self, action: #selector(declineTapped), for: .touchUpInside)
        contentView.addSubview(declineButton)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // Label Name
            labelName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            labelName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Separator 1
            separator1.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 8),
            separator1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separator1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separator1.heightAnchor.constraint(equalToConstant: 1),
            
            // Label Email
            labelEmail.topAnchor.constraint(equalTo: separator1.bottomAnchor, constant: 8),
            labelEmail.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            labelEmail.trailingAnchor.constraint(equalTo: labelName.trailingAnchor),
            
            // Separator 2
            separator2.topAnchor.constraint(equalTo: labelEmail.bottomAnchor, constant: 8),
            separator2.leadingAnchor.constraint(equalTo: separator1.leadingAnchor),
            separator2.trailingAnchor.constraint(equalTo: separator1.trailingAnchor),
            separator2.heightAnchor.constraint(equalToConstant: 1),
            
            // Label Phone
            labelPhone.topAnchor.constraint(equalTo: separator2.bottomAnchor, constant: 8),
            labelPhone.leadingAnchor.constraint(equalTo: labelName.leadingAnchor),
            labelPhone.trailingAnchor.constraint(equalTo: labelName.trailingAnchor),
            
            // Accept Button
            acceptButton.topAnchor.constraint(equalTo: labelPhone.bottomAnchor, constant: 12),
            acceptButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            acceptButton.widthAnchor.constraint(equalToConstant: 100),
            acceptButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Decline Button
            declineButton.centerYAnchor.constraint(equalTo: acceptButton.centerYAnchor),
            declineButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            declineButton.widthAnchor.constraint(equalTo: acceptButton.widthAnchor),
            declineButton.heightAnchor.constraint(equalTo: acceptButton.heightAnchor),
            
            // ContentView Bottom
            declineButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func acceptTapped() {
        guard let bookingId = bookingId else { return }
        delegate?.didTapAccept(for: bookingId)
    }
    
    @objc private func declineTapped() {
        guard let bookingId = bookingId else { return }
        delegate?.didTapDecline(for: bookingId)
    }
}

