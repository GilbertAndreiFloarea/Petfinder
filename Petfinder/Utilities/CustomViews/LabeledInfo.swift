import SwiftUI

struct LabeledInfo: View {
    let label: String
    let value: String
    var lineLimit: Int? = 1

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("\(label):")
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .frame(minWidth: 80, maxWidth: 80, alignment: .leading)
            
            Text(value)
                .multilineTextAlignment(.leading)
                .lineLimit(lineLimit)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .font(.body)
        .padding(.vertical, 2)
    }
}
