import SwiftUI

public struct ExerciseListView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var showingAddExercise = false
    @State private var searchText = ""
    
    public init() {}
    
    private var filteredExercises: [Exercise] {
        if searchText.isEmpty {
            return dataManager.exercises
        } else {
            return dataManager.exercises.filter { exercise in
                exercise.name.localizedCaseInsensitiveContains(searchText) ||
                exercise.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    public var body: some View {
        NavigationStack {
            List {
                ForEach(filteredExercises) { exercise in
                    NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                        ExerciseRowView(exercise: exercise)
                    }
                }
                .onDelete(perform: deleteExercises)
            }
            .navigationTitle("Exercises")
            .searchable(text: $searchText, prompt: "Search exercises")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddExercise = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddExercise) {
                AddExerciseView()
            }
        }
    }
    
    private func deleteExercises(at offsets: IndexSet) {
        for index in offsets {
            let exercise = filteredExercises[index]
            dataManager.deleteExercise(exercise)
        }
    }
}

struct ExerciseRowView: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(exercise.name)
                .font(.headline)
            
            if !exercise.description.isEmpty {
                Text(exercise.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            HStack {
                Text(exercise.category.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
                
                if !exercise.muscleGroups.isEmpty {
                    Text(exercise.muscleGroups.joined(separator: ", "))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
