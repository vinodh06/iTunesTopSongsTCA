//
//  SongClient.swift
//  TopSongs
//
//  Created by vinodh kumar on 21/03/24.
//

import ComposableArchitecture
import Kingfisher
import Networking
import SwiftUI

@DependencyClient
struct SongClient {
    var getTopSongs: () async throws -> IdentifiedArrayOf<Song>
    var getAlbumImage: (String) async throws -> Image?
}

enum SongClientError: Error {
    case invalidURL
}

extension SongClient: DependencyKey {
    static var liveValue: SongClient = Self {
        return try await (NetworkService.fetch(for: .topSongs) as SongFeed).feed.songs
    } getAlbumImage: { urlString in
        guard let url = URL(string: urlString) else { throw SongClientError.invalidURL }
        let image = try await withCheckedThrowingContinuation { continuation in
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case let .success(imgSrc):
                    continuation.resume(returning: Image(uiImage: imgSrc.image))

                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
        return image
    }

    static var previewValue: SongClient = Self {
        return Song.mock
    } getAlbumImage: { _ in
        return Image(systemName: "person")
//        throw SongClientError.invalidURL
    }

    static var testValue: SongClient = Self {
        return Song.mock
    } getAlbumImage: { _ in
        return Image(systemName: "person")
    }
}

extension DependencyValues {
    var songClient: SongClient {
        get { self[SongClient.self] }
        set { self[SongClient.self] = newValue }
    }
}


