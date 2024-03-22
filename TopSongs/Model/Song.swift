import ComposableArchitecture

// MARK: - SongFeed

struct SongFeed: Codable {
    let feed: Feed
}

// MARK: - Feed

struct Feed: Codable {
    let songs: IdentifiedArrayOf<Song>

    enum CodingKeys: String, CodingKey {
        case songs = "results"
    }
}

// MARK: - Song

public struct Song: Codable, Equatable, Identifiable {
    public var id: String
    let artistName, name, releaseDate: String
    let kind: Kind
    let artistID: String
    let artistURL: String
    let artworkUrl100: String
    let genres: [Genre]
    let url: String
    let contentAdvisoryRating: String?

    enum CodingKeys: String, CodingKey {
        case artistName, id, name, releaseDate, kind
        case artistID = "artistId"
        case artistURL = "artistUrl"
        case artworkUrl100, genres, url, contentAdvisoryRating
    }

    // MARK: - Genre

    struct Genre: Codable, Equatable {
        let genreID, name: String
        let url: String

        enum CodingKeys: String, CodingKey {
            case genreID = "genreId"
            case name, url
        }
    }

    enum Kind: String, Codable, Equatable {
        case songs = "songs"
    }
}

extension Song {
    static let mock: IdentifiedArrayOf<Song> = {
        guard let jsonData = loadJSONData(from: "SampleSongs") else { return [] }
        do {
            let decodedData = try JSONDecoder().decode(SongFeed.self, from: jsonData)
            return decodedData.feed.songs
        } catch {
            print("Error decoding JSON data: \(error)")
            return []
        }
    }()
}

private class MyBundle {}

func loadJSONData(from fileName: String) -> Data? {
    if let url = Bundle(for: MyBundle.self).url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print("Error reading JSON data: \(error)")
        }
    } else {
        print("File not found: \(fileName)")
    }
    return nil
}
