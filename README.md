# purus.TRAIN

Part of the purus Series - Minimalist apps focused on training.

A SwiftUI-based iOS application for managing training exercises, programs, and workout logs with iCloud synchronization and HealthKit integration.

## Features

### Core Features
- **Exercise Management**: Create, edit, and organize exercises with categories and muscle group tracking
- **Training Programs**: Build custom workout programs with multiple exercises, sets, and reps
- **Training Logs**: Record workout sessions with detailed set and rep tracking
- **HealthKit Integration**: Automatically sync workout data to Apple Health
- **iCloud Sync**: Seamless data synchronization across all your Apple devices

### Platform Support
- ✅ iPhone (iOS 17+)
- ✅ iPad (optimized layouts)
- ✅ Apple Watch (watchOS 10+)

## Project Structure

```
purus.TRAIN/
├── Package.swift                    # Swift Package Manager configuration
├── Sources/
│   ├── Models/
│   │   ├── Exercise.swift          # Exercise data model
│   │   ├── TrainingProgram.swift   # Training program data model
│   │   └── TrainingLog.swift       # Training log data model
│   ├── Views/
│   │   ├── ExerciseListView.swift  # Exercise list screen
│   │   ├── ExerciseDetailView.swift
│   │   ├── AddExerciseView.swift
│   │   ├── ProgramListView.swift   # Training program list
│   │   ├── ProgramDetailView.swift
│   │   ├── AddProgramView.swift
│   │   ├── LogListView.swift       # Training logs
│   │   ├── LogDetailView.swift
│   │   └── AddLogView.swift
│   ├── Services/
│   │   ├── DataManager.swift       # Data persistence and CloudKit sync
│   │   └── HealthKitManager.swift  # HealthKit integration
│   ├── PurusTrainApp.swift         # Main iOS app
│   └── WatchApp.swift              # Apple Watch companion app
├── Config/
│   ├── Info.plist                  # App configuration
│   └── purus.TRAIN.entitlements    # App capabilities
└── README.md
```

## Getting Started

### Requirements
- Xcode 15.0 or later
- iOS 17.0 or later
- watchOS 10.0 or later
- Swift 5.9 or later

### Building the Project

1. Clone the repository:
```bash
git clone https://github.com/furfarch/purus.TRAIN.git
cd purus.TRAIN
```

2. Open in Xcode:
```bash
open Package.swift
```

3. Configure signing and capabilities:
   - Select your development team
   - Update the bundle identifier if needed
   - Ensure iCloud and HealthKit capabilities are enabled

4. Build and run on your device or simulator

### Configuration

#### iCloud Setup
The app uses CloudKit for data synchronization. To enable:
1. Ensure you have an active Apple Developer account
2. In Xcode, select the project target
3. Go to "Signing & Capabilities"
4. Enable "iCloud" and "CloudKit"
5. Update the container identifier in `DataManager.swift` if needed

#### HealthKit Setup
HealthKit integration requires:
1. "HealthKit" capability enabled in your project
2. Privacy descriptions in `Info.plist` (already included)
3. The app to run on a physical device (HealthKit doesn't work in simulator)

## Usage

### Managing Exercises
1. Tap the "Exercises" tab
2. Tap "+" to add a new exercise
3. Fill in exercise details: name, description, category, and muscle groups
4. Save the exercise

### Creating Training Programs
1. Go to the "Programs" tab
2. Tap "+" to create a new program
3. Add a name and description
4. Add exercises from your exercise library
5. Configure sets, reps, and rest time for each exercise
6. Save the program

### Logging Workouts
1. Navigate to the "Logs" tab
2. Tap "+" to log a new workout
3. Select an exercise
4. Add your sets with reps and weight
5. Optionally link to a training program
6. Enable "Save to HealthKit" to sync with Apple Health
7. Save the log

### Apple Watch App
The companion Watch app provides:
- Quick access to your exercises and programs
- Fast workout logging with simplified interface
- Automatic sync with iPhone app via iCloud

## Data Models

### Exercise
- Name, description
- Category (Strength, Cardio, Flexibility, Balance, Other)
- Muscle groups
- Created/modified timestamps

### Training Program
- Name, description
- List of exercises with sets/reps configuration
- Schedule information
- Created/modified timestamps

### Training Log
- Date and time
- Exercise reference
- Optional program reference
- Sets (reps, weight, completion status)
- Duration
- Notes

## Privacy & Security

- All data is stored locally on your device
- Optional iCloud sync keeps data in your private iCloud container
- HealthKit data is never shared without explicit permission
- No analytics or tracking

## License

This project is part of the purus series - minimalist training apps.

## Contributing

This is a minimal, focused app. Contributions should maintain the simplicity and focus on core training management features.

## Support

For issues or questions, please open an issue on GitHub.
