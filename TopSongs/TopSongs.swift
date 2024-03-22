//
//  TopSongs.swift
//  TopSongs
//
//  Created by vinodh kumar on 21/03/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct TopSongsFeature {

    public init() {}

    @ObservableState
    public struct State: Equatable {
        var songs: IdentifiedArrayOf<SongFeature.State> = []

        public init() {}
    }

    public enum Action {
        case loadSongs
        case loadSongsResponse(Result<IdentifiedArrayOf<Song>, Error>)
        case songs(IdentifiedActionOf<SongFeature>)
    }

    @Dependency(\.songClient) var songClient

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loadSongs:
                return .run { send in
                    await send(.loadSongsResponse(Result {
                        try await songClient.getTopSongs()
                    }))
                }

            case let .loadSongsResponse(.success(songs)):
                state.songs = []
                for song in songs {
                    state.songs.append(SongFeature.State(song: song))
                }
                return .none

            case let .loadSongsResponse(.failure(error)):
                print(error)
                return .none

            case .songs:
                return .none

            }
        }
        .forEach(\.songs, action: \.songs) {
          SongFeature()
        }
    }
}

public struct TopSongsView: View {

    var store: StoreOf<TopSongsFeature>

    public init(store: StoreOf<TopSongsFeature>) {
        self.store = store
    }

    public var body: some View {
        List {
            Section("Top Songs") {
                ForEach(store.scope(state: \.songs, action: \.songs)) { store in
                    SongView(store: store)
                }
            }
        }
        .task {
            store.send(.loadSongs)
        }
    }
}

#Preview {
    TopSongsView(store: Store(initialState: TopSongsFeature.State(), reducer: {
        TopSongsFeature()
    }))
}
