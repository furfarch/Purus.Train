# purus.TRAIN Architecture

## Overview

purus.TRAIN is built using SwiftUI with a modern, declarative UI approach. The app follows MVVM (Model-View-ViewModel) principles with a centralized data management layer.

## Architecture Layers

```
┌─────────────────────────────────────────┐
│            SwiftUI Views                │
│  (ExerciseListView, ProgramListView,    │
│   LogListView, etc.)                    │
└──────────────┬──────────────────────────┘
               │
               │ @ObservedObject
               ▼
┌─────────────────────────────────────────┐
│         Data Manager Layer              │
│    (@ObservableObject singleton)        │
│  - Local Persistence (JSON)             │
│  - CloudKit Sync                        │
└──────────────┬──────────────────────────┘
               │
               ├──────────────┬───────────┐
               ▼              ▼           ▼
         ┌─────────┐   ┌──────────┐  ┌────────┐
         │ Models  │   │ CloudKit │  │ Health │
         │         │   │          │  │  Kit   │
         └─────────┘   └──────────┘  └────────┘
```

## Core Components

### 1. Data Models (`Sources/Models/`)

**Exercise.swift**
- Represents a single exercise
- Properties: name, description, category, muscle groups
- Codable for persistence and CloudKit sync

**TrainingProgram.swift**
- Represents a workout program
- Contains multiple ProgramExercise entries
- Schedule information for planning

**TrainingLog.swift**
- Records completed workout sessions
- Contains ExerciseSet entries with reps/weight
- Links to Exercise and optionally to TrainingProgram

### 2. Services (`Sources/Services/`)

**DataManager.swift**
- Singleton pattern for centralized data access
- Handles CRUD operations for all models
- Local persistence using JSON files in Documents directory
- CloudKit synchronization (async)
- Published properties trigger UI updates via Combine

**HealthKitManager.swift**
- Manages HealthKit authorization
- Converts workout logs to HKWorkout objects
- Saves workout data to Apple Health

### 3. Views (`Sources/Views/`)

**Exercise Views**
- `ExerciseListView`: List of all exercises with search
- `ExerciseDetailView`: View/edit individual exercise
- `AddExerciseView`: Create new exercise with form

**Program Views**
- `ProgramListView`: List of training programs
- `ProgramDetailView`: View program details and exercises
- `AddProgramView`: Create program with exercise picker

**Log Views**
- `LogListView`: Calendar-based log view
- `LogDetailView`: View completed workout details
- `AddLogView`: Log a workout with sets/reps tracking

### 4. App Entry Points

**PurusTrainApp.swift** (iOS)
- Main app entry point
- Tab-based navigation
- Initializes services on launch
- Requests HealthKit authorization
- Triggers initial CloudKit sync

**WatchApp.swift** (watchOS)
- Simplified Watch interface
- Quick access to exercises and programs
- Streamlined workout logging

## Data Flow

### Creating an Exercise
```
User Input (AddExerciseView)
    ↓
DataManager.addExercise()
    ↓
├─→ Append to exercises array (triggers UI update)
├─→ Save to local JSON file
└─→ Sync to CloudKit (async)
```

### Logging a Workout
```
User Input (AddLogView)
    ↓
DataManager.addTrainingLog()
    ↓
├─→ Append to trainingLogs array
├─→ Save to local JSON file
├─→ Sync to CloudKit
└─→ If enabled: HealthKitManager.saveWorkout()
        ↓
    HKHealthStore.save()
```

### Data Synchronization
```
App Launch
    ↓
DataManager.init()
    ↓
├─→ Load local JSON files
└─→ Task: syncFromCloud()
        ↓
    CloudKit Query
        ↓
    Merge remote changes
        ↓
    Update local storage
        ↓
    UI updates automatically (@Published)
```

## Persistence Strategy

### Local Storage
- JSON files in Documents directory
- Three files: exercises.json, programs.json, logs.json
- Immediate writes on data changes
- Fast local access

### CloudKit Storage
- Private database (user-specific data)
- Three record types: Exercise, TrainingProgram, TrainingLog
- Async synchronization
- Handles conflicts with "last write wins" strategy

### HealthKit Storage
- Optional export of workout logs
- Creates HKWorkout objects
- Maps Exercise categories to HKWorkoutActivityType
- One-way sync (write only)

## UI Patterns

### List Views
- Search capability
- Swipe-to-delete
- Pull to refresh (implicit via CloudKit sync)
- Empty states with ContentUnavailableView

### Detail Views
- Edit mode toggle
- Form-based editing
- Validation before save
- Navigation bar actions

### Add/Create Views
- Sheet presentation
- Form validation
- Cancel/Save actions
- Keyboard handling

## Platform Adaptations

### iPhone
- Tab-based navigation
- Full feature set
- Portrait and landscape support

### iPad
- Responsive layouts (SwiftUI adaptive)
- Larger form factors
- Multi-column layouts where appropriate

### Apple Watch
- Simplified navigation
- Essential features only
- Large tap targets
- Quick actions

## State Management

### Published Properties
```swift
@Published public var exercises: [Exercise] = []
@Published public var trainingPrograms: [TrainingProgram] = []
@Published public var trainingLogs: [TrainingLog] = []
```

### Observable Objects
```swift
@StateObject private var dataManager = DataManager.shared
@ObservedObject private var healthKitManager = HealthKitManager.shared
```

### State Variables
```swift
@State private var showingAddExercise = false
@State private var searchText = ""
@State private var selectedDate = Date()
```

## Concurrency

### MainActor
- DataManager operations run on main thread
- UI updates are always on main thread
- @MainActor annotation ensures thread safety

### Async/Await
- CloudKit operations use async/await
- HealthKit operations use async/await
- Background sync with Task {}

## Security & Privacy

### Data Isolation
- Each user's data in private CloudKit database
- Local data stored in app sandbox
- No data sharing between users

### Permissions
- HealthKit: Requested on first use
- CloudKit: Implicit with iCloud account
- No location, camera, or other permissions needed

## Extension Points

### Adding New Features
1. **New Model**: Create in `Models/`, add to DataManager
2. **New View**: Create in `Views/`, add to navigation
3. **New Service**: Create in `Services/`, use singleton pattern

### Customization
- Update CloudKit container identifier
- Customize HealthKit data types
- Add new Exercise categories
- Extend data models with new fields

## Performance Considerations

### Optimization Strategies
- Lazy loading of views
- Efficient list rendering with ForEach
- Local caching prevents repeated network calls
- Async operations don't block UI

### Scalability
- JSON storage suitable for hundreds of records
- For thousands of records, consider Core Data
- CloudKit handles sync efficiently
- HealthKit operations are batched

## Testing Strategy

### Unit Testing
- Test data models (Codable conformance)
- Test DataManager CRUD operations
- Mock CloudKit for offline testing

### UI Testing
- Test navigation flows
- Test form validation
- Test data persistence

### Integration Testing
- Test CloudKit sync
- Test HealthKit integration
- Test multi-device scenarios

## Future Enhancements

Potential areas for expansion:
- Core Data for larger datasets
- Shared workout programs via CloudKit public database
- Progress tracking and analytics
- Social features (share workouts)
- Export/import functionality
- More HealthKit metrics integration
- Complications for Watch face
- Siri shortcuts
- Widgets for home screen
