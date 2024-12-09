import UIKit

class ChatView: UIView {
    var profilePic: UIImageView!
    var labelText: UILabel!
    var floatingButtonAddContact: UIButton!
    var tableViewContacts: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.systemGroupedBackground // 更柔和的背景
        
        setupProfilePic()
        setupLabelText()
        setupFloatingButtonAddContact()
        setupTableViewContacts()
        initConstraints()
    }
    
    //MARK: initializing the UI elements...
    func setupProfilePic(){
        profilePic = UIImageView()
        profilePic.image = UIImage(systemName: "figure.run")?.withTintColor(.blue, renderingMode: .alwaysOriginal)
        profilePic.contentMode = .scaleAspectFill
        profilePic.clipsToBounds = true
        profilePic.layer.cornerRadius = 20 // 圆形头像
        profilePic.layer.borderWidth = 2
        profilePic.layer.borderColor = UIColor.systemBlue.cgColor
        profilePic.layer.shadowColor = UIColor.black.cgColor
        profilePic.layer.shadowRadius = 4.0
        profilePic.layer.shadowOpacity = 0.2
        profilePic.layer.shadowOffset = CGSize(width: 0, height: 2)
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profilePic)
    }
    
    func setupLabelText(){
        labelText = UILabel()
        labelText.font = .systemFont(ofSize: 16, weight: .semibold)
        labelText.textColor = .systemGray
        labelText.textAlignment = .left
        labelText.translatesAutoresizingMaskIntoConstraints = false
        labelText.text = "Welcome,Trainer!"
        self.addSubview(labelText)
    }
    
    func setupTableViewContacts(){
        tableViewContacts = UITableView()
        tableViewContacts.register(ContactsTableViewCell.self, forCellReuseIdentifier: Configs.tableViewContactsID)
        tableViewContacts.layer.cornerRadius = 10
        tableViewContacts.layer.masksToBounds = true
        tableViewContacts.backgroundColor = .white
        tableViewContacts.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewContacts)
    }
    
    func setupFloatingButtonAddContact(){
        floatingButtonAddContact = UIButton(type: .system)
        floatingButtonAddContact.setImage(UIImage(systemName: "person.text.rectangle")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        floatingButtonAddContact.backgroundColor = UIColor.systemBlue
        floatingButtonAddContact.layer.cornerRadius = 24
        floatingButtonAddContact.layer.shadowColor = UIColor.black.cgColor
        floatingButtonAddContact.layer.shadowRadius = 5.0
        floatingButtonAddContact.layer.shadowOpacity = 0.3
        floatingButtonAddContact.layer.shadowOffset = CGSize(width: 0, height: 3)
        floatingButtonAddContact.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(floatingButtonAddContact)
    }
    
    //MARK: setting up constraints...
    func initConstraints(){
        NSLayoutConstraint.activate([
            // Profile Pic
            profilePic.widthAnchor.constraint(equalToConstant: 48),
            profilePic.heightAnchor.constraint(equalToConstant: 48),
            profilePic.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            profilePic.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            // Label Text
            labelText.centerYAnchor.constraint(equalTo: profilePic.centerYAnchor),
            labelText.leadingAnchor.constraint(equalTo: profilePic.trailingAnchor, constant: 8),
            labelText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            // Table View
            tableViewContacts.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 16),
            tableViewContacts.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            tableViewContacts.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewContacts.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            // Floating Button
            floatingButtonAddContact.widthAnchor.constraint(equalToConstant: 56),
            floatingButtonAddContact.heightAnchor.constraint(equalToConstant: 56),
            floatingButtonAddContact.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            floatingButtonAddContact.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

