import Foundation
import HealthKit

public class HealthKitManager: ObservableObject {
    private let healthStore = HKHealthStore()
    @Published public var isAuthorized = false
    
    public static let shared = HealthKitManager()
    
    private init() {}
    
    public func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else {
            throw HealthKitError.notAvailable
        }
        
        let typesToShare: Set<HKSampleType> = [
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        ]
        
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!
        ]
        
        try await healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead)
        
        await MainActor.run {
            isAuthorized = true
        }
    }
    
    public func saveWorkout(
        exercise: Exercise,
        log: TrainingLog,
        startDate: Date,
        endDate: Date
    ) async throws {
        guard isAuthorized else {
            throw HealthKitError.notAuthorized
        }
        
        let activityType: HKWorkoutActivityType = {
            switch exercise.category {
            case .strength:
                return .traditionalStrengthTraining
            case .cardio:
                return .running
            case .flexibility:
                return .yoga
            case .balance:
                return .functionalStrengthTraining
            case .other:
                return .other
            }
        }()
        
        let workout = HKWorkout(
            activityType: activityType,
            start: startDate,
            end: endDate,
            duration: log.duration,
            totalEnergyBurned: nil,
            totalDistance: nil,
            metadata: [
                "exerciseName": exercise.name,
                "sets": log.sets.count as NSNumber,
                "notes": log.notes
            ]
        )
        
        try await healthStore.save(workout)
    }
}

public enum HealthKitError: Error {
    case notAvailable
    case notAuthorized
}
