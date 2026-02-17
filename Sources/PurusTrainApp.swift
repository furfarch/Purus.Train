import SwiftUI

@main
public struct PurusTrainApp: App {
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var healthKitManager = HealthKitManager.shared
    
    public init() {}
    
    public var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    // Request HealthKit authorization on app launch
                    try? await healthKitManager.requestAuthorization()
                    // Sync with CloudKit
                    await dataManager.syncFromCloud()
                }
        }
    }
}

public struct ContentView: View {
    public init() {}
    
    public var body: some View {
        TabView {
            ExerciseListView()
                .tabItem {
                    Label("Exercises", systemImage: "figure.strengthtraining.traditional")
                }
            
            ProgramListView()
                .tabItem {
                    Label("Programs", systemImage: "list.bullet.clipboard")
                }
            
            LogListView()
                .tabItem {
                    Label("Logs", systemImage: "chart.line.uptrend.xyaxis")
                }
        }
    }
}

#Preview {
    ContentView()
}
