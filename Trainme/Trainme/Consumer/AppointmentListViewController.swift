import UIKit
import FirebaseFirestore
import FirebaseAuth

class AppointmentListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private var dates: [Date] = [] // 用于保存预约的日期
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration? // Firestore 的实时监听器
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        listenToAppointments()
    }
    
    deinit {
        // 停止监听
        listener?.remove()
    }
    
    private func setupUI() {
        // 设置标题
        self.title = "My Appointment"
        view.backgroundColor = .white
        
        // 设置表格视图
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DateCell")
        view.addSubview(tableView)
        
        // 设置表格视图的约束
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func listenToAppointments() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("No user is currently logged in.")
            return
        }
        
        // 动态监听 Firestore 数据
        print("Current User ID: \(currentUserId)")
        listener = db.collection("notifications")
            .whereField("userId", isEqualTo: currentUserId)
            .whereField("status", isEqualTo: "accepted")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error listening for appointment dates: \(error.localizedDescription)")
                    return
                }
                
                // 提取所有的日期
                self.dates = snapshot?.documents.compactMap { doc -> Date? in
                    if let timestamp = doc.data()["date"] as? Timestamp {
                        print("dates:\(self.dates)")
                        return timestamp.dateValue()
                    }
                    return nil
                } ?? []
                
                // 更新 UI
                self.tableView.reloadData()
            }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath)
        let date = dates[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        cell.textLabel?.text = "Appointment at \(dateFormatter.string(from: date))"
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

