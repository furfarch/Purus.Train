# Building and Running purus.TRAIN

## Prerequisites

- macOS 14.0 (Sonoma) or later
- Xcode 15.0 or later
- An Apple Developer account (for device deployment and iCloud/HealthKit features)
- iOS 17.0+ device or simulator
- Apple Watch with watchOS 10.0+ (for Watch app testing)

## Quick Start

### Option 1: Using Xcode (Recommended)

1. **Clone the repository**
   ```bash
   git clone https://github.com/furfarch/purus.TRAIN.git
   cd purus.TRAIN
   ```

2. **Open in Xcode**
   - Double-click `Package.swift` to open in Xcode
   - Or run: `open Package.swift`
   - Or create a new Xcode project and add the existing source files

3. **Configure the Project**
   - Select the project in the Project Navigator
   - Choose a target (iOS or watchOS)
   - In "Signing & Capabilities":
     - Select your development team
     - Ensure "Automatically manage signing" is checked
     - Verify the bundle identifier matches your team

4. **Enable Required Capabilities**
   - **HealthKit**: Already configured in entitlements
   - **iCloud**: CloudKit container `iCloud.com.furfarch.purus.TRAIN`
     - Update to match your bundle identifier if needed
   - **Background Modes**: (Optional) for background sync

5. **Build and Run**
   - Select your target device or simulator
   - Press `Cmd + R` or click the Play button
   - For Watch app: Select the Watch target and run

### Option 2: Creating an Xcode Project from Scratch

If you prefer to create a new Xcode project:

1. Create a new iOS App project in Xcode
2. Copy all files from `Sources/` to your project
3. Add the following frameworks:
   - SwiftUI.framework
   - CloudKit.framework
   - HealthKit.framework
4. Configure Info.plist and entitlements as shown in `Config/`
5. Build and run

## Configuration

### Bundle Identifier

Update the bundle identifier in your project to match your Apple Developer account:
- Default: `com.furfarch.purus.TRAIN`
- Update in: Project Settings > General > Bundle Identifier

### iCloud Container

Update the CloudKit container identifier in `Sources/Services/DataManager.swift`:
```swift
private init() {
    self.container = CKContainer(identifier: "iCloud.YOUR-BUNDLE-ID")
    // ...
}
```

### Team ID

The entitlements file uses `$(TeamIdentifierPrefix)` which Xcode automatically replaces with your team ID.

## Testing

### Testing on Simulator
- Most features work in the iOS Simulator
- **Note**: HealthKit does NOT work in the simulator - use a physical device

### Testing on Device
1. Connect your iOS device via USB or wirelessly
2. Trust the developer certificate on the device
3. Select your device in Xcode
4. Build and run

### Testing the Watch App
1. Ensure your iPhone is paired with an Apple Watch
2. Select the Watch target in Xcode
3. Choose your paired Watch as the destination
4. Build and run

## Common Issues

### "No such module 'SwiftUI'"
This error occurs when building with Swift Package Manager on Linux. The app must be built with Xcode on macOS.

### HealthKit Permission Denied
- Check that HealthKit is enabled in Capabilities
- Ensure you're running on a physical device
- Check that the privacy descriptions are in Info.plist

### iCloud Sync Not Working
- Verify you're signed into iCloud on the device
- Check that the CloudKit container identifier matches
- Ensure the iCloud capability is properly configured
- Check the CloudKit Dashboard for container status

### Code Signing Issues
- Select your development team in Xcode
- Let Xcode automatically manage signing
- Ensure your Apple Developer account is active

## Advanced Setup

### CloudKit Dashboard

1. Go to [CloudKit Dashboard](https://icloud.developer.apple.com/dashboard)
2. Select your container
3. The app will create record types automatically on first sync:
   - Exercise
   - TrainingProgram
   - TrainingLog

### Custom CloudKit Configuration

To customize CloudKit schema:
1. Go to CloudKit Dashboard
2. Development or Production environment
3. Add indexes for better query performance
4. Configure security roles if sharing data

### HealthKit Data Types

The app requests access to:
- **Read**: Workouts, Active Energy, Heart Rate
- **Write**: Workouts, Active Energy

To add more data types, update `HealthKitManager.swift`:
```swift
let typesToShare: Set<HKSampleType> = [
    // Add more types here
]
```

## Deployment

### TestFlight

1. Archive your app: Product > Archive
2. Distribute to App Store Connect
3. Create a TestFlight build
4. Add internal or external testers

### App Store

1. Complete App Store Connect setup
2. Add app description, screenshots, etc.
3. Submit for review
4. Follow Apple's review process

## Troubleshooting

### Build Errors
- Clean build folder: Product > Clean Build Folder (Cmd + Shift + K)
- Delete derived data: ~/Library/Developer/Xcode/DerivedData
- Restart Xcode

### Runtime Errors
- Check console logs in Xcode
- Verify all capabilities are properly configured
- Ensure data models match saved data

## Support

For issues or questions:
- Open an issue on GitHub
- Check Apple Developer documentation for platform-specific issues
- Review the code comments for implementation details
