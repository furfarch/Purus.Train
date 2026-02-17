import SwiftUI

public struct ProgramListView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var showingAddProgram = false
    @State private var searchText = ""
    
    public init() {}
    
    private var filteredPrograms: [TrainingProgram] {
        if searchText.isEmpty {
            return dataManager.trainingPrograms
        } else {
            return dataManager.trainingPrograms.filter { program in
                program.name.localizedCaseInsensitiveContains(searchText) ||
                program.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    public var body: some View {
        NavigationStack {
            List {
                ForEach(filteredPrograms) { program in
                    NavigationLink(destination: ProgramDetailView(program: program)) {
                        ProgramRowView(program: program)
                    }
                }
                .onDelete(perform: deletePrograms)
            }
            .navigationTitle("Training Programs")
            .searchable(text: $searchText, prompt: "Search programs")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddProgram = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddProgram) {
                AddProgramView()
            }
        }
    }
    
    private func deletePrograms(at offsets: IndexSet) {
        for index in offsets {
            let program = filteredPrograms[index]
            dataManager.deleteTrainingProgram(program)
        }
    }
}

struct ProgramRowView: View {
    let program: TrainingProgram
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(program.name)
                .font(.headline)
            
            if !program.description.isEmpty {
                Text(program.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            HStack {
                Label("\(program.exercises.count) exercises", systemImage: "figure.strengthtraining.traditional")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if !program.schedule.isEmpty {
                    Label("\(program.schedule.count) days", systemImage: "calendar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
