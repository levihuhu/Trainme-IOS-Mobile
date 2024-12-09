//
//  ContactsTableViewManager.swift
//  Trainme
//
//  Created by levi cheng on 11/29/24.
//


import Foundation
import UIKit
import FirebaseFirestore


extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell", for: indexPath) as? ContactsTableViewCell else {
            return UITableViewCell()
        }

        let appointment = appointments[indexPath.row]
        let username = appointment["username"] as? String ?? "Unknown User"
        let status = appointment["status"] as? String ?? "pending"
        let date = (appointment["date"] as? Timestamp)?.dateValue() ?? Date()
        let formattedDate = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .short)

        cell.labelName.text = "\(username)‘s appointment"
        cell.labelEmail.text = formattedDate
        cell.labelPhone.text = "Status: \(status)"
        cell.bookingId = appointment["docId"] as? String
        cell.delegate = self

        cell.acceptButton.isHidden = (status == "accepted")
        cell.declineButton.isHidden = (status == "accepted")
       
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // 禁用点击单元格的反应
        print("table clicked")
        
        }
}
