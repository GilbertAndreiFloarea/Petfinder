import SwiftUI

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    @State private var hasAppeared = false

    var highlightColor: Color = Color.white.opacity(0.9)
    var baseColor: Color = .clear
    var animationDuration: Double = 1.5

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        gradient: Gradient(colors: [baseColor, highlightColor, baseColor]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 1.5, height: geometry.size.height)
                    .offset(x: -geometry.size.width + phase)
                    .animation(.linear(duration: animationDuration).repeatForever(autoreverses: false), value: phase)
                }
            )
            .mask(content)
            .onAppear {
                guard !hasAppeared else { return }
                hasAppeared = true
                phase = UIScreen.main.bounds.width * 2
            }
            .accessibility(hidden: true)
    }
}

struct ShimmerBar: View {
    var width: CGFloat
    var height: CGFloat
    var cornerRadius: CGFloat = 5

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.gray.opacity(0.3))
            .frame(width: width, height: height)
            .shimmer()
    }
}

extension View {
    func shimmer() -> some View {
        self.modifier(ShimmerModifier())
    }
}
