//
//  UnavailableDatesViewController.swift
//  Trainme
//
//  Created by levi cheng on 12/2/24.
//

import UIKit
import FSCalendar

protocol UnavailableDatesDelegate: AnyObject {
    func didUpdateUnavailableDates(_ dates: [Date])
}

class UnavailableDatesViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    weak var delegate: UnavailableDatesDelegate?
    var preselectedDates: [Date] = []
    private var selectedDates: Set<Date> = []
    
    private let calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.allowsMultipleSelection = true
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Select Unavailable Dates"
        setupCalendar()
        setupSaveButton()
        preselectDates()
    }
    
    private func setupCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
        view.addSubview(calendar)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendar.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    private func setupSaveButton() {
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save Dates", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveSelectedDates), for: .touchUpInside)
        
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func preselectDates() {
        preselectedDates.forEach { calendar.select($0) }
        selectedDates = Set(preselectedDates)
    }
    
    @objc private func saveSelectedDates() {
        delegate?.didUpdateUnavailableDates(Array(selectedDates))
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - FSCalendar Delegate & DataSource
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDates.insert(date)
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDates.remove(date)
    }
}
