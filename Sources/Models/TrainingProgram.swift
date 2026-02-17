import Foundation

public struct TrainingProgram: Identifiable, Codable, Hashable {
    public var id: UUID
    public var name: String
    public var description: String
    public var exercises: [ProgramExercise]
    public var schedule: [String]
    public var createdDate: Date
    public var modifiedDate: Date
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String = "",
        exercises: [ProgramExercise] = [],
        schedule: [String] = [],
        createdDate: Date = Date(),
        modifiedDate: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.exercises = exercises
        self.schedule = schedule
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
    }
}

public struct ProgramExercise: Identifiable, Codable, Hashable {
    public var id: UUID
    public var exerciseId: UUID
    public var sets: Int
    public var reps: Int
    public var restSeconds: Int
    public var notes: String
    
    public init(
        id: UUID = UUID(),
        exerciseId: UUID,
        sets: Int = 3,
        reps: Int = 10,
        restSeconds: Int = 60,
        notes: String = ""
    ) {
        self.id = id
        self.exerciseId = exerciseId
        self.sets = sets
        self.reps = reps
        self.restSeconds = restSeconds
        self.notes = notes
    }
}
