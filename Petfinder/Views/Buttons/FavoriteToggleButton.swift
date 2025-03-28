import SwiftUI

struct FavoriteToggleButton: View {
    @Binding var isFavorite: Bool
    var onToggle: () -> Void
    @State private var animateSymbol = false

    var body: some View {
        Image(systemName: isFavorite ? "pawprint.fill" : "pawprint")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .symbolEffect(.bounce, options: .nonRepeating, isActive: animateSymbol)
            .onTapGesture {
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
                
                withAnimation {
                    animateSymbol = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        animateSymbol = true
                    }
                    onToggle()
                }
            }
    }
}
