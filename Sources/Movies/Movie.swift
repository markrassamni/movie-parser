//
//  Movie.swift
//  Alamofire
//
//  Created by Mark Rassamni on 7/2/19.
//

import Foundation

struct Movie {
    let title: String
    let year: Int?
    let duration: Int
    let uploadDate: String?
    
    func getFormattedDuration() -> String {
        // TODO: Convert to xHr, yMin
        return ""
    }
    
    func getFormattedDate() -> String? {
        guard let date = uploadDate else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        guard let formatDate = dateFormatter.date(from: date) else {
            return nil
        }
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: formatDate)
    }
}
