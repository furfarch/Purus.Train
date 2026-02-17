import Foundation

public struct Exercise: Identifiable, Codable, Hashable {
    public var id: UUID
    public var name: String
    public var description: String
    public var muscleGroups: [String]
    public var category: ExerciseCategory
    public var createdDate: Date
    public var modifiedDate: Date
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String = "",
        muscleGroups: [String] = [],
        category: ExerciseCategory = .other,
        createdDate: Date = Date(),
        modifiedDate: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.muscleGroups = muscleGroups
        self.category = category
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
    }
}

public enum ExerciseCategory: String, Codable, CaseIterable {
    case strength = "Strength"
    case cardio = "Cardio"
    case flexibility = "Flexibility"
    case balance = "Balance"
    case other = "Other"
}
