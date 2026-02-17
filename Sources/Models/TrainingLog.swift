import Foundation

public struct TrainingLog: Identifiable, Codable, Hashable {
    public var id: UUID
    public var date: Date
    public var exerciseId: UUID
    public var programId: UUID?
    public var sets: [ExerciseSet]
    public var duration: TimeInterval
    public var notes: String
    public var createdDate: Date
    
    public init(
        id: UUID = UUID(),
        date: Date = Date(),
        exerciseId: UUID,
        programId: UUID? = nil,
        sets: [ExerciseSet] = [],
        duration: TimeInterval = 0,
        notes: String = "",
        createdDate: Date = Date()
    ) {
        self.id = id
        self.date = date
        self.exerciseId = exerciseId
        self.programId = programId
        self.sets = sets
        self.duration = duration
        self.notes = notes
        self.createdDate = createdDate
    }
}

public struct ExerciseSet: Identifiable, Codable, Hashable {
    public var id: UUID
    public var reps: Int
    public var weight: Double
    public var completed: Bool
    
    public init(
        id: UUID = UUID(),
        reps: Int = 0,
        weight: Double = 0.0,
        completed: Bool = false
    ) {
        self.id = id
        self.reps = reps
        self.weight = weight
        self.completed = completed
    }
}
