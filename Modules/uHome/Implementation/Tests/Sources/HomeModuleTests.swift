import XCTest
import UIKit
@testable import Home
@testable import HomeInterface

final class HomeModuleTests: XCTestCase {
    
    // MARK: - TaskItem Tests
    
    func testTaskItemInitialization() {
        // Given
        let title = "Test Task"
        let id = "test-id"
        let createdAt = Date()
        
        // When
        let task = TaskItem(id: id, title: title, isCompleted: false, createdAt: createdAt)
        
        // Then
        XCTAssertEqual(task.id, id)
        XCTAssertEqual(task.title, title)
        XCTAssertFalse(task.isCompleted)
        XCTAssertEqual(task.createdAt, createdAt)
    }
    
    func testTaskItemDefaultValues() {
        // Given
        let title = "Test Task"
        
        // When
        let task = TaskItem(title: title)
        
        // Then
        XCTAssertFalse(task.id.isEmpty)
        XCTAssertEqual(task.title, title)
        XCTAssertFalse(task.isCompleted)
        XCTAssertNotNil(task.createdAt)
    }
    
    func testTaskItemMutability() {
        // Given
        var task = TaskItem(title: "Original Title")
        let newTitle = "Updated Title"
        
        // When
        task.title = newTitle
        task.isCompleted = true
        
        // Then
        XCTAssertEqual(task.title, newTitle)
        XCTAssertTrue(task.isCompleted)
    }
    
    // MARK: - HomeFactory Tests
    
    func testHomeFactoryCreatesViewController() {
        // When
        let viewController = HomeFactory.makeHomeViewController()
        
        // Then
        XCTAssertNotNil(viewController)
        XCTAssertTrue(viewController is HomeViewControllerProtocol)
    }
    
    func testHomeFactoryCreatesUIViewController() {
        // When
        let viewController = HomeFactory.makeHomeViewControllerAsUIViewController()
        
        // Then
        XCTAssertNotNil(viewController)
        XCTAssertTrue(viewController is UIViewController)
    }
    
    // MARK: - HomeViewController Tests
    
    func testHomeViewControllerInitialization() {
        // When
        let viewController = HomeViewController()
        
        // Then
        XCTAssertNotNil(viewController)
        XCTAssertTrue(viewController is HomeViewControllerProtocol)
        XCTAssertTrue(viewController is UIViewController)
    }
    
    func testHomeViewControllerViewDidLoad() {
        // Given
        let viewController = HomeViewController()
        
        // When
        viewController.loadViewIfNeeded()
        
        // Then
        XCTAssertNotNil(viewController.view)
        XCTAssertEqual(viewController.view.backgroundColor, .systemBackground)
        XCTAssertEqual(viewController.title, "Task List")
    }
    
    func testHomeViewControllerHasNavigationItems() {
        // Given
        let viewController = HomeViewController()
        
        // When
        viewController.loadViewIfNeeded()
        
        // Then
        XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    // MARK: - TaskTableViewCell Tests
    
    func testTaskTableViewCellIdentifier() {
        // Then
        XCTAssertEqual(TaskTableViewCell.identifier, "TaskTableViewCell")
    }
    
    func testTaskTableViewCellInitialization() {
        // When
        let cell = TaskTableViewCell(style: .default, reuseIdentifier: TaskTableViewCell.identifier)
        
        // Then
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell.reuseIdentifier, TaskTableViewCell.identifier)
    }
    
    func testTaskTableViewCellConfiguration() {
        // Given
        let cell = TaskTableViewCell(style: .default, reuseIdentifier: TaskTableViewCell.identifier)
        let task = TaskItem(title: "Test Task", isCompleted: false)
        
        // When
        cell.configure(with: task)
        
        // Then
        // Note: We can't directly test private UI elements, but we can test that configuration doesn't crash
        XCTAssertNotNil(cell)
    }
    
    func testTaskTableViewCellConfigurationWithCompletedTask() {
        // Given
        let cell = TaskTableViewCell(style: .default, reuseIdentifier: TaskTableViewCell.identifier)
        let task = TaskItem(title: "Completed Task", isCompleted: true)
        
        // When
        cell.configure(with: task)
        
        // Then
        XCTAssertNotNil(cell)
    }
    
    func testTaskTableViewCellPrepareForReuse() {
        // Given
        let cell = TaskTableViewCell(style: .default, reuseIdentifier: TaskTableViewCell.identifier)
        let task = TaskItem(title: "Test Task")
        cell.configure(with: task)
        
        // When
        cell.prepareForReuse()
        
        // Then
        // The cell should be reset for reuse
        XCTAssertNotNil(cell)
    }
}

// MARK: - Performance Tests

extension HomeModuleTests {
    
    func testTaskItemCreationPerformance() {
        measure {
            for index in 0..<1000 {
                _ = TaskItem(title: "Task \(index)")
            }
        }
    }
    
    func testHomeFactoryPerformance() {
        measure {
            for _ in 0..<100 {
                _ = HomeFactory.makeHomeViewController()
            }
        }
    }
}

// MARK: - Integration Tests

extension HomeModuleTests {
    
    func testCompleteTaskFlow() {
        // Given
        let viewController = HomeViewController()
        viewController.loadViewIfNeeded()
        
        // When - Load view and verify initial state
        
        // Then
        XCTAssertNotNil(viewController.view)
        XCTAssertEqual(viewController.title, "Task List")
        
        // This test verifies that the complete flow can be initiated without crashes
        // More detailed UI testing would require UI testing targets
    }
    
    func testTaskItemDataFlow() {
        // Given
        let originalTask = TaskItem(title: "Original Task")
        
        // When
        var modifiedTask = originalTask
        modifiedTask.title = "Modified Task"
        modifiedTask.isCompleted = true
        
        // Then
        XCTAssertEqual(originalTask.title, "Original Task")
        XCTAssertFalse(originalTask.isCompleted)
        XCTAssertEqual(modifiedTask.title, "Modified Task")
        XCTAssertTrue(modifiedTask.isCompleted)
        XCTAssertEqual(originalTask.id, modifiedTask.id)
        XCTAssertEqual(originalTask.createdAt, modifiedTask.createdAt)
    }
}
