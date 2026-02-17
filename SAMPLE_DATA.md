# Sample Data for purus.TRAIN

This file contains sample data that demonstrates the structure of the app's data models.

## Sample Exercises

```json
[
  {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "name": "Barbell Bench Press",
    "description": "Compound chest exercise performed lying on a bench",
    "muscleGroups": ["Chest", "Shoulders", "Triceps"],
    "category": "Strength",
    "createdDate": "2024-01-15T10:00:00Z",
    "modifiedDate": "2024-01-15T10:00:00Z"
  },
  {
    "id": "550e8400-e29b-41d4-a716-446655440001",
    "name": "Squats",
    "description": "Fundamental lower body compound movement",
    "muscleGroups": ["Quadriceps", "Glutes", "Hamstrings"],
    "category": "Strength",
    "createdDate": "2024-01-15T10:05:00Z",
    "modifiedDate": "2024-01-15T10:05:00Z"
  },
  {
    "id": "550e8400-e29b-41d4-a716-446655440002",
    "name": "Running",
    "description": "Cardiovascular endurance training",
    "muscleGroups": ["Full Body"],
    "category": "Cardio",
    "createdDate": "2024-01-15T10:10:00Z",
    "modifiedDate": "2024-01-15T10:10:00Z"
  },
  {
    "id": "550e8400-e29b-41d4-a716-446655440003",
    "name": "Pull-ups",
    "description": "Upper body pulling exercise",
    "muscleGroups": ["Back", "Biceps"],
    "category": "Strength",
    "createdDate": "2024-01-15T10:15:00Z",
    "modifiedDate": "2024-01-15T10:15:00Z"
  },
  {
    "id": "550e8400-e29b-41d4-a716-446655440004",
    "name": "Yoga Flow",
    "description": "Full body stretching and flexibility routine",
    "muscleGroups": ["Full Body"],
    "category": "Flexibility",
    "createdDate": "2024-01-15T10:20:00Z",
    "modifiedDate": "2024-01-15T10:20:00Z"
  }
]
```

## Sample Training Program

```json
{
  "id": "660e8400-e29b-41d4-a716-446655440000",
  "name": "Full Body Strength Program",
  "description": "A comprehensive 3-day full body strength training program",
  "exercises": [
    {
      "id": "770e8400-e29b-41d4-a716-446655440000",
      "exerciseId": "550e8400-e29b-41d4-a716-446655440001",
      "sets": 4,
      "reps": 8,
      "restSeconds": 90,
      "notes": "Focus on depth and form"
    },
    {
      "id": "770e8400-e29b-41d4-a716-446655440001",
      "exerciseId": "550e8400-e29b-41d4-a716-446655440000",
      "sets": 3,
      "reps": 10,
      "restSeconds": 60,
      "notes": "Lower weight to bar at chest level"
    },
    {
      "id": "770e8400-e29b-41d4-a716-446655440002",
      "exerciseId": "550e8400-e29b-41d4-a716-446655440003",
      "sets": 3,
      "reps": 12,
      "restSeconds": 60,
      "notes": "Use assistance if needed"
    }
  ],
  "schedule": ["Monday", "Wednesday", "Friday"],
  "createdDate": "2024-01-20T14:00:00Z",
  "modifiedDate": "2024-01-20T14:00:00Z"
}
```

## Sample Training Log

```json
{
  "id": "880e8400-e29b-41d4-a716-446655440000",
  "date": "2024-02-17T18:30:00Z",
  "exerciseId": "550e8400-e29b-41d4-a716-446655440001",
  "programId": "660e8400-e29b-41d4-a716-446655440000",
  "sets": [
    {
      "id": "990e8400-e29b-41d4-a716-446655440000",
      "reps": 8,
      "weight": 100.0,
      "completed": true
    },
    {
      "id": "990e8400-e29b-41d4-a716-446655440001",
      "reps": 8,
      "weight": 100.0,
      "completed": true
    },
    {
      "id": "990e8400-e29b-41d4-a716-446655440002",
      "reps": 7,
      "weight": 100.0,
      "completed": true
    },
    {
      "id": "990e8400-e29b-41d4-a716-446655440003",
      "reps": 6,
      "weight": 100.0,
      "completed": true
    }
  ],
  "duration": 1800,
  "notes": "Felt strong today, might increase weight next session",
  "createdDate": "2024-02-17T18:30:00Z"
}
```

## How to Use Sample Data

### Method 1: Manual Entry
1. Launch the app
2. Navigate to the Exercises tab
3. Tap "+" to add exercises manually
4. Create programs from your exercises
5. Log workouts as you complete them

### Method 2: Programmatic Import (for development)

Add this code to `DataManager.swift` for testing:

```swift
public func loadSampleData() {
    // Sample exercises
    let benchPress = Exercise(
        name: "Barbell Bench Press",
        description: "Compound chest exercise performed lying on a bench",
        muscleGroups: ["Chest", "Shoulders", "Triceps"],
        category: .strength
    )
    
    let squats = Exercise(
        name: "Squats",
        description: "Fundamental lower body compound movement",
        muscleGroups: ["Quadriceps", "Glutes", "Hamstrings"],
        category: .strength
    )
    
    let running = Exercise(
        name: "Running",
        description: "Cardiovascular endurance training",
        muscleGroups: ["Full Body"],
        category: .cardio
    )
    
    let pullups = Exercise(
        name: "Pull-ups",
        description: "Upper body pulling exercise",
        muscleGroups: ["Back", "Biceps"],
        category: .strength
    )
    
    // Add exercises
    addExercise(benchPress)
    addExercise(squats)
    addExercise(running)
    addExercise(pullups)
    
    // Sample program
    let program = TrainingProgram(
        name: "Full Body Strength Program",
        description: "A comprehensive 3-day full body strength training program",
        exercises: [
            ProgramExercise(exerciseId: squats.id, sets: 4, reps: 8, restSeconds: 90),
            ProgramExercise(exerciseId: benchPress.id, sets: 3, reps: 10, restSeconds: 60),
            ProgramExercise(exerciseId: pullups.id, sets: 3, reps: 12, restSeconds: 60)
        ],
        schedule: ["Monday", "Wednesday", "Friday"]
    )
    
    addTrainingProgram(program)
    
    // Sample log
    let log = TrainingLog(
        exerciseId: squats.id,
        programId: program.id,
        sets: [
            ExerciseSet(reps: 8, weight: 100.0, completed: true),
            ExerciseSet(reps: 8, weight: 100.0, completed: true),
            ExerciseSet(reps: 7, weight: 100.0, completed: true),
            ExerciseSet(reps: 6, weight: 100.0, completed: true)
        ],
        duration: 1800,
        notes: "Felt strong today"
    )
    
    addTrainingLog(log)
}
```

Then call it from the app initialization:
```swift
// In PurusTrainApp.swift
.task {
    // Load sample data on first launch
    if dataManager.exercises.isEmpty {
        dataManager.loadSampleData()
    }
    // ... rest of initialization
}
```

## Exercise Categories

Available categories:
- **Strength**: Weight lifting, resistance training
- **Cardio**: Running, cycling, swimming
- **Flexibility**: Yoga, stretching, mobility work
- **Balance**: Balance exercises, stability training
- **Other**: Any exercise that doesn't fit other categories

## Muscle Groups

Common muscle groups to tag exercises with:
- Chest
- Back
- Shoulders
- Biceps
- Triceps
- Forearms
- Abs
- Obliques
- Quadriceps
- Hamstrings
- Glutes
- Calves
- Full Body

## Data Persistence

The app stores data in three JSON files:
- `exercises.json` - All exercises
- `programs.json` - All training programs
- `logs.json` - All workout logs

Location: App Documents directory
- iOS: `/var/mobile/Containers/Data/Application/[UUID]/Documents/`
- Simulator: `~/Library/Developer/CoreSimulator/Devices/[UUID]/data/Containers/Data/Application/[UUID]/Documents/`

## CloudKit Sync

When enabled, data automatically syncs to:
- iCloud private database
- Accessible from all devices signed into the same iCloud account
- Record types: Exercise, TrainingProgram, TrainingLog

## HealthKit Export

When "Save to HealthKit" is enabled in logs:
- Creates HKWorkout records
- Includes duration, activity type, and metadata
- Maps exercise categories to workout types:
  - Strength → Traditional Strength Training
  - Cardio → Running (or appropriate type)
  - Flexibility → Yoga
  - Balance → Functional Strength Training
  - Other → Other
