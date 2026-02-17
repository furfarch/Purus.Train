import Foundation
import CloudKit

@MainActor
public class DataManager: ObservableObject {
    @Published public var exercises: [Exercise] = []
    @Published public var trainingPrograms: [TrainingProgram] = []
    @Published public var trainingLogs: [TrainingLog] = []
    
    private let container: CKContainer
    private let database: CKDatabase
    
    public static let shared = DataManager()
    
    private init() {
        self.container = CKContainer(identifier: "iCloud.com.furfarch.purus.TRAIN")
        self.database = container.privateCloudDatabase
        loadLocalData()
    }
    
    // MARK: - Local Persistence
    
    private func loadLocalData() {
        loadExercises()
        loadTrainingPrograms()
        loadTrainingLogs()
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // MARK: - Exercise Management
    
    public func addExercise(_ exercise: Exercise) {
        exercises.append(exercise)
        saveExercises()
        syncExerciseToCloud(exercise)
    }
    
    public func updateExercise(_ exercise: Exercise) {
        if let index = exercises.firstIndex(where: { $0.id == exercise.id }) {
            var updated = exercise
            updated.modifiedDate = Date()
            exercises[index] = updated
            saveExercises()
            syncExerciseToCloud(updated)
        }
    }
    
    public func deleteExercise(_ exercise: Exercise) {
        exercises.removeAll { $0.id == exercise.id }
        saveExercises()
        deleteExerciseFromCloud(exercise)
    }
    
    private func saveExercises() {
        let url = getDocumentsDirectory().appendingPathComponent("exercises.json")
        if let data = try? JSONEncoder().encode(exercises) {
            try? data.write(to: url)
        }
    }
    
    private func loadExercises() {
        let url = getDocumentsDirectory().appendingPathComponent("exercises.json")
        if let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([Exercise].self, from: data) {
            exercises = decoded
        }
    }
    
    // MARK: - Training Program Management
    
    public func addTrainingProgram(_ program: TrainingProgram) {
        trainingPrograms.append(program)
        saveTrainingPrograms()
        syncProgramToCloud(program)
    }
    
    public func updateTrainingProgram(_ program: TrainingProgram) {
        if let index = trainingPrograms.firstIndex(where: { $0.id == program.id }) {
            var updated = program
            updated.modifiedDate = Date()
            trainingPrograms[index] = updated
            saveTrainingPrograms()
            syncProgramToCloud(updated)
        }
    }
    
    public func deleteTrainingProgram(_ program: TrainingProgram) {
        trainingPrograms.removeAll { $0.id == program.id }
        saveTrainingPrograms()
        deleteProgramFromCloud(program)
    }
    
    private func saveTrainingPrograms() {
        let url = getDocumentsDirectory().appendingPathComponent("programs.json")
        if let data = try? JSONEncoder().encode(trainingPrograms) {
            try? data.write(to: url)
        }
    }
    
    private func loadTrainingPrograms() {
        let url = getDocumentsDirectory().appendingPathComponent("programs.json")
        if let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([TrainingProgram].self, from: data) {
            trainingPrograms = decoded
        }
    }
    
    // MARK: - Training Log Management
    
    public func addTrainingLog(_ log: TrainingLog) {
        trainingLogs.append(log)
        saveTrainingLogs()
        syncLogToCloud(log)
    }
    
    public func updateTrainingLog(_ log: TrainingLog) {
        if let index = trainingLogs.firstIndex(where: { $0.id == log.id }) {
            trainingLogs[index] = log
            saveTrainingLogs()
            syncLogToCloud(log)
        }
    }
    
    public func deleteTrainingLog(_ log: TrainingLog) {
        trainingLogs.removeAll { $0.id == log.id }
        saveTrainingLogs()
        deleteLogFromCloud(log)
    }
    
    private func saveTrainingLogs() {
        let url = getDocumentsDirectory().appendingPathComponent("logs.json")
        if let data = try? JSONEncoder().encode(trainingLogs) {
            try? data.write(to: url)
        }
    }
    
    private func loadTrainingLogs() {
        let url = getDocumentsDirectory().appendingPathComponent("logs.json")
        if let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([TrainingLog].self, from: data) {
            trainingLogs = decoded
        }
    }
    
    // MARK: - CloudKit Sync (Placeholder implementations)
    
    private func syncExerciseToCloud(_ exercise: Exercise) {
        // CloudKit sync implementation
        Task {
            let record = CKRecord(recordType: "Exercise")
            record["id"] = exercise.id.uuidString
            record["name"] = exercise.name
            record["description"] = exercise.description
            record["muscleGroups"] = exercise.muscleGroups
            record["category"] = exercise.category.rawValue
            
            try? await database.save(record)
        }
    }
    
    private func deleteExerciseFromCloud(_ exercise: Exercise) {
        Task {
            let recordID = CKRecord.ID(recordName: exercise.id.uuidString)
            try? await database.deleteRecord(withID: recordID)
        }
    }
    
    private func syncProgramToCloud(_ program: TrainingProgram) {
        Task {
            let record = CKRecord(recordType: "TrainingProgram")
            record["id"] = program.id.uuidString
            record["name"] = program.name
            record["description"] = program.description
            if let data = try? JSONEncoder().encode(program.exercises) {
                record["exercises"] = String(data: data, encoding: .utf8)
            }
            record["schedule"] = program.schedule
            
            try? await database.save(record)
        }
    }
    
    private func deleteProgramFromCloud(_ program: TrainingProgram) {
        Task {
            let recordID = CKRecord.ID(recordName: program.id.uuidString)
            try? await database.deleteRecord(withID: recordID)
        }
    }
    
    private func syncLogToCloud(_ log: TrainingLog) {
        Task {
            let record = CKRecord(recordType: "TrainingLog")
            record["id"] = log.id.uuidString
            record["date"] = log.date
            record["exerciseId"] = log.exerciseId.uuidString
            if let programId = log.programId {
                record["programId"] = programId.uuidString
            }
            if let data = try? JSONEncoder().encode(log.sets) {
                record["sets"] = String(data: data, encoding: .utf8)
            }
            record["duration"] = log.duration
            record["notes"] = log.notes
            
            try? await database.save(record)
        }
    }
    
    private func deleteLogFromCloud(_ log: TrainingLog) {
        Task {
            let recordID = CKRecord.ID(recordName: log.id.uuidString)
            try? await database.deleteRecord(withID: recordID)
        }
    }
    
    public func syncFromCloud() async {
        // Sync exercises
        let exerciseQuery = CKQuery(recordType: "Exercise", predicate: NSPredicate(value: true))
        if let results = try? await database.records(matching: exerciseQuery) {
            // Process results
        }
        
        // Sync programs
        let programQuery = CKQuery(recordType: "TrainingProgram", predicate: NSPredicate(value: true))
        if let results = try? await database.records(matching: programQuery) {
            // Process results
        }
        
        // Sync logs
        let logQuery = CKQuery(recordType: "TrainingLog", predicate: NSPredicate(value: true))
        if let results = try? await database.records(matching: logQuery) {
            // Process results
        }
    }
}
