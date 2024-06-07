//
//  Date+.swift
//  TodoListWithUIKit
//
//  Created by Sooik Kim on 6/4/24.
//

import Foundation

extension Date {
    func changeToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter.string(from: self)
    }
}
