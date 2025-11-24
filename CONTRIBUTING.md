# Contributing to Sistem Pakar Dermatologi

Thank you for your interest in contributing to this dermatological expert system! This document provides guidelines for contributing to the project.

---

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Documentation](#documentation)
- [Pull Request Process](#pull-request-process)
- [Issue Guidelines](#issue-guidelines)

---

## 🤝 Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive experience for everyone. We expect all contributors to:

- Use welcoming and inclusive language
- Be respectful of differing viewpoints
- Accept constructive criticism gracefully
- Focus on what is best for the community
- Show empathy towards other community members

---

## 🚀 Getting Started

### Prerequisites

Before contributing, ensure you have:

- Flutter SDK (≥3.9.2)
- Dart (≥3.9.2)
- Git
- A code editor (VS Code or Android Studio recommended)
- Basic understanding of Flutter and Dart
- Familiarity with Case-Based Reasoning (helpful but not required)

### First Time Contributors

1. Read the [README.md](README.md) to understand the project
2. Check the [documentation](docs/) for technical details
3. Look for issues labeled `good first issue` or `help wanted`
4. Join our community discussions

---

## 💻 Development Setup

### 1. Fork and Clone

```bash
# Fork the repository on GitHub
# Then clone your fork
git clone https://github.com/YOUR-USERNAME/sistem_pakar_jamur.git
cd sistem_pakar_jamur
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Verify Setup

```bash
flutter doctor
flutter analyze
flutter test
```

### 4. Create a Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/issue-description
```

---

## 🔧 How to Contribute

### Types of Contributions

We welcome:

#### 🐛 Bug Fixes
- Fix compilation errors
- Fix runtime errors
- Fix UI glitches
- Fix calculation errors

#### ✨ Features
- New UI components
- Additional algorithms
- Enhanced visualizations
- Performance improvements

#### 📚 Documentation
- Improve existing docs
- Add code examples
- Write tutorials
- Translate documentation

#### 🧪 Tests
- Add unit tests
- Add widget tests
- Add integration tests
- Improve test coverage

#### 🎨 Design
- UI/UX improvements
- Accessibility enhancements
- Theme customization
- Icon design

---

## 📝 Coding Standards

### Dart Style Guide

Follow the official [Dart style guide](https://dart.dev/guides/language/effective-dart/style):

#### Naming Conventions

```dart
// Classes: UpperCamelCase
class DiagnosisResult { }

// Variables and functions: lowerCamelCase
int patientAge = 35;
void calculateSimilarity() { }

// Constants: lowerCamelCase
const double defaultWeight = 1.0;

// Private members: prefix with underscore
int _privateValue;
void _privateMethod() { }
```

#### Code Formatting

```bash
# Auto-format code
flutter format .

# Check formatting
flutter format --set-exit-if-changed .
```

#### Code Quality

```bash
# Run analyzer
flutter analyze

# No errors or warnings allowed
# Fix all issues before committing
```

### Architecture Principles

#### 1. Separation of Concerns
```
models/     - Data structures only
services/   - Business logic only
screens/    - UI screens only
widgets/    - Reusable UI components
```

#### 2. Clean Code
- Keep functions small (< 50 lines)
- Use meaningful variable names
- Add comments for complex logic
- Remove dead code

#### 3. Null Safety
```dart
// Always use null-safe types
String? optionalValue;  // Can be null
String requiredValue;   // Never null
```

### Documentation Standards

#### Inline Comments

```dart
/// Calculates similarity between user input and database case.
///
/// Uses weighted Euclidean distance with normalization.
/// Returns a value between 0.0 (no similarity) and 1.0 (identical).
///
/// Example:
/// ```dart
/// final similarity = calculateSimilarity(input, case);
/// print(similarity); // 0.75 (75% match)
/// ```
double calculateSimilarity(UserInput input, DermatologyCase case_) {
  // Implementation
}
```

#### TODO Comments

```dart
// TODO(username): Add support for photo-based diagnosis
// FIXME(username): Fix calculation error for edge case
// NOTE: This uses a simplified algorithm for performance
```

---

## 🧪 Testing Guidelines

### Writing Tests

#### Unit Tests

```dart
// test/services/cbr_service_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CbrService', () {
    test('calculateSimilarity returns correct value', () {
      // Arrange
      final service = CbrService();
      final input = UserInput(/* ... */);
      final case_ = DermatologyCase(/* ... */);
      
      // Act
      final similarity = service.calculateSimilarity(input, case_);
      
      // Assert
      expect(similarity, closeTo(0.75, 0.01));
    });
  });
}
```

#### Widget Tests

```dart
// test/screens/diagnosis_screen_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DiagnosisScreen displays results', (tester) async {
    // Build widget
    await tester.pumpWidget(MyApp());
    
    // Interact
    await tester.tap(find.text('Diagnosa'));
    await tester.pump();
    
    // Verify
    expect(find.text('Hasil Diagnosa'), findsOneWidget);
  });
}
```

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test
flutter test test/services/cbr_service_test.dart

# View coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Test Coverage Requirements

- Minimum: 70% overall coverage
- Critical code: 90% coverage (algorithms, calculations)
- UI code: 50% coverage (widgets, screens)

---

## 📚 Documentation

### When to Update Documentation

Update documentation when you:
- Add new features
- Change existing behavior
- Fix bugs that affect usage
- Modify APIs
- Add new dependencies

### Documentation Files to Update

1. **README.md** - Overview and quick start
2. **Inline comments** - Code documentation
3. **Technical guides** - IMPLEMENTATION.md, CBR_ALGORITHM.md
4. **User guide** - USER_GUIDE.md
5. **Changelog** - CHANGELOG.md

### Documentation Style

- Use clear, concise language
- Include code examples
- Add diagrams when helpful
- Keep it up-to-date

---

## 🔄 Pull Request Process

### Before Submitting

1. ✅ Code compiles without errors
2. ✅ All tests pass
3. ✅ Code formatted (`flutter format .`)
4. ✅ No analyzer warnings (`flutter analyze`)
5. ✅ Documentation updated
6. ✅ Commit messages are clear

### Commit Message Format

```
type(scope): subject

body (optional)

footer (optional)
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(ui): add dark mode support

- Add theme switcher widget
- Update all screens with dark theme
- Add user preference storage

Closes #123
```

```
fix(algorithm): correct similarity calculation for edge cases

The previous implementation didn't handle zero-value ranges correctly.
Now properly checks for division by zero.

Fixes #456
```

### Pull Request Template

When creating a PR, include:

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement

## Testing
- [ ] Unit tests added/updated
- [ ] Widget tests added/updated
- [ ] Manual testing completed

## Checklist
- [ ] Code compiles without errors
- [ ] Tests pass
- [ ] Code formatted
- [ ] Documentation updated
- [ ] No analyzer warnings

## Screenshots (if applicable)
Add screenshots here

## Related Issues
Closes #123
```

### Review Process

1. **Automated Checks**: CI/CD runs tests and analysis
2. **Code Review**: Maintainers review code
3. **Feedback**: Address review comments
4. **Approval**: At least one maintainer approval required
5. **Merge**: Squash and merge into main branch

---

## 🐛 Issue Guidelines

### Before Creating an Issue

1. Search existing issues
2. Check documentation
3. Verify it's reproducible
4. Gather relevant information

### Bug Report Template

```markdown
**Describe the bug**
A clear description of the bug

**To Reproduce**
Steps to reproduce:
1. Go to '...'
2. Click on '...'
3. See error

**Expected behavior**
What should happen

**Screenshots**
Add screenshots if applicable

**Environment**
- Flutter version:
- Dart version:
- OS:
- Device:

**Additional context**
Any other relevant information
```

### Feature Request Template

```markdown
**Feature Description**
Clear description of the feature

**Use Case**
Why is this feature needed?

**Proposed Solution**
How should it work?

**Alternatives Considered**
Other solutions you've considered

**Additional Context**
Any other relevant information
```

---

## 🎯 Areas Needing Contribution

### High Priority
- [ ] Add more test coverage
- [ ] Improve error handling
- [ ] Add data validation
- [ ] Performance optimization

### Medium Priority
- [ ] Dark mode support
- [ ] Internationalization (i18n)
- [ ] Export to PDF
- [ ] Visualization charts

### Low Priority
- [ ] Additional themes
- [ ] Animation improvements
- [ ] Code refactoring
- [ ] Documentation improvements

---

## 📞 Getting Help

Need help contributing?

- **Documentation**: Check [docs/](docs/) folder
- **Discussions**: GitHub Discussions
- **Issues**: Ask questions with `question` label

---

## 🏆 Recognition

Contributors will be:
- Listed in [CONTRIBUTORS.md](CONTRIBUTORS.md)
- Mentioned in release notes
- Credited in documentation
- Invited to the contributors team

---

## 📜 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

## 🙏 Thank You!

Every contribution, no matter how small, makes a difference. Thank you for helping improve this project!

---

**Questions?** Open an issue with the `question` label.

**Ready to contribute?** Fork the repo and submit your first PR!

