import XCTest
@testable import TaskManagerOOP

final class TaskManagerOOPTests: XCTestCase {
    func testDuplicateTitleThrows() throws {
        let store = TaskStore()
        // Clean start
        try? UserDefaults.standard.removeObject(forKey: "TaskManagerOOP.tasks")
        store.objectWillChange.send()
        
        let a = try WorkTask(title: "Demo")
        try store.add(a)
        let b = try PersonalTask(title: "Demo")
        XCTAssertThrowsError(try store.add(b)) { error in
            XCTAssertEqual(error as? TaskError, .duplicateTitle)
        }
    }
    
    func testToggleCompletionUpdatesTimestamp() throws {
        let t = try WorkTask(title: "Toggle")
        let before = t.updatedAt
        sleep(1)
        t.toggleComplete()
        XCTAssertNotEqual(t.updatedAt, before)
    }
    
    func testDTOFactoryRoundTrip() throws {
        let original = try ShoppingTask(title: "Eggs", quantity: 12, unit: "pcs", dueDate: .days(2), priority: .high)
        let dto = original.toDTO()
        let rebuilt = try DTOFactory.makeTask(from: dto)
        XCTAssertEqual(rebuilt.title, original.title)
        XCTAssertEqual(rebuilt.priority, .high)
        XCTAssertEqual((rebuilt as! ShoppingTask).quantity, 12)
    }
}

