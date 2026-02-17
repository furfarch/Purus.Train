# Contributing to purus.TRAIN

Thank you for your interest in contributing to purus.TRAIN! This document provides guidelines for contributing to the project.

## Philosophy

purus.TRAIN is part of the purus series - minimalist apps focused on core functionality. When contributing, please keep these principles in mind:

- **Simplicity First**: Avoid adding complex features that distract from core training management
- **Performance**: Keep the app fast and responsive
- **Privacy**: User data stays private and secure
- **Cross-Platform**: Support iPhone, iPad, and Apple Watch

## Getting Started

1. Fork the repository
2. Clone your fork locally
3. Follow the setup instructions in `XCODE_SETUP.md`
4. Create a branch for your changes
5. Make your changes
6. Test thoroughly
7. Submit a pull request

## What We're Looking For

### Welcome Contributions

- Bug fixes
- Performance improvements
- UI/UX enhancements
- Documentation improvements
- Code quality improvements
- Accessibility improvements
- Localization/translations
- Test coverage

### Carefully Consider

- New features (must align with minimalist philosophy)
- Third-party dependencies (avoid if possible)
- Breaking changes to data models
- Changes to core architecture

## Development Guidelines

### Code Style

- Follow Swift API Design Guidelines
- Use SwiftUI best practices
- Keep functions small and focused
- Add comments for complex logic
- Use meaningful variable names

```swift
// Good
func addExercise(_ exercise: Exercise) {
    exercises.append(exercise)
    saveExercises()
    syncExerciseToCloud(exercise)
}

// Avoid
func doStuff(e: Exercise) {
    arr.append(e)
    save()
    sync(e)
}
```

### Project Structure

Maintain the existing structure:
```
Sources/
├── Models/          # Data models only
├── Views/           # SwiftUI views
├── Services/        # Business logic and integrations
└── *.swift          # App entry points
```

### Data Models

- Keep models simple and Codable
- Use descriptive property names
- Add documentation comments
- Maintain backward compatibility

### Views

- Use SwiftUI declarative syntax
- Keep views focused (single responsibility)
- Extract reusable components
- Support dynamic type
- Ensure VoiceOver compatibility

### Services

- Use async/await for async operations
- Handle errors gracefully
- Use @MainActor for UI updates
- Keep services stateless when possible

## Testing

### Before Submitting

Test your changes on:
- [ ] iPhone (portrait and landscape)
- [ ] iPad
- [ ] Apple Watch (if applicable)
- [ ] iOS Simulator
- [ ] Physical device (for HealthKit features)
- [ ] Different screen sizes
- [ ] Light and dark mode
- [ ] VoiceOver enabled

### Data Testing

- [ ] Create new records
- [ ] Edit existing records
- [ ] Delete records
- [ ] Search/filter functionality
- [ ] Data persistence (restart app)
- [ ] CloudKit sync (if applicable)
- [ ] HealthKit export (if applicable)

## Pull Request Process

1. **Update Documentation**
   - Update README.md if needed
   - Add comments to new code
   - Update ARCHITECTURE.md for structural changes

2. **Describe Your Changes**
   - Clear title summarizing the change
   - Detailed description of what and why
   - Screenshots for UI changes
   - Reference any related issues

3. **Keep PRs Focused**
   - One feature or fix per PR
   - Avoid mixing refactoring with features
   - Keep changes minimal and targeted

4. **Code Review**
   - Respond to feedback promptly
   - Make requested changes
   - Ask questions if unclear

## Commit Messages

Use clear, descriptive commit messages:

```
Good:
- Add search functionality to exercise list
- Fix crash when deleting training program
- Improve iPad layout for program detail view

Avoid:
- Update files
- Fix bug
- Changes
```

Format:
```
[Component] Brief description

Detailed explanation if needed.
References #issue-number if applicable.
```

## Issue Guidelines

### Reporting Bugs

Include:
- iOS version
- Device model
- Steps to reproduce
- Expected behavior
- Actual behavior
- Screenshots if applicable
- Console logs if available

### Feature Requests

Include:
- Clear description of the feature
- Use case / problem it solves
- How it fits with the minimalist philosophy
- Mockups or examples (if UI related)

## Areas for Contribution

### High Priority

- Bug fixes
- Performance optimizations
- Accessibility improvements
- Documentation improvements

### Medium Priority

- UI/UX enhancements
- Additional HealthKit metrics
- CloudKit sync improvements
- Localization

### Low Priority (Carefully Considered)

- New features
- Architecture changes
- New dependencies

## Code Review Checklist

Before submitting, verify:

- [ ] Code builds without warnings
- [ ] No force unwrapping (`!`) without justification
- [ ] Error handling implemented
- [ ] Memory leaks checked
- [ ] Performance tested
- [ ] Accessibility considered
- [ ] Documentation updated
- [ ] No sensitive data in code
- [ ] Privacy maintained

## CloudKit Considerations

When modifying CloudKit integration:

- Test in development environment first
- Don't break existing sync for current users
- Handle migration if changing schema
- Consider offline functionality
- Test conflict resolution

## HealthKit Considerations

When modifying HealthKit integration:

- Always request permissions properly
- Handle permission denial gracefully
- Only request needed data types
- Respect user privacy
- Test on physical device only

## Questions?

If you have questions about contributing:

1. Check existing documentation
2. Search existing issues
3. Open a discussion issue
4. Be patient and respectful

## Code of Conduct

- Be respectful and inclusive
- Assume good intentions
- Provide constructive feedback
- Focus on the code, not the person
- Help others learn and grow

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

## Recognition

Contributors will be recognized in the project. Thank you for helping make purus.TRAIN better!

---

**Note**: This is a learning project and part of the purus series. We welcome contributions from developers of all skill levels!
