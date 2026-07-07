import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published private(set) var entries: [WindowEntry] = []
    @Published var isPro: Bool = false

    static let freeLimit = 8

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Blindswatch", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("entries.json")
        load()
        if entries.isEmpty {
            seed()
        }
    }

    var canAddMore: Bool {
        isPro || entries.count < Store.freeLimit
    }

    func add(_ entry: WindowEntry) {
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: WindowEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: WindowEntry) {
        entries.removeAll(where: { $0.id == entry.id })
        save()
    }

    private func seed() {
        entries = [
            WindowEntry(room: "Front", widthInches: "Recently checked", heightInches: "Good", notes: "Seed entry"),
            WindowEntry(room: "Back", widthInches: "Last month", heightInches: "Needs attention", notes: "Seed entry"),
            WindowEntry(room: "Side", widthInches: "Two months ago", heightInches: "Good", notes: "Seed entry"),
        ]
        save()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([WindowEntry].self, from: data) else { return }
        entries = decoded
    }
}
