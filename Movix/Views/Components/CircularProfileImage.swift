import SwiftUI

struct CircularProfileImage: View {
    let imageURL: URL?
    let size: CGFloat
    
    init(imageURL: URL?, size: CGFloat = 100) {
        self.imageURL = imageURL
        self.size = size
    }
    
    var body: some View {
        if let url = imageURL {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: size, height: size)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
//                        .position(x: size/2, y: (size/2)+6)
                case .failure:
                    placeholderImage
                @unknown default:
                    placeholderImage
                }
            }
        } else {
            placeholderImage
        }
    }
    
    private var placeholderImage: some View {
        Image(.profileDefault)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .foregroundStyle(.gray)
    }
}

#Preview {
    CircularProfileImage(imageURL: Cast.previewData[0].profilePath)
} 
