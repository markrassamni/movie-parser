//
//  CommandLineTool.swift
//  Movies
//
//  Created by Mark Rassamni on 7/1/19.
//

import Foundation

public final class CommandLineTool {
    
    private let arguments: [String]

    /// 1st argument is program name, followed by the URL, then optional flags
    /// Movies https://... <flags>
    public init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }
    
    public func run() {
        guard validateInput() else { return }
        NetworkManager.shared.getJSON(from: arguments[1]) { (json, error) in
            guard error == nil else {
                print(error!)
                return
            }
            guard let json = json else {
                print("Failed to retreive JSON. Please verify that the inputted format is proper JSON.")
                return
            }
            guard let movies = DataParser.shared.getMovies(from: json) else {
                print("Failed to parse JSON. Please check that your input matches the format here: https://gist.githubusercontent.com/anothermh/72951911c70aa4e8d4f199406a0c5d8a/raw/039f37a6bdc15b922d5f17dfd5a0c3042be4420e/movies.json")
                return
            }
            guard let sortedMovies = self.sortMovies(movies) else {
                print("Invalid sort argument provided. Use \"Movies -h\" for help.")
                return
            }
            self.displayMovies(sortedMovies)
        }
    }
    
    private func validateInput() -> Bool {
        // If arg count is 1 then it is just "Movies"
        guard arguments.count > 1, arguments[1] != "-h" else {
            print(help())
            return false
        }
        let url = arguments[1]
        guard url.hasPrefix("http://") || url.hasPrefix("https://") else {
            print("Invalid URL. The url must begin with http or https.")
            return false
        }
        guard url.hasSuffix(".json") else {
            print("Invalid URL. The URL must end with .json and be in JSON format.")
            return false
        }
        if arguments.count == 3 {
            // Has sort argument
            let sort = arguments[2]
            if sort != "--sort=Title" && sort != "--sort=Year"  && sort != "--sort=Runtime"  && sort != "--sort=UploadDate" {
                print("Invalid sort argument provided. Use \"Movies -h\" for help.")
                return false
            }
        }
        return true
    }
    
    private func help() -> String{
        return """
            Usage:
                Movies -h                               Show this help menu.
                Movies <url>                            Load movies from provided URL containing valid JSON.
                Movies <url> [--sort=Title]             Load movies sorted alphabetically by title.
                Movies <url> [--sort=Year]              Load movies sorted by newest to oldest release date.
                Movies <url> [--sort=Runtime]           Load movies sorted shortest to longest.
                Movies <url> [--sort=UploadDate]        Load movies sorted by upload date, newest to oldest.
        """
    }
    
    /// Returns the properly sorted movies array or nil if an invalid sort parameter is detected
    private func sortMovies(_ movies: [Movie]) -> [Movie]? {
        guard arguments.count == 3 else {
            return movies
        }
        let sortArgument = arguments[2]
        switch sortArgument {
        case "--sort=Title":
            return movies.sorted(by: { (movie1, movie2) -> Bool in
                // Alphabetic by title A-Z
                return movie1.title < movie2.title
            })
        case "--sort=Year":
            return movies.sorted(by: { (movie1, movie2) -> Bool in
                // Newest to oldest year
                return movie1.year ?? 0 > movie2.year ?? 0
            })
        case "--sort=Runtime":
            return movies.sorted(by: { (movie1, movie2) -> Bool in
                // Shortest to longest
                return movie1.duration < movie2.duration
            })
        case "--sort=UploadDate":
            return movies.sorted(by: { (movie1, movie2) -> Bool in
                // Newest to oldest upload
                return movie1.date ?? "" > movie2.date ?? ""
            })
        default:
            return nil
        }
    }
    
    private func displayMovies(_ movies: [Movie]) {
        // Print pageSize(5) elements at a time until reaching the last movie
        let pageSize = 5
        var pagedIndex = 0
        var allDisplayed = false
        while !allDisplayed {
            for index in pagedIndex..<pagedIndex + pageSize {
                guard index < movies.count else {
                    allDisplayed = true
                    return
                }
                var output = movies[index].displayFormat()
                if index < movies.count - 1 && index != pagedIndex + pageSize - 1 {
                    output += "\n"
                }
                print(output)
            }
            pagedIndex += 5
            if pagedIndex >= movies.count {
                allDisplayed = true
                return
            }
            // Wait for user to press enter before continuing to next page
            let _ = readLine()
        }
    }
}
