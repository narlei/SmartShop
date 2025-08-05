# SmartShop - Modular iOS Architecture with Tuist

A modular iOS application demonstrating clean architecture principles using **Tuist** for project generation and dependency management.
If you like this idea, and plan to use it in your project, send me a message to talk about your experience: https://www.linkedin.com/in/narlei/

## Table of Contents

- [🏗️ Modular Architecture with Tuist](#modular-architecture-with-tuist)
- [📁 Project Structure](#project-structure)
- [🧩 uFeature Modules](#ufeature-modules)
  - [Module Structure](#module-structure)
  - [Interface vs Implementation](#interface-vs-implementation)
- [🔧 Module Configuration with Project.swift](#module-configuration-with-projectswift)
- [🚀 Benefits of This Architecture](#benefits-of-this-architecture)
- [🛠️ Getting Started](#getting-started)
  - [⚡ Quick Start (One Command)](#quick-start-one-command)
  - [Manual Steps (If Needed)](#manual-steps-if-needed)
- [📈 Adding New Modules](#adding-new-modules)
- [🧪 Testing Configuration](#testing-configuration)
- [⚡ Makefile Automation](#makefile-automation)
- [🔄 Continuous Integration](#continuous-integration)
- [🏆 Best Practices](#best-practices)

## Modular Architecture with Tuist

This project showcases a **modular architecture** where each feature is isolated into its own module, promoting:

- **Separation of Concerns**: Each module has a single responsibility
- **Scalability**: Easy to add new features without affecting existing code
- **Testability**: Each module can be tested independently
- **Reusability**: Modules can be shared across different projects
- **Build Performance**: Parallel compilation and incremental builds

### Why Tuist?

**Tuist** is used for:
- **Project Generation**: Automatically generates Xcode projects and workspaces
- **Dependency Management**: Clean and explicit dependency declarations
- **Module Configuration**: Standardized module structure across the project
- **Build Optimization**: Smart caching and dependency resolution

## Project Structure

```
SmartShop/
├── Workspace.swift              # Main workspace configuration
├── Modules/                     # All feature modules
│   ├── App/                     # Main application module
│   ├── uNetwork/                # Network feature module
│   └── uHome/                   # Home feature module
└── Tuist/                       # Tuist configuration helpers
    └── ProjectDescriptionHelpers/
```

## uFeature Modules

Each **uFeature** follows a consistent structure:

### Module Structure
```
uFeatureName/
├── Interface/                   # Public API (protocols, models, enums)
├── Implementation/              # Internal implementation
└── Project.swift               # Module-specific Tuist configuration
```

### Interface vs Implementation

#### **Interface** (`FeatureInterface`)
- Contains **public protocols** that other modules can depend on
- Defines **data models** and **public APIs**
- Has **no implementation details**
- Other modules import only the Interface

```swift
// Example: HomeInterface
public protocol HomeViewControllerProtocol: AnyObject {
    func presentHome()
}

public struct TaskItem {
    public let id: String
    public var title: String
    public var isCompleted: Bool
}
```

#### **Implementation** (`Feature`)
- Contains **concrete implementations** of the Interface protocols
- Includes **UI components**, **business logic**, and **internal classes**
- Imports the corresponding Interface module
- Hidden from other modules

```swift
// Example: Home Implementation
import HomeInterface

public final class HomeViewController: UIViewController, HomeViewControllerProtocol {
    // Implementation details...
}
```

## Module Configuration with Project.swift

Each uFeature has its own `Project.swift` file that:

1. **Defines the module structure** (Interface + Implementation)
2. **Declares dependencies** on other modules
3. **Configures build settings** specific to that module

### Example: Home Module Project.swift

```swift
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: Feature.Home.rawValue,
    targets: [
        // Interface target (public API)
        .feature(
            interface: .Home,
            dependencies: [
                // Interface can depend on other interfaces only
            ]
        ),
        // Implementation target (concrete implementation)
        .feature(
            implementation: .Home,
            dependencies: [
                .feature(interface: .Network),    // Import other interfaces
                .feature(interface: .Home),       // Import own interface
            ]
        ),
        // Test target (unit tests)
        .test(
            implementation: .Home,
            dependencies: [
                .feature(interface: .Home)        // Test can access interfaces
            ]
        )
    ]
)
```

### Example: App Module Project.swift

```swift
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: Feature.App.rawValue,
    targets: [
        .makeApp(
            name: "SmartShop",
            sources: ["Core/**"],
            dependencies: [
                .feature(implementation: .Home),    // Use concrete implementations
                .feature(interface: .Home)          // Access public interfaces
            ]
        )
    ]
)
```

## 🔗 Dependency Flow

```
App Module
    ↓ (imports implementation)
Home Implementation
    ↓ (imports interface)
Home Interface
    ↓ (imports interface)
Network Interface
```

### Key Principles:

1. **Interface modules** can only depend on other **Interface modules**
2. **Implementation modules** must import their corresponding **Interface**
3. **App module** imports **Implementation modules** for concrete usage
4. **Cross-module communication** happens through **Interface protocols**

## Benefits of This Architecture

### For Development:
- **Independent Development**: Teams can work on different modules simultaneously
- **Clear Contracts**: Interfaces define clear contracts between modules
- **Reduced Conflicts**: Fewer merge conflicts due to module separation

### For Testing:
- **Unit Testing**: Each module can be tested independently
- **Mocking**: Easy to mock dependencies through interfaces
- **Integration Testing**: Test module interactions through well-defined interfaces

### For Build Performance:
- **Parallel Compilation**: Modules compile independently
- **Incremental Builds**: Only changed modules need recompilation
- **Caching**: Tuist can cache unchanged modules

## Getting Started

### Quick Start (One Command)

```bash
make dev
```

This single command will:
1. Install Tuist (if not already installed)
2. Clean any previous cache
3. Generate all modules and the main workspace
4. Open the project in Xcode

### Manual Steps (If Needed)

1. **Install Tuist**:
   ```bash
   curl -Ls https://install.tuist.io | bash
   ```

2. **Generate the project**:
   ```bash
   tuist dev
   ```

3. **Open the workspace**:
   ```bash
   open SmartShop.xcworkspace
   ```

## Adding New Modules

To add a new uFeature module:

1. **Create the module structure**:
   ```
   Modules/uNewFeature/
   ├── Interface/
   ├── Implementation/
   └── Project.swift
   ```

2. **Define the module in Project.swift**:
   ```swift
   let project = Project(
       name: Feature.NewFeature.rawValue,
       targets: [
           .feature(interface: .NewFeature, dependencies: []),
           .feature(implementation: .NewFeature, dependencies: [
               .feature(interface: .NewFeature)
           ])
       ]
   )
   ```

3. **Add to Feature enum** in `ProjectDescriptionHelpers`

4. **Import in dependent modules** as needed

## Testing Configuration

Each module can have its own test suite to ensure code quality and module isolation.

### Adding Tests to a Module

To add tests to a uFeature module, include a test target in the `Project.swift`:

```swift
let project = Project(
    name: Feature.Home.rawValue,
    targets: [
        // Interface target
        .feature(
            interface: .Home,
            dependencies: []
        ),
        // Implementation target
        .feature(
            implementation: .Home,
            dependencies: [
                .feature(interface: .Home)
            ]
        ),
        // Test target
        .test(
            implementation: .Home,
            dependencies: [
                .feature(interface: .Home)
            ]
        )
    ]
)
```

### Test Structure

Tests are organized following the module structure:

```
uFeatureName/
├── Interface/
├── Implementation/
│   ├── Sources/              # Implementation code
│   └── Tests/
│       └── Sources/          # Test files
│           └── FeatureTests.swift
└── Project.swift
```

### Running Tests

```bash
# Run all tests
make test

# Build and test manually
xcodebuild -workspace SmartShop.xcworkspace -scheme Home -destination 'platform=iOS Simulator,name=iPhone 15' test
```

### Test Types Supported

- **Unit Tests**: Test individual components and business logic
- **Integration Tests**: Test module interactions
- **Performance Tests**: Measure performance of critical paths

### Example Test Implementation

```swift
import XCTest
@testable import Home
@testable import HomeInterface

final class HomeModuleTests: XCTestCase {
    
    func testTaskItemInitialization() {
        // Given
        let title = "Test Task"
        
        // When
        let task = TaskItem(title: title)
        
        // Then
        XCTAssertEqual(task.title, title)
        XCTAssertFalse(task.isCompleted)
    }
    
    func testHomeFactoryCreatesViewController() {
        // When
        let viewController = HomeFactory.makeHomeViewController()
        
        // Then
        XCTAssertNotNil(viewController)
        XCTAssertTrue(viewController is HomeViewControllerProtocol)
    }
}
```

### Test Dependencies

- Tests can depend on both **Interface** and **Implementation** targets
- Use `@testable import` to access internal implementation details
- Keep test dependencies minimal to maintain module isolation

## Makefile Automation

The project includes a comprehensive Makefile that automates common development tasks:

### Development Workflow
```bash
# Complete development setup (recommended)
make dev              # Install Tuist + Generate + Open in Xcode

# Individual steps
make install          # Install Tuist if not present
make generate         # Generate all projects and workspace
make open            # Open workspace in Xcode
```

### Build & Test
```bash
make build           # Build the project
make test            # Run all tests
```

### Cleanup
```bash
make clean           # Clean Tuist cache only
make clean-all       # Remove all generated files and cache
```

### Why Use Makefile?
- **Consistency**: Same commands work for all team members
- **Automation**: No need to remember complex Tuist commands
- **Safety**: Handles dependencies and cleanup automatically
- **Speed**: Quick shortcuts for common operations

## Continuous Integration

This project is integrated with GitHub Actions. On every push or pull request to the **main** branch, the workflow `.github/workflows/makefile.yml` runs the Makefile targets (`make install`, `make test`) on a macOS runner to ensure code is generated, built, and tested automatically.

## Best Practices

### Module Design
- **Keep interfaces minimal**: Only expose what other modules need
- **Avoid circular dependencies**: Design modules with clear hierarchy
- **Use dependency injection**: Pass dependencies through initializers
- **Follow naming conventions**: Use clear, descriptive names for modules
- **Document public APIs**: Add documentation to interface protocols

### Testing Strategy
- **Test each module independently**: Keep tests isolated to their respective modules
- **Test public interfaces**: Focus on testing the contracts between modules
- **Use dependency injection for testing**: Make dependencies mockable through protocols
- **Include performance tests**: Measure critical paths and prevent regressions
- **Test both success and failure scenarios**: Ensure robust error handling

### Project Organization
- **Consistent module structure**: Follow the Interface/Implementation pattern
- **Clear dependency hierarchy**: Interfaces depend only on other interfaces
- **Meaningful commit messages**: Reference the affected modules
- **Regular dependency updates**: Keep external dependencies current

---

This architecture demonstrates how **Tuist** and **modular design** can create a scalable, maintainable iOS application that grows with your team and requirements.
