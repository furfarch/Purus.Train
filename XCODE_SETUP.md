# Xcode Project Setup Guide

Since this repository uses Swift Package Manager, you have two options to work with the code in Xcode:

## Option 1: Open Package Directly (Simple)

1. Open `Package.swift` in Xcode
2. Xcode will load the package and all source files
3. You can edit and build the source code

**Limitations:**
- Cannot run the app directly (SPM on Linux doesn't support iOS)
- Use this for code editing and structure viewing

## Option 2: Create an Xcode iOS Project (Recommended for Development)

### Step-by-Step Instructions

1. **Create New Project**
   ```
   File > New > Project
   Choose: iOS > App
   Product Name: purus.TRAIN
   Interface: SwiftUI
   Language: Swift
   ```

2. **Configure Project**
   - Bundle Identifier: `com.furfarch.purus.TRAIN` (or your own)
   - Organization: Your name/company
   - Team: Select your development team

3. **Add Source Files**
   - Delete the default `ContentView.swift` and app file
   - Drag the entire `Sources/` folder into your project
   - Select "Create groups" and "Copy items if needed"

4. **Configure Info.plist**
   - Add HealthKit usage descriptions:
     ```xml
     <key>NSHealthShareUsageDescription</key>
     <string>purus.TRAIN needs access to HealthKit to read your workout data.</string>
     <key>NSHealthUpdateUsageDescription</key>
     <string>purus.TRAIN needs access to HealthKit to save your workout data.</string>
     ```

5. **Add Capabilities**
   - Select project > Target > Signing & Capabilities
   - Click "+ Capability"
   - Add "HealthKit"
   - Add "iCloud" > Enable "CloudKit"
   - Create or select container: `iCloud.com.furfarch.purus.TRAIN`

6. **Update DataManager**
   - Open `Sources/Services/DataManager.swift`
   - Update CloudKit container to match your identifier:
     ```swift
     self.container = CKContainer(identifier: "iCloud.YOUR-BUNDLE-ID")
     ```

7. **Build and Run**
   - Select your device or simulator
   - Press Cmd+R to build and run

## Option 3: Use the Provided Configuration

If you have the Xcode project file (`.xcodeproj`), simply:

1. Open `purus.TRAIN.xcodeproj`
2. Select your team in Signing & Capabilities
3. Build and run

## Creating the Watch App Target

1. **Add Watch App Target**
   ```
   File > New > Target
   Choose: watchOS > Watch App for iOS App
   Product Name: purus.TRAIN Watch App
   ```

2. **Add Watch Source Files**
   - Copy `Sources/WatchApp.swift` to the Watch App target
   - Add the Models and Services to both targets

3. **Configure Watch App**
   - Share the same App Group for data sharing
   - Configure CloudKit for Watch target

## Project Structure

After setup, your Xcode project should look like:

```
purus.TRAIN/
├── purus.TRAIN (iOS Target)
│   ├── Models/
│   │   ├── Exercise.swift
│   │   ├── TrainingProgram.swift
│   │   └── TrainingLog.swift
│   ├── Views/
│   │   ├── Exercise*.swift
│   │   ├── Program*.swift
│   │   └── Log*.swift
│   ├── Services/
│   │   ├── DataManager.swift
│   │   └── HealthKitManager.swift
│   └── PurusTrainApp.swift
├── purus.TRAIN Watch App (watchOS Target)
│   └── WatchApp.swift
├── Config/
│   ├── Info.plist
│   └── purus.TRAIN.entitlements
└── README.md
```

## Troubleshooting

### "No such module" errors
- Clean build folder (Cmd+Shift+K)
- Ensure all files are added to the target
- Check that import statements are correct

### Code signing issues
- Select a valid development team
- Let Xcode automatically manage signing
- Ensure your Apple ID is signed in

### HealthKit not working
- Must use a physical device (not simulator)
- Check Info.plist has usage descriptions
- Verify HealthKit capability is enabled

### CloudKit errors
- Ensure you're signed into iCloud
- Container identifier matches configuration
- Check CloudKit Dashboard for issues

## Next Steps

After setting up the project:

1. Review the code in `Sources/`
2. Read `ARCHITECTURE.md` for understanding the structure
3. Build and test on your device
4. Customize as needed for your requirements
5. Configure CloudKit schema in the dashboard
6. Test HealthKit integration on physical device

## Resources

- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [CloudKit Documentation](https://developer.apple.com/documentation/cloudkit)
- [HealthKit Documentation](https://developer.apple.com/documentation/healthkit)
