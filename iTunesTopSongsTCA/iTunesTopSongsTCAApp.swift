//
//  iTunesTopSongsTCAApp.swift
//  iTunesTopSongsTCA
//
//  Created by vinodh kumar on 21/03/24.
//

import ComposableArchitecture
import SwiftUI
import TopSongs

@main
struct iTunesTopSongsTCAApp: App {
    var body: some Scene {
        WindowGroup {
            TopSongsView(store: Store(initialState: TopSongsFeature.State(), reducer: {
                TopSongsFeature()
            }))
        }
    }
}
