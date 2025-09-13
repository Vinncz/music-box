import SwiftUI



struct PlayerView: View {
    
    
    @State var viewModel: PlayerViewModel
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: Constants.Sizes.baseSpacing * 4) {
                artwork()
                titleAndArtists()
                controlButton()
            }
            .padding()
        }
            .onAppear {
                Task { try await viewModel.play() }
            }
            .background(Color(UIColor.secondarySystemBackground))
            .scrollIndicators(scaleFactor < 1 ? .hidden : .automatic, axes: .vertical)
            .onScrollGeometryChange(for: CGFloat.self) { geometry in
                geometry.contentOffset.y
            } action: { oldValue, newValue in
                if newValue >= 0 {
                    scaleFactor = 1
                    cornerRadius = 16
                    opacity = 1
                } else {
                    scaleFactor = 1 - (0.1 * (newValue / -50)) 
                    cornerRadius = 55 - (35 / 50 * -newValue) 
                    opacity = 1 - (abs(newValue) / 50) 
                }
            }
    }
    
    
    // MARK: -- Internal state keeping 
    @State private var scaleFactor: CGFloat = 1
    @State private var cornerRadius: CGFloat = 16
    @State private var opacity: CGFloat = 1
    
}



fileprivate extension PlayerView {
    
    
    @ViewBuilder func artwork() -> some View {
        AsyncImage(url: viewModel.song.artworkUrl) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 300, minHeight: 300)
            .clipShape(RoundedRectangle(cornerRadius: Constants.Sizes.baseCornerRadius))
    }
    
    
    @ViewBuilder func titleAndArtists() -> some View {
        VStack {
            Text(viewModel.song.displayName)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
            Text(viewModel.song.artistName)
                .font(.callout)
                .multilineTextAlignment(.center)
        }
    }
    
    
    @ViewBuilder func controlButton() -> some View {
        HStack {
            switch viewModel.mediaPlaybackService.state {
            case .idle, .loading, .buffering, .playing:
                Button {
                    Task { await viewModel.mediaPlaybackService.pause() }
                } label: {
                    Label("Pause", systemImage: "pause.fill")
                        .font(.system(size: 64, design: .rounded))
                        .labelStyle(.iconOnly)
                        .tint(.primary)
                }
            default:
                Button {
                    Task { await viewModel.mediaPlaybackService.resume() }
                } label: {
                    Label("Play", systemImage: "play.fill")
                        .font(.system(size: 64, design: .rounded))
                        .labelStyle(.iconOnly)
                        .tint(.primary)
                }
            }
        }
    }
    
}



#Preview {
    PlayerView(viewModel: 
        PlayerViewModel(
            catalogService: CatalogService(), 
            mediaPlaybackService: MediaPlaybackService(), 
            mediaCachingService: MediaCacheKTVHTTPCacheService(), 
            song: .beatlesYellowSubmarine
        )
    )
}
