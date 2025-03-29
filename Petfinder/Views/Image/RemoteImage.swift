import SwiftUI
import ViewInspector

final class ImageLoader: ObservableObject {
    
    @Published var image: Image? = nil
    
    func load(fromURLString urlString: String) {
        Task {
            do {
                if let uiImage = try await NetworkManager.shared.downloadImage(fromURLString: urlString) {
                    await MainActor.run {
                        self.image = Image(uiImage: uiImage)
                    }
                }
            } catch {
                print("Failed to load image: \(error)")
            }
        }
    }
}


struct RemoteImage: View {
    
    var image: Image?
    var type: PetType
    
    var placeholderName: String {
        switch type {
        case .cat: return "cat"
        case .dog: return "dog"
        case .rabbit: return "hare"
        case .bird: return "bird"
        case .unknown: return "camera.metering.unknown"
        }
    }
    
    var body: some View {
        if let image {
            image
                .resizable()
        } else {
            let placeholder = Image(systemName: placeholderName)
            placeholder
                .resizable()
                .foregroundColor(.gray)
        }
    }
}


struct PetRemoteImage: View {
    
    @StateObject var imageLoader = ImageLoader()
    let urlString: String
    var type: PetType
    
    var body: some View {
        RemoteImage(image: imageLoader.image, type: type)
            .onAppear { imageLoader.load(fromURLString: urlString) }
    }
}
