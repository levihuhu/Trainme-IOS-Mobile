//
//  Contact.swift
//  Trainme
//
//  Created by levi cheng on 11/29/24.
//



import Foundation

struct Contact: Codable{
    var name: String
    var email: String
    var phone: Int
    
    init(name: String, email: String, phone: Int) {
        self.name = name
        self.email = email
        self.phone = phone
    }
}
