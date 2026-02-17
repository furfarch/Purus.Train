import SwiftUI

public struct AddProgramView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var description = ""
    @State private var selectedExercises: [ProgramExercise] = []
    @State private var showingExercisePicker = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            Form {
                Section("Basic Information") {
                    TextField("Program Name", text: $name)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section {
                    ForEach(selectedExercises) { programExercise in
                        if let exercise = dataManager.exercises.first(where: { $0.id == programExercise.exerciseId }) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(exercise.name)
                                    .font(.headline)
                                HStack {
                                    Text("\(programExercise.sets) sets")
                                    Text("×")
                                    Text("\(programExercise.reps) reps")
                                }
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            }
                        }
                    }
                    .onDelete(perform: deleteExercise)
                    
                    Button(action: { showingExercisePicker = true }) {
                        Label("Add Exercise", systemImage: "plus.circle.fill")
                    }
                } header: {
                    Text("Exercises")
                }
            }
            .navigationTitle("Add Program")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveProgram()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .sheet(isPresented: $showingExercisePicker) {
                ExercisePickerView(selectedExercises: $selectedExercises)
            }
        }
    }
    
    private func deleteExercise(at offsets: IndexSet) {
        selectedExercises.remove(atOffsets: offsets)
    }
    
    private func saveProgram() {
        let program = TrainingProgram(
            name: name,
            description: description,
            exercises: selectedExercises
        )
        dataManager.addTrainingProgram(program)
        dismiss()
    }
}

struct ExercisePickerView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedExercises: [ProgramExercise]
    
    @State private var selectedExerciseId: UUID?
    @State private var sets: Int = 3
    @State private var reps: Int = 10
    @State private var restSeconds: Int = 60
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Select Exercise") {
                    Picker("Exercise", selection: $selectedExerciseId) {
                        Text("Select...").tag(nil as UUID?)
                        ForEach(dataManager.exercises) { exercise in
                            Text(exercise.name).tag(exercise.id as UUID?)
                        }
                    }
                }
                
                if selectedExerciseId != nil {
                    Section("Configuration") {
                        Stepper("Sets: \(sets)", value: $sets, in: 1...10)
                        Stepper("Reps: \(reps)", value: $reps, in: 1...50)
                        Stepper("Rest: \(restSeconds)s", value: $restSeconds, in: 0...300, step: 15)
                    }
                }
            }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        if let exerciseId = selectedExerciseId {
                            let programExercise = ProgramExercise(
                                exerciseId: exerciseId,
                                sets: sets,
                                reps: reps,
                                restSeconds: restSeconds
                            )
                            selectedExercises.append(programExercise)
                        }
                        dismiss()
                    }
                    .disabled(selectedExerciseId == nil)
                }
            }
        }
    }
}
