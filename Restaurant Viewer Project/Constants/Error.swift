//
//  Error.swift
//  Restaurant Viewer Project
//
//  Created by Chris W on 1/31/25.
//

import Foundation

enum NetworkError: String, Error {
    case unableToComplete = "Unable to complete your request, please check your internet connection."
    case invalidResponse = "Invalid response from the server, please try again."
    case invalidData = "The data received from the server was invalid, please try again."
    case invalidRequest = "The data used to make the request was invalid, please try again."
}
