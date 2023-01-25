//
//  SongsModel.swift
//  ITunesHomeWork1
//
//  Created by Алина Лошакова on 20.01.2023.
//

import Foundation

struct SongsModels: Decodable {
    let results: [Song]
    
}

struct Song: Decodable {
    let trackName: String?
    
}

