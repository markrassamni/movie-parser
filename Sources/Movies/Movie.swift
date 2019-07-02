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
    private let duration: Int // Comes from JSON in miliseconds
    private let uploadDate: String?
    
    init(title: String, year: Int?, duration: Int, uploadDate: String?) {
        self.title = title
        self.year = year
        self.duration = duration
        self.uploadDate = uploadDate
    }
    
    var runtime: String {
        let seconds = duration/1000
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        return "\(hours) Hr \(minutes) Min"
    }
    
    var date: String? {
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
