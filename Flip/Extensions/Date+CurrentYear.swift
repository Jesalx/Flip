//
//  Date+CurrentYear.swift
//  Flip
//
//  Created by Jesal Patel on 7/30/22.
//

import Foundation

extension Date {
    var year: Int { Calendar.current.dateComponents([.year], from: self).year ?? 0 }
}
