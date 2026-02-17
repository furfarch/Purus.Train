import SwiftUI

// Apple Watch Companion App
// This is a simplified version for watchOS

@main
public struct PurusTrainWatchApp: App {
    public init() {}
    
    public var body: some Scene {
        WindowGroup {
            WatchContentView()
        }
    }
}

public struct WatchContentView: View {
    @StateObject private var dataManager = DataManager.shared
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            List {
                NavigationLink("Exercises") {
                    WatchExerciseListView()
                }
                
                NavigationLink("Programs") {
                    WatchProgramListView()
                }
                
                NavigationLink("Quick Log") {
                    WatchQuickLogView()
                }
            }
            .navigationTitle("TRAIN")
        }
    }
}

struct WatchExerciseListView: View {
    @ObservedObject private var dataManager = DataManager.shared
    
    var body: some View {
        List(dataManager.exercises) { exercise in
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(.headline)
                Text(exercise.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Exercises")
    }
}

struct WatchProgramListView: View {
    @ObservedObject private var dataManager = DataManager.shared
    
    var body: some View {
        List(dataManager.trainingPrograms) { program in
            VStack(alignment: .leading, spacing: 4) {
                Text(program.name)
                    .font(.headline)
                Text("\(program.exercises.count) exercises")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Programs")
    }
}

struct WatchQuickLogView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var selectedExerciseId: UUID?
    @State private var sets = 3
    @State private var reps = 10
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Picker("Exercise", selection: $selectedExerciseId) {
                    Text("Select").tag(nil as UUID?)
                    ForEach(dataManager.exercises) { exercise in
                        Text(exercise.name).tag(exercise.id as UUID?)
                    }
                }
                
                Stepper("Sets: \(sets)", value: $sets, in: 1...10)
                Stepper("Reps: \(reps)", value: $reps, in: 1...50)
                
                Button("Log") {
                    logWorkout()
                }
                .buttonStyle(.borderedProminent)
                .disabled(selectedExerciseId == nil)
            }
            .padding()
        }
        .navigationTitle("Quick Log")
    }
    
    private func logWorkout() {
        guard let exerciseId = selectedExerciseId else { return }
        
        let exerciseSets = (0..<sets).map { _ in
            ExerciseSet(reps: reps, weight: 0, completed: true)
        }
        
        let log = TrainingLog(
            exerciseId: exerciseId,
            sets: exerciseSets,
            duration: 0
        )
        
        dataManager.addTrainingLog(log)
    }
}
