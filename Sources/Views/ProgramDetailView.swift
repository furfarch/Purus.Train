import SwiftUI

public struct ProgramDetailView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var program: TrainingProgram
    @State private var isEditing = false
    @Environment(\.dismiss) private var dismiss
    
    public init(program: TrainingProgram) {
        _program = State(initialValue: program)
    }
    
    public var body: some View {
        Form {
            Section("Basic Information") {
                if isEditing {
                    TextField("Name", text: $program.name)
                    TextField("Description", text: $program.description, axis: .vertical)
                        .lineLimit(3...6)
                } else {
                    LabeledContent("Name", value: program.name)
                    if !program.description.isEmpty {
                        LabeledContent("Description", value: program.description)
                    }
                }
            }
            
            Section("Exercises") {
                ForEach(program.exercises) { exercise in
                    if let ex = dataManager.exercises.first(where: { $0.id == exercise.exerciseId }) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(ex.name)
                                .font(.headline)
                            Text("\(exercise.sets) sets × \(exercise.reps) reps")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            if exercise.restSeconds > 0 {
                                Text("Rest: \(exercise.restSeconds)s")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
            
            if !program.schedule.isEmpty {
                Section("Schedule") {
                    ForEach(program.schedule, id: \.self) { day in
                        Text(day)
                    }
                }
            }
            
            Section("History") {
                LabeledContent("Created", value: program.createdDate.formatted(date: .abbreviated, time: .shortened))
                LabeledContent("Modified", value: program.modifiedDate.formatted(date: .abbreviated, time: .shortened))
            }
        }
        .navigationTitle(program.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(isEditing ? "Done" : "Edit") {
                    if isEditing {
                        dataManager.updateTrainingProgram(program)
                    }
                    isEditing.toggle()
                }
            }
        }
    }
}
