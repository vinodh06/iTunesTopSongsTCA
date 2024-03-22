//
//  Song.swift
//  TopSongs
//
//  Created by vinodh kumar on 22/03/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct SongFeature {
    @ObservableState
    public struct State: Equatable, Identifiable {
        let song: Song
        public let id: Song.ID
        var artImage: Image?

        public init(song: Song) {
            self.id = song.id
            self.song = song
        }
    }

    public enum Action {
        case loadImage
        case setImage(Result<Image?, Error>)
    }

    @Dependency(\.songClient.getAlbumImage) var imageClient

    public var body: some ReducerOf<Self> {
        Reduce {
            state,
            action in
            switch action {
            case .loadImage:
                return .run { [url = state.song.artworkUrl100] send in
                    await send(
                        .setImage(Result {
                            try await imageClient(
                                url
                            )
                        })
                    )
                }

            case let .setImage(.success(img)):
                state.artImage = img
                return .none

            case let .setImage(.failure(error)):
                print(error)
                state.artImage = nil
                return .none

            }
        }
    }

}

public struct SongView: View {

    let store: StoreOf<SongFeature>

    public init(store: StoreOf<SongFeature>) {
        self.store = store
    }

    public var body: some View {
        HStack {
            if let artImage = store.artImage {
                artImage
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            Text(store.song.name)
        }
        .task {
            store.send(.loadImage)
        }

    }
}

