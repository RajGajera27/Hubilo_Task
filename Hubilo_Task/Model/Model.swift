//
//  Model.swift
//  Hubilo_Task
//
//  Created by Raj Gajera on 08/05/21.
//

import Foundation

struct ImageDetails: Codable {
    let id, author: String
    let width, height: Int
    let url, downloadURL: String

    enum CodingKeys: String, CodingKey {
        case id, author, width, height, url
        case downloadURL = "download_url"
    }
}
