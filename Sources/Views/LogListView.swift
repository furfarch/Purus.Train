import SwiftUI

public struct LogListView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var showingAddLog = false
    @State private var selectedDate = Date()
    
    public init() {}
    
    private var filteredLogs: [TrainingLog] {
        let calendar = Calendar.current
        return dataManager.trainingLogs.filter { log in
            calendar.isDate(log.date, inSameDayAs: selectedDate)
        }.sorted { $0.date > $1.date }
    }
    
    private var groupedLogs: [Date: [TrainingLog]] {
        Dictionary(grouping: dataManager.trainingLogs) { log in
            Calendar.current.startOfDay(for: log.date)
        }
    }
    
    public var body: some View {
        NavigationStack {
            VStack {
                DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding()
                
                List {
                    if filteredLogs.isEmpty {
                        ContentUnavailableView(
                            "No Logs",
                            systemImage: "list.bullet.clipboard",
                            description: Text("No training logs for this date")
                        )
                    } else {
                        ForEach(filteredLogs) { log in
                            NavigationLink(destination: LogDetailView(log: log)) {
                                LogRowView(log: log)
                            }
                        }
                        .onDelete(perform: deleteLogs)
                    }
                }
            }
            .navigationTitle("Training Logs")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddLog = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddLog) {
                AddLogView()
            }
        }
    }
    
    private func deleteLogs(at offsets: IndexSet) {
        for index in offsets {
            let log = filteredLogs[index]
            dataManager.deleteTrainingLog(log)
        }
    }
}

struct LogRowView: View {
    @ObservedObject private var dataManager = DataManager.shared
    let log: TrainingLog
    
    private var exercise: Exercise? {
        dataManager.exercises.first(where: { $0.id == log.exerciseId })
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(exercise?.name ?? "Unknown Exercise")
                .font(.headline)
            
            HStack {
                Text("\(log.sets.count) sets")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if log.duration > 0 {
                    Text("•")
                        .foregroundColor(.secondary)
                    Text(formatDuration(log.duration))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Text(log.date.formatted(date: .omitted, time: .shortened))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    }
}
