import Foundation

struct URLValidator {
    func isValid(url: String) -> Bool {
        let trimmed = url.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        let normalized = normalizeURL(trimmed)
        guard let url = URL(string: normalized) else { return false }
        
        guard let scheme = url.scheme,
              ["http", "https"].contains(scheme),
              let host = url.host,
              !host.isEmpty else {
            return false
        }
        
        let hostPattern = "^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\\.[a-zA-Z]{2,})+$"
        let hostPredicate = NSPredicate(format: "SELF MATCHES %@", hostPattern)
        
        return hostPredicate.evaluate(with: host)
    }
    
    func normalizeURL(_ url: String) -> String {
        var normalized = url.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !normalized.lowercased().hasPrefix("http://") &&
           !normalized.lowercased().hasPrefix("https://") {
            normalized = "https://" + normalized
        }
        
        return normalized
    }
}
