import Foundation

struct WindowEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var room: String
    var widthInches: String
    var heightInches: String
    var notes: String
    var createdAt: Date

    init(id: UUID = UUID(), room: String, widthInches: String, heightInches: String, notes: String = "", createdAt: Date = Date()) {
        self.id = id
        self.room = room
        self.widthInches = widthInches
        self.heightInches = heightInches
        self.notes = notes
        self.createdAt = createdAt
    }
}
