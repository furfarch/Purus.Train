import SwiftUI

public struct LogDetailView: View {
    @ObservedObject private var dataManager = DataManager.shared
    let log: TrainingLog
    
    private var exercise: Exercise? {
        dataManager.exercises.first(where: { $0.id == log.exerciseId })
    }
    
    private var program: TrainingProgram? {
        if let programId = log.programId {
            return dataManager.trainingPrograms.first(where: { $0.id == programId })
        }
        return nil
    }
    
    public init(log: TrainingLog) {
        self.log = log
    }
    
    public var body: some View {
        Form {
            Section("Exercise") {
                LabeledContent("Name", value: exercise?.name ?? "Unknown")
                LabeledContent("Date", value: log.date.formatted(date: .long, time: .shortened))
                
                if let program = program {
                    LabeledContent("Program", value: program.name)
                }
            }
            
            Section("Sets") {
                ForEach(Array(log.sets.enumerated()), id: \.element.id) { index, set in
                    HStack {
                        Text("Set \(index + 1)")
                            .font(.headline)
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("\(set.reps) reps")
                            if set.weight > 0 {
                                Text("\(set.weight, specifier: "%.1f") kg")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        if set.completed {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            
            Section("Details") {
                if log.duration > 0 {
                    LabeledContent("Duration") {
                        Text(formatDuration(log.duration))
                    }
                }
                
                if !log.notes.isEmpty {
                    LabeledContent("Notes") {
                        Text(log.notes)
                    }
                }
            }
        }
        .navigationTitle("Workout Log")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        if minutes > 0 {
            return "\(minutes) minutes \(seconds) seconds"
        } else {
            return "\(seconds) seconds"
        }
    }
}
