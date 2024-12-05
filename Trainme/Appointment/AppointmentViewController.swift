import UIKit
import FirebaseFirestore
import FSCalendar
import FirebaseAuth

class AppointmentViewController: UIViewController {
    
    var trainerData: [String: Any]? // 从前一个视图控制器传递的 Trainer 数据
    private var unavailableDates: [Date] = [] // 不可用日期
    private let db = Firestore.firestore()
    private let appointmentView = AppointmentView()
    
    override func loadView() {
        view = appointmentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Appointment"
        setupDelegates()
        
        if let trainer = trainerData, let trainerId = trainer["trainerId"] as? String {
            fetchUnavailableDates(for: trainerId)
        } else {
            print("Trainer data is not available.")
        }
    }
    
    private func setupDelegates() {
        appointmentView.calendar.delegate = self
        appointmentView.calendar.dataSource = self
    }
    
    private func fetchUnavailableDates(for trainerId: String) {
        db.collection("availability")
            .document(trainerId)
            .getDocument { [weak self] (snapshot, error) in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching unavailable dates: \(error.localizedDescription)")
                    return
                }

                if let data = snapshot?.data(),
                   let timestamps = data["unavailableDates"] as? [Timestamp] {
                    self.unavailableDates = timestamps.map { $0.dateValue() }
                }

                DispatchQueue.main.async {
                    self.appointmentView.calendar.reloadData()
                }
            }
    }
    
    private func confirmBooking(for date: Date) {
        let alert = UIAlertController(
            title: "Confirm Booking",
            message: "Do you want to book an appointment on \(dateFormatter.string(from: date))?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak self] _ in
            self?.sendBookingRequest(for: date)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func sendBookingRequest(for date: Date) {
        guard let trainerId = trainerData?["trainerId"] as? String,
              let currentUserId = Auth.auth().currentUser?.uid else { return }

        // 从 Firestore 获取 username
        db.collection("users").document(currentUserId).getDocument { [weak self] (snapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching username: \(error.localizedDescription)")
                return
            }

            // 获取 username，如果不存在，使用默认值 "Unknown User"
            let username = snapshot?.data()?["name"] as? String ?? "Unknown User"

            // 构造请求数据
            let requestData: [String: Any] = [
                "trainerId": trainerId,          // Trainer 的 ID
                "userId": currentUserId,         // 当前用户 ID
                "username": username,            // 当前用户用户名
                "date": Timestamp(date: date),   // 请求的日期
                "status": "pending"              // 初始状态
            ]

            // 将请求数据写入到 Firestore
            self.db.collection("notifications").addDocument(data: requestData) { error in
                if let error = error {
                    self.showAlert(title: "Error", message: "Failed to send booking request: \(error.localizedDescription)")
                } else {
                    self.showAlert(title: "Success", message: "Your booking request has been sent to the trainer!")
                }
            }
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // 使用短、中、长格式（例如：Dec 1, 2024）
        formatter.timeStyle = .none  // 不显示时间部分
        return formatter
    }()

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - FSCalendarDelegate/DataSource
extension AppointmentViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0 // 只有灰色标记，没有事件标记
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if unavailableDates.contains(date) {
            return .lightGray // 不可用日期标记为灰色
        }
        return nil // 其他日期默认颜色
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if unavailableDates.contains(date) {
            // 不可用日期弹窗
            showAlert(title: "Unavailable", message: "This date is unavailable for booking.")
        } else {
            // 默认可用，弹出确认框
            confirmBooking(for: date)
        }
    }
}

