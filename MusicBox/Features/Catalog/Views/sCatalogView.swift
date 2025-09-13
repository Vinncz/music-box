import SwiftUI



struct CatalogView: View {
    
    
    @Namespace var namespace
    
    
    @State var viewModel: CatalogViewModel
    
    
    var body: some View {
        NavigationStack {
            Form {
                if viewModel.songs.isEmpty {
                    noSong()
                } else {
                    songList()
                }
            }
            .navigationTitle("Music Box")
            .searchable(text: $viewModel.query, prompt: "Search for songs..")
            .navigationDestination(for: iTunesSong.self) { song in
                PlayerView(viewModel: 
                    PlayerViewModel(
                        catalogService: CatalogService(), 
                        mediaPlaybackService: MediaPlaybackService(), 
                        mediaCachingService: MediaCacheKTVHTTPCacheService(), 
                        song: song
                    )
                )
                    .navigationTransition(.zoom(sourceID: song.id, in: namespace))
            }
            .task {
                await viewModel.refresh()
            }
        }
    }
    
}



fileprivate extension CatalogView {
    
    
    @ViewBuilder func songList() -> some View {
        Section("Found \(viewModel.songs.count) song(s)") {
            List(viewModel.songs, id: \.id) { song in
                NavigationLink(value: song) {
                    SongRowView(song: song)
                        .matchedTransitionSource(id: song.id, in: namespace, configuration: { source in
                            source.clipShape(RoundedRectangle(cornerRadius: Constants.Sizes.baseCornerRadius))
                        })
                        .tint(.primary)
                        .onAppear {
                            Task { await viewModel.preload(songUrl: song.previewUrl) }
                        }
                        .onDisappear {
                            Task { await viewModel.cancelPreload(songUrl: song.previewUrl) }
                        }
                }
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
    }
    
    
    @ViewBuilder func noSong() -> some View {
        ContentUnavailableView(
            "Let's search for another song", 
            systemImage: "music.quarternote.3", 
            description: Text("Your search returned no results, or you are offline")
        )
        .frame(minHeight: 350)
    }
    
}



#Preview {
    CatalogView(viewModel: CatalogViewModel(
        catalogService: CatalogService(),
        mediaPlaybackService: MediaPlaybackService(),
        mediaCachingService: MediaCacheKTVHTTPCacheService()
    ))
}
