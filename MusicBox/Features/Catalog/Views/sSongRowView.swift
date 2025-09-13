import SwiftUI



struct SongRowView: View {
    
    
    @Namespace var namespace
    
    
    let song: iTunesSong
    
    
    var body: some View {
        HStack {
            AsyncImage(url: song.artworkUrl60)
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: Constants.Sizes.baseCornerRadius))
            VStack(alignment: .leading) {
                Text(song.displayName)
                    .bold()
                    .multilineTextAlignment(.leading)
                Text(song.artistName)
                    .font(.caption)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
        }
        .id(song.id)
    }
    
}



#Preview {
    SongRowView(song: .beatlesYellowSubmarine)
}
