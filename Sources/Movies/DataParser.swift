//
//  DataParser.swift
//  Alamofire
//
//  Created by Mark Rassamni on 7/2/19.
//

import Foundation
import SwiftyJSON

public final class DataParser {
    
    // Singleton
    private init(){}
    public static let shared = DataParser()
    
    /// Return nil if cannot parse JSON as expected
    func getMovies(from json: JSON) -> [Movie]? {
        var movies = [Movie]()
        for (_, data): (String, JSON) in json {
            guard let title = data["title"].string else {
                return nil
            }
            let year = data["year"].int
            guard let duration = data["duration"].int else {
                return nil
            }
            let uploadDate = data["created_at"].string
            let movie = Movie(title: title, year: year, duration: duration, uploadDate: uploadDate)
            movies.append(movie)
        }
        return movies
    }
    
    // Sample format from JSON:
    /*
     "id": 10720,
     "video_encoding": "x264",
     "audio_encoding": "DTS",
     "title": "Magic in the Moonlight",
     "year": 2014,
     "duration": 5857856,
     "bitdepth": 8,
     "aspect_ratio": "2.376",
     "audio_channels": 6,
     "framerate": "23.976",
     "created_at": "2019-06-09T20:53:41.103Z",
     "updated_at": "2019-06-09T20:53:41.103Z"
     */
}
