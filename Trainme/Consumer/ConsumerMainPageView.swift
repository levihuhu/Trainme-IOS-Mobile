import UIKit

class ConsumerMainPageView: UIView {
    init(frame: CGRect, controller: ConsumerMainPageViewController) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupMyAppointmentLabel(controller: controller)
        setupUI(controller: controller)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let myAppointmentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40, weight: .medium)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加 SF Symbol
        let attributedText = NSMutableAttributedString()
        if let calendarIcon = UIImage(systemName: "calendar")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20)) {
            let attachment = NSTextAttachment()
            attachment.image = calendarIcon
            attachment.bounds = CGRect(x: 0, y: -3, width: 40, height: 40)
            attributedText.append(NSAttributedString(attachment: attachment))
        }
        attributedText.append(NSAttributedString(string: "\nMy Appointment", attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: UIColor.systemBlue
        ]))
        
        label.attributedText = attributedText
        label.numberOfLines = 2 // 支持多行显示
        return label
    }()
    
    private func setupUI(controller: ConsumerMainPageViewController) {
        controller.trainersTableView.translatesAutoresizingMaskIntoConstraints = false
        controller.trainersTableView.layer.cornerRadius = 10
        controller.trainersTableView.separatorStyle = .singleLine
        controller.trainersTableView.tableFooterView = UIView()
        self.addSubview(controller.trainersTableView)
        
        NSLayoutConstraint.activate([
            controller.trainersTableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            controller.trainersTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            controller.trainersTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            controller.trainersTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -80) // 留出空间给按钮
        ])
    }
    
    private func setupMyAppointmentLabel(controller: ConsumerMainPageViewController) {
        self.addSubview(myAppointmentLabel)
        
        NSLayoutConstraint.activate([
            myAppointmentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            myAppointmentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: controller, action: #selector(controller.showMyAppointments))
        myAppointmentLabel.isUserInteractionEnabled = true
        myAppointmentLabel.addGestureRecognizer(tapGesture)
    }
}

