import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "link.circle")
                .font(.system(size: 64))
                .foregroundColor(.secondary)
            
            Text("Nenhuma URL encurtada ainda")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Cole uma URL acima para começar")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyStateView()
}
