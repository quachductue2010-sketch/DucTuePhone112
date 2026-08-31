import Foundation

enum DisplayStyle: String, CaseIterable, Identifiable, Codable {
    case styleA = "styleA"
    case styleB = "styleB"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .styleA: return "Cách 1"
        case .styleB: return "Cách 2"
        }
    }

    var subtitle: String {
        switch self {
        case .styleA: return "Viettel"
        case .styleB: return "Mobifone"
        }
    }

    // Giữ biểu tượng góc trái giống giao diện tham chiếu.
    var badgeLetter: String { "C" }
}

struct USSDProfile: Equatable {
    var phoneNumber: String
    var mainBalance: String
    var expiryDate: String
}
