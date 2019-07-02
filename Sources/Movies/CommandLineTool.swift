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
        for (index, argument) in arguments.enumerated() {
            switch index {
            case 0:
                if arguments.count == 1 {
                    print("No arguments provided. Use \"Movies -h\" for help.")
                    return false
                }
            case 1:
                if argument == "-h" {
                    print(help())
                    return false
                }
                guard argument.hasPrefix("http://") || argument.hasPrefix("https://") else {
                    print("Invalid URL. The url must begin with http or https.")
                    return false
                }
                guard argument.hasSuffix(".json") else {
                    print("Invalid URL. The URL must end with .json and be in JSON format.")
                    return false
                }
            case 2:
                if argument != "--sort=Title" && argument != "--sort=Year"  && argument != "--sort=Runtime"  && argument != "--sort=UploadDate" {
                    print("Invalid sort argument provided. Use \"Movies -h\" for help.")
                    return false
                }
            case 3:
                if argument != "-r" {
                    print("Invalid arguments. Use \"Movies -h\" for help.")
                    return false
                }
            default:
                print("Invalid arguments. Use \"Movies -h\" for help.")
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
                Movies <url> <sort> -r                  Load movies using the provided sort in reverse order.
        
            Press enter to continue to the next page when viewing results.
        """
    }
    
    /// Returns the properly sorted movies array or nil if an invalid sort parameter is detected
    private func sortMovies(_ movies: [Movie]) -> [Movie]? {
        guard arguments.count > 2 else {
            return movies
        }
        let reversed = arguments.count == 4 && arguments[3] == "-r"
        switch arguments[2] {
        case "--sort=Title":
            return movies.sorted(by: { (movie1, movie2) -> Bool in
                if reversed {
                    // Reverse alphabetic by title Z-A
                    return movie1.title > movie2.title
                }
                // Alphabetic by title A-Z
                return movie1.title < movie2.title
            })
        case "--sort=Year":
            return movies.sorted(by: { (movie1, movie2) -> Bool in
                if reversed {
                    // Oldest to newest year
                    return movie1.year ?? 0 < movie2.year ?? 0
                }
                // Newest to oldest year
                return movie1.year ?? 0 > movie2.year ?? 0
            })
        case "--sort=Runtime":
            return movies.sorted(by: { (movie1, movie2) -> Bool in
                if reversed {
                    // Longest to shortest
                    return movie1.duration > movie2.duration
                }
                // Shortest to longest
                return movie1.duration < movie2.duration
            })
        case "--sort=UploadDate":
            return movies.sorted(by: { (movie1, movie2) -> Bool in
                if reversed {
                    // Oldest to newest upload
                    return movie1.date ?? "" < movie2.date ?? ""
                }
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
