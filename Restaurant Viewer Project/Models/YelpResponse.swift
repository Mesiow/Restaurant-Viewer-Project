//
//  YelpResponse.swift
//  Restaurant Viewer Project
//
//  Created by Chris W on 1/31/25.
//

import Foundation

struct Business: Codable {
    let name: String
    let rating: Double
    let price: String?
    let location: Location
    let image_url: String
}

struct Location: Codable {
    let address1: String
    let city: String
    let state: String
    let zip_code: String
}

struct YelpResponse: Codable {
    let businesses: [Business]
}
