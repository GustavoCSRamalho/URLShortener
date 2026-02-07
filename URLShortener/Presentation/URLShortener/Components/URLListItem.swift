import SwiftUI

struct URLListItem: View {
    
    let shortenedURL: ShortenedURL
    let onCopy: (String) -> Void
    
    @State private var showCopiedFeedback = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(shortenedURL.alias, systemImage: "link")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(timeAgo)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Original")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(shortenedURL.originalURL)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Encurtada")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(shortenedURL.shortURL)
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Button {
                    onCopy(shortenedURL.shortURL)
                    withAnimation {
                        showCopiedFeedback = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showCopiedFeedback = false
                        }
                    }
                } label: {
                    Image(systemName: showCopiedFeedback ? "checkmark.circle.fill" : "doc.on.doc")
                        .foregroundColor(showCopiedFeedback ? .green : .accentColor)
                        .imageScale(.large)
                }
                .accessibilityLabel("Copiar URL")
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.white))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.gray), lineWidth: 0.5)
        )
    }
    
    private var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: shortenedURL.createdAt, relativeTo: Date())
    }
}

#Preview {
    VStack(spacing: 16) {
        URLListItem(
            shortenedURL: .mock,
            onCopy: { _ in }
        )
        
        URLListItem(
            shortenedURL: ShortenedURL(
                originalURL: "https://www.verylongdomainname.com/with/many/paths/that/should/truncate",
                shortURL: "https://short.url/xyz789",
                alias: "xyz789",
                createdAt: Date().addingTimeInterval(-3600)
            ),
            onCopy: { _ in }
        )
    }
    .padding()
}
