//
//  Date+Ex.swift
//  IphoneWeatherApp
//
//  Created by Hellizar on 31.03.21.
//

import Foundation

//extension Date {
//    var millisecondsSince1970:Int64 {
//        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
//    }
//
//    init(milliseconds: Int) {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEEE"
//        let myDate = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
//        self = formatter.string(from: myDate)
//    }
//
//    func getDayForDate(_ date: Date?) -> String {
//        guard let inputDate = date else {
//            return ""
//        }
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEEE"
//
//        return formatter.string(from: inputDate)
//    }
//}

extension String {
    init(milliseconds: Int) {
        let date = Date(timeIntervalSince1970: Double(milliseconds))

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        //            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        //            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        //            dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)

        self = localDate
    }
}



