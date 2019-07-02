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
        // TODO: Validate flags
        return true
    }
    
    private func help() -> String{
        // TODO: Change to show usage and commands
        return "Enter the command \"Movies <url>\" to begin or \"Movies -h\" for help."
    }
}
