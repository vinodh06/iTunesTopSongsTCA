//
//  Endpoints.swift
//  TopSongs
//
//  Created by vinodh kumar on 21/03/24.
//

import Networking

extension URLBuilder {
    static let baseURL = URLBuilder {
        URLComponent.scheme("https")
        URLComponent.host("rss.applemarketingtools.com")
    }

    static let topSongs = baseURL.path("/api/v2/in/music/most-played/1/songs.json")
}
