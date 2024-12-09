import UIKit
import FSCalendar

class AppointmentView: UIView {
    
    let calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    let timeSlotsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TimeSlotCell")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        addSubview(calendar)
        addSubview(timeSlotsTableView)
        
        NSLayoutConstraint.activate([
            // Calendar constraints
            calendar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: trailingAnchor),
            calendar.heightAnchor.constraint(equalToConstant: 300),
            
            // TableView constraints
            timeSlotsTableView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 10),
            timeSlotsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            timeSlotsTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            timeSlotsTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

