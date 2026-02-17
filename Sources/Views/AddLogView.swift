import SwiftUI

public struct AddLogView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @ObservedObject private var healthKitManager = HealthKitManager.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedExerciseId: UUID?
    @State private var selectedProgramId: UUID?
    @State private var date = Date()
    @State private var sets: [ExerciseSet] = []
    @State private var notes = ""
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var saveToHealthKit = false
    
    public init() {}
    
    private var duration: TimeInterval {
        max(0, endTime.timeIntervalSince(startTime))
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                Section("Exercise") {
                    Picker("Exercise", selection: $selectedExerciseId) {
                        Text("Select Exercise").tag(nil as UUID?)
                        ForEach(dataManager.exercises) { exercise in
                            Text(exercise.name).tag(exercise.id as UUID?)
                        }
                    }
                    
                    Picker("Program (Optional)", selection: $selectedProgramId) {
                        Text("None").tag(nil as UUID?)
                        ForEach(dataManager.trainingPrograms) { program in
                            Text(program.name).tag(program.id as UUID?)
                        }
                    }
                }
                
                Section("When") {
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                    DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                    
                    if duration > 0 {
                        LabeledContent("Duration") {
                            Text(formatDuration(duration))
                        }
                    }
                }
                
                Section("Sets") {
                    ForEach(sets.indices, id: \.self) { index in
                        VStack {
                            HStack {
                                Text("Set \(index + 1)")
                                    .font(.headline)
                                Spacer()
                                Button(action: { removeSet(at: index) }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                            
                            HStack {
                                TextField("Reps", value: $sets[index].reps, format: .number)
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.numberPad)
                                
                                TextField("Weight (kg)", value: $sets[index].weight, format: .number)
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.decimalPad)
                                
                                Toggle("", isOn: $sets[index].completed)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    
                    Button(action: addSet) {
                        Label("Add Set", systemImage: "plus.circle.fill")
                    }
                }
                
                Section("Notes") {
                    TextField("Add notes...", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("HealthKit") {
                    Toggle("Save to HealthKit", isOn: $saveToHealthKit)
                }
            }
            .navigationTitle("Log Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await saveLog()
                        }
                    }
                    .disabled(selectedExerciseId == nil || sets.isEmpty)
                }
            }
        }
    }
    
    private func addSet() {
        sets.append(ExerciseSet(reps: 10, weight: 0.0, completed: false))
    }
    
    private func removeSet(at index: Int) {
        sets.remove(at: index)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return "\(minutes)m \(seconds)s"
    }
    
    private func saveLog() async {
        guard let exerciseId = selectedExerciseId else { return }
        
        let log = TrainingLog(
            date: date,
            exerciseId: exerciseId,
            programId: selectedProgramId,
            sets: sets,
            duration: duration,
            notes: notes
        )
        
        dataManager.addTrainingLog(log)
        
        // Save to HealthKit if enabled
        if saveToHealthKit, let exercise = dataManager.exercises.first(where: { $0.id == exerciseId }) {
            if !healthKitManager.isAuthorized {
                try? await healthKitManager.requestAuthorization()
            }
            
            if healthKitManager.isAuthorized {
                try? await healthKitManager.saveWorkout(
                    exercise: exercise,
                    log: log,
                    startDate: startTime,
                    endDate: endTime
                )
            }
        }
        
        dismiss()
    }
}
